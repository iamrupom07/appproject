import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Shown when the favourites list is empty.
/// Uses a subtle animated entrance and a CTA to browse inventory.
class FavoritesEmptyState extends StatefulWidget {
  const FavoritesEmptyState({super.key});

  @override
  State<FavoritesEmptyState> createState() => _FavoritesEmptyStateState();
}

class _FavoritesEmptyStateState extends State<FavoritesEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Slight delay so it doesn't fight the screen transition
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon container ──────────────────────────────────────────
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 40,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceLg),

                // ── Heading ─────────────────────────────────────────────────
                Text(
                  'No favourites yet',
                  style: AppTextStyles.headingLarge.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceSm),

                // ── Sub-copy ────────────────────────────────────────────────
                Text(
                  'Tap the heart on any machine to\nsave it here for quick access.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceXl),

                // ── CTA button ──────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () => context.go('/inventory'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusPill),
                      ),
                    ),
                    child: Text(
                      'Browse Inventory',
                      style: AppTextStyles.buttonLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
