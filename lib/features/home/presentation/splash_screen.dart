import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'widgets/animated_logo.dart';
import 'widgets/loading_bar.dart';

/// Splash / launch screen for ABROZ Machinery.
///
/// Flow:
///   1. Sets dark system UI overlay for full immersion.
///   2. Shows animated logo (fade + slide up) after a short delay.
///   3. Shows hero excavator illustration fading in.
///   4. Loading bar fills over ~2.8 s, then navigates to /home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final AnimationController _taglineController;

  late final Animation<double> _heroOpacity;
  late final Animation<double> _heroScale;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Force dark status/nav bar for the splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Hero excavator image animation
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _heroOpacity = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOut,
    );

    _heroScale = Tween<double>(begin: 1.06, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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

    // Stagger the entrance animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _heroController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _taglineController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _taglineController.dispose();

    // Restore default system UI when leaving splash
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

  void _onLoadComplete() {
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background gradient + atmospheric glow ──────────────────
          _SplashBackground(screenHeight: size.height),

          // ── Hero excavator image (bottom half) ──────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height * 0.52,
            child: _HeroImage(
              opacity: _heroOpacity,
              scale: _heroScale,
            ),
          ),

          // ── Dark vignette over the bottom ───────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height * 0.38,
            child: const _BottomVignette(),
          ),

          // ── Main content column ─────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Top spacer — pushes logo to vertical center-ish
                SizedBox(height: size.height * 0.1),

                // Animated brand logo
                const AnimatedLogo(
                  animate: true,
                  delay: Duration(milliseconds: 100),
                  logoSize: 84,
                  wordmarkFontSize: 38,
                  subbrandFontSize: 11.5,
                ),

                const Spacer(),

                // Tagline block
                _TaglineBlock(
                  opacity: _taglineOpacity,
                  slide: _taglineSlide,
                ),

                SizedBox(height: AppSizes.spaceLg),

                // Loading bar + label
                _LoadingSection(onComplete: _onLoadComplete),

                SizedBox(height: AppSizes.spaceLg + 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (private, file-scoped)
// ─────────────────────────────────────────────────────────────────────────────

/// Full-screen dark background with a warm amber radial glow near the top
/// (behind the logo) and a cooler subtle gradient overall.
class _SplashBackground extends StatelessWidget {
  const _SplashBackground({required this.screenHeight});
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient — dark charcoal to near-black
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

        // Warm amber glow behind logo area
        Positioned(
          top: -screenHeight * 0.05,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.12),
                    AppColors.gold.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Fading, very-slightly-scaling excavator hero image.
/// Uses a network image placeholder — swap the URL for your asset.
class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.opacity,
    required this.scale,
  });

  final Animation<double> opacity;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: scale,
        alignment: Alignment.bottomCenter,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.white, Colors.white],
            stops: [0.0, 0.22, 1.0],
          ).createShader(bounds),
          blendMode: BlendMode.dstIn,
          child: Image.network(
            // Replace with AssetImage once you add your own excavator asset.
            // e.g., Image.asset('assets/images/excavator_hero.png')
            'https://images.unsplash.com/photo-1581093804475-577d72e35330?w=800&q=80',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) =>
                const _ExcavatorPlaceholder(),
          ),
        ),
      ),
    );
  }
}

/// Shown if the network image fails to load.
class _ExcavatorPlaceholder extends StatelessWidget {
  const _ExcavatorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF252528),
      child: Center(
        child: Icon(
          Icons.construction_rounded,
          size: 120,
          color: AppColors.gold.withOpacity(0.25),
        ),
      ),
    );
  }
}

/// Gradient vignette that fades the bottom of the hero image into the bg.
class _BottomVignette extends StatelessWidget {
  const _BottomVignette();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.darkBackground.withOpacity(0.7),
            AppColors.darkBackground,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

/// "Premium Heavy Equipment / Marketplace" tagline.
class _TaglineBlock extends StatelessWidget {
  const _TaglineBlock({
    required this.opacity,
    required this.slide,
  });

  final Animation<double> opacity;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: slide,
        child: Column(
          children: [
            Text(
              'Premium Heavy Equipment',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.82),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Marketplace',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading bar + "Loading experience…" label.
class _LoadingSection extends StatelessWidget {
  const _LoadingSection({required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXl),
      child: Column(
        children: [
          LoadingBar(
            duration: const Duration(milliseconds: 2800),
            color: AppColors.gold,
            height: 3,
            onComplete: onComplete,
          ),
          const SizedBox(height: AppSizes.spaceSm + 2),
          Text(
            'Loading experience...',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.38),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
