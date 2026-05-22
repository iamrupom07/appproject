import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/onboarding_model.dart';
import 'search_preview_widget.dart';

/// Renders a single onboarding slide.
///
/// Supports two layout variants via [OnboardingPageType]:
///   • [OnboardingPageType.image] — large hero image card + optional trust badge.
///   • [OnboardingPageType.searchPreview] — SearchPreviewWidget mock UI.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.model});

  final OnboardingPageModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Hero area — switches by page type ───────────────────────
        if (model.pageType == OnboardingPageType.searchPreview)
          const SearchPreviewWidget()
        else
          _HeroImageCard(model: model),

        const SizedBox(height: AppSizes.spaceLg + 4),

        // ── Heading ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
          child: Text(
            model.heading,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spaceSm + 2),

        // ── Body ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
          child: Text(
            model.body,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Hero image with rounded card styling and an optional floating trust badge.
class _HeroImageCard extends StatelessWidget {
  const _HeroImageCard({required this.model});

  final OnboardingPageModel model;

  @override
  Widget build(BuildContext context) {
    final imageUrl = model.imageUrl ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main image card
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg + 4),
            child: AspectRatio(
              aspectRatio: 1.05,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.pageBackground,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.gold,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                    )
                  : _ImagePlaceholder(),
            ),
          ),

          // Floating trust badge (slide 1 only)
          if (model.showTrustBadge &&
              model.trustBadgeTitle != null &&
              model.trustBadgeSubtitle != null)
            Positioned(
              bottom: -AppSizes.spaceMd,
              left: AppSizes.spaceMd,
              right: AppSizes.spaceLg + AppSizes.spaceLg,
              child: _TrustBadgeCard(
                title: model.trustBadgeTitle!,
                subtitle: model.trustBadgeSubtitle!,
              ),
            ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      child: const Center(
        child:
            Icon(Icons.construction_rounded, size: 80, color: AppColors.gold),
      ),
    );
  }
}

/// White floating card with shield icon and gold checkmark.
class _TrustBadgeCard extends StatelessWidget {
  const _TrustBadgeCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd,
        vertical: AppSizes.spaceSm + 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shield icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.pageBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(Icons.verified_user_outlined,
                size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSizes.spaceSm + 2),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Gold checkmark
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check_rounded, size: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
