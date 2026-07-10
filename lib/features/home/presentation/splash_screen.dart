import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../features/products/data/product_providers.dart';
import 'widgets/loading_bar.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _taglineController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  // Tracks whether the API warm-up ping has completed
  bool _apiReady = false;
  // No longer gated behind an artificial timer — set true immediately so
  // navigation only waits on the warm-up/prefetch, not a fixed delay.
  bool _minDelayPassed = false;
  // Prevent double-navigation
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // App name animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineOpacity = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOutCubic),
    );

    // Stagger entrances
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 950), () {
      if (mounted) _taglineController.forward();
    });

    // No artificial minimum hold — navigate as soon as the warm-up/prefetch
    // finishes so the home screen opens without an extra imposed delay.
    _minDelayPassed = true;

    // Prefetch products + categories in parallel during splash so the
    // home screen data is already in the Riverpod cache when we arrive.
    _warmUpAndPrefetch();
  }

  /// 1. Wakes up the Vercel cold-start with a cheap root ping.
  /// 2. Immediately after (or in parallel) kicks off the real product +
  ///    category fetches so the home screen renders instantly on arrival.
  Future<void> _warmUpAndPrefetch() async {
    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.isEmpty) {
        _markApiReady();
        return;
      }

      // Fire the root-ping and the two data fetches simultaneously.
      // The ping wakes the serverless function; the data calls benefit
      // from the warm instance that's already spinning up.
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Build the warmup URL: /api/v1/warmup
      final warmupUrl = baseUrl.endsWith('/api/v1')
          ? '$baseUrl/warmup'
          : '$baseUrl/api/v1/warmup';

      await Future.wait([
        // Lightweight wake-up ping — hits the dedicated /warmup endpoint
        // which responds instantly and warms the DB connection.
        dio.get(warmupUrl).catchError((_) => Response(
              requestOptions: RequestOptions(path: warmupUrl),
              statusCode: 0,
            )),
        // Prefetch products into Riverpod cache
        _prefetchProducts(),
        // Prefetch categories into Riverpod cache
        _prefetchCategories(),
      ]);

      // ignore: avoid_print
      print('[Splash] Warm-up + prefetch complete');
    } catch (e) {
      // ignore: avoid_print
      print('[Splash] Warm-up error (ignored): $e');
    } finally {
      _markApiReady();
    }
  }

  Future<void> _prefetchProducts() async {
    try {
      // Reading the provider causes Riverpod to fire the FutureProvider and
      // cache the result — the home screen will find it ready immediately.
      await ref.read(allProductsProvider.future);
    } catch (_) {}
  }

  Future<void> _prefetchCategories() async {
    try {
      await ref.read(categoriesProvider.future);
    } catch (_) {}
  }

  void _markApiReady() {
    if (!mounted) return;
    setState(() => _apiReady = true);
    _maybeNavigate();
  }

  /// Navigate only when BOTH the minimum delay AND the warm-up are done.
  void _maybeNavigate() {
    if (_navigated) return;
    if (_apiReady && _minDelayPassed) {
      _navigated = true;
      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Dark background with amber glow ──────────────────────────
          _SplashBackground(screenHeight: size.height),

          // ── Content ──────────────────────────────────────────────────
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // ── Logo icon ─────────────────────────────────────────
                FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      width: size.width * 0.22,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceLg),

                // ── App name: Abroz Parts+ ────────────────────────────
                FadeTransition(
                  opacity: _textOpacity,
                  child: SlideTransition(
                    position: _textSlide,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        children: [
                          const TextSpan(text: 'Abroz '),
                          TextSpan(
                            text: 'Parts',
                            style: GoogleFonts.outfit(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: '+',
                            style: GoogleFonts.outfit(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceSm),

                // ── Tagline ───────────────────────────────────────────
                FadeTransition(
                  opacity: _taglineOpacity,
                  child: SlideTransition(
                    position: _taglineSlide,
                    child: Column(
                      children: [
                        Text(
                          'Quality Used Heavy Machinery',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.65),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Komatsu Specialist',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // ── Loading bar ───────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.spaceXl),
                  child: Column(
                    children: [
                      // Bar is purely visual — navigation is driven by
                      // _apiReady + _minDelayPassed, not by bar completion.
                      // Cap at 8 s so it never looks frozen.
                      LoadingBar(
                        duration: const Duration(milliseconds: 8000),
                        color: AppColors.gold,
                        height: 3,
                      ),
                      const SizedBox(height: AppSizes.spaceSm + 2),
                      Text(
                        'Loading experience...',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.35),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.spaceLg + 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Background ───────────────────────────────────────────────────────────────

class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.screenHeight});
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF252528),
                Color(0xFF1C1C1E),
                Color(0xFF141416),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Subtle amber glow behind logo
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.10),
                  AppColors.gold.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
