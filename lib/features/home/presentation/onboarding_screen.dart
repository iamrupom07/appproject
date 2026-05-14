import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../domain/onboarding_model.dart';
import 'widgets/onboarding_page.dart';

/// Onboarding screen — shown after the splash, before the main app.
///
/// Features:
///   • PageView driven by [onboardingPages] data list
///   • "Skip" text button (top-right) — jumps straight to /home
///   • SmoothPageIndicator dot row (bottom-left)
///   • Circular arrow FAB (bottom-right) — advances to next page
///   • "Get Started" CTA button on the last page
///   • Light status-bar overlay (cream background pages)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // For the "Get Started" CTA slide-up animation on last page
  late final AnimationController _ctaController;
  late final Animation<Offset> _ctaSlide;
  late final Animation<double> _ctaOpacity;

  bool get _isLastPage => _currentPage == onboardingPages.length - 1;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _ctaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic));

    _ctaOpacity =
        CurvedAnimation(parent: _ctaController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    if (index == onboardingPages.length - 1) {
      _ctaController.forward();
    } else {
      _ctaController.reverse();
    }
  }

  void _nextPage() {
    if (_isLastPage) {
      _goToHome();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToHome() {
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ── Page content ─────────────────────────────────────────
            Column(
              children: [
                // Skip button row
                _SkipRow(onSkip: _goToHome),

                // Page slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: onboardingPages.length,
                    itemBuilder: (context, index) {
                      return _AnimatedPage(
                        key: ValueKey(index),
                        child: OnboardingPage(model: onboardingPages[index]),
                      );
                    },
                  ),
                ),

                // Bottom controls row
                _BottomBar(
                  pageController: _pageController,
                  totalPages: onboardingPages.length,
                  onArrowTap: _nextPage,
                  bottomPadding: bottomPadding,
                ),
              ],
            ),

            // ── "Get Started" CTA (last page) ────────────────────────
            Positioned(
              left: AppSizes.spaceLg,
              right: AppSizes.spaceLg,
              bottom: bottomPadding + 80,
              child: SlideTransition(
                position: _ctaSlide,
                child: FadeTransition(
                  opacity: _ctaOpacity,
                  child: _GetStartedButton(onTap: _goToHome),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Adds a subtle slide-in entrance animation to each page.
class _AnimatedPage extends StatefulWidget {
  const _AnimatedPage({super.key, required this.child});
  final Widget child;

  @override
  State<_AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<_AnimatedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// "Skip" top-right button.
class _SkipRow extends StatelessWidget {
  const _SkipRow({required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSizes.spaceSm,
          right: AppSizes.spaceLg,
        ),
        child: TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Skip',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom row: dot indicators (left) + arrow FAB (right).
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pageController,
    required this.totalPages,
    required this.onArrowTap,
    required this.bottomPadding,
  });

  final PageController pageController;
  final int totalPages;
  final VoidCallback onArrowTap;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceLg,
        AppSizes.spaceMd,
        AppSizes.spaceLg,
        bottomPadding + AppSizes.spaceMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dot indicators
          SmoothPageIndicator(
            controller: pageController,
            count: totalPages,
            effect: ExpandingDotsEffect(
              dotWidth: 8,
              dotHeight: 8,
              expansionFactor: 2.5,
              spacing: 5,
              dotColor: AppColors.divider,
              activeDotColor: AppColors.gold,
            ),
          ),

          // Arrow FAB
          GestureDetector(
            onTap: onArrowTap,
            child: Container(
              width: AppSizes.fabSize,
              height: AppSizes.fabSize,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold "Get Started" CTA — animates in on the last page.
class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'Get Started',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
