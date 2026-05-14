import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/machine_model.dart';

/// Full-width hero carousel for featured machinery.
/// Manages its own page-index state internally.
class FeaturedBannerCarousel extends ConsumerStatefulWidget {
  const FeaturedBannerCarousel({super.key, required this.machines});

  final List<MachineModel> machines;

  @override
  ConsumerState<FeaturedBannerCarousel> createState() =>
      _FeaturedBannerCarouselState();
}

class _FeaturedBannerCarouselState
    extends ConsumerState<FeaturedBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.machines.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // ── Carousel ─────────────────────────────────────────────────────────
        FlutterCarousel.builder(
          itemCount: widget.machines.length,
          itemBuilder: (context, index, _) {
            return _BannerCard(machine: widget.machines[index]);
          },
          options: FlutterCarouselOptions(
            height: 220,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enlargeFactor: 0.04,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOutCubic,
            showIndicator: false,
            onPageChanged: (index, _) => setState(() => _currentIndex = index),
          ),
        ),

        const SizedBox(height: AppSizes.spaceSm),

        // ── Page Indicator ───────────────────────────────────────────────────
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.machines.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.gold,
            dotColor: AppColors.divider,
            spacing: 6,
          ),
        ),
      ],
    );
  }
}

// ─── Banner Card ──────────────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.machine});

  final MachineModel machine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/item/${machine.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          color: const Color(0xFF2A2A2A),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background Image ─────────────────────────────────────────────
            _BannerImage(imageUrl: machine.imageUrl),

            // ── Dark gradient overlay ────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xDD1A1A1A),
                    Color(0x881A1A1A),
                    Color(0x001A1A1A),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // ── Content ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSizes.spaceMd),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: text content
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured badge
                        _FeaturedBadge(),
                        const Spacer(),
                        Text(
                          machine.name,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.textOnDark,
                            height: 1.1,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          machine.subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textOnDark.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceSm),
                        Text(
                          'Starting at',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textOnDark.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          _formatPrice(machine.price),
                          style: AppTextStyles.priceLarge,
                        ),
                        const SizedBox(height: AppSizes.spaceSm),
                        _ViewDetailsButton(
                          onTap: () => context.push('/item/${machine.id}'),
                        ),
                      ],
                    ),
                  ),

                  // Right: status chips
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusChip(
                          icon: Icons.verified_rounded,
                          iconColor: AppColors.gold,
                          label: 'Verified',
                          sublabel: 'Machinery',
                        ),
                        const SizedBox(height: AppSizes.spaceSm),
                        _StatusChip(
                          icon: Icons.inventory_2_outlined,
                          iconColor: AppColors.inStock,
                          label: machine.status.label,
                          sublabel: machine.status == StockStatus.inStock
                              ? 'Available Now'
                              : 'Limited Units',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '\$$formatted';
  }
}

// ─── Featured Badge ────────────────────────────────────────────────────────────

class _FeaturedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(color: AppColors.gold.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.gold, size: 12),
          const SizedBox(width: 4),
          Text(
            'FEATURED',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── View Details Button ──────────────────────────────────────────────────────

class _ViewDetailsButton extends StatelessWidget {
  const _ViewDetailsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View Details',
              style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              Text(
                sublabel,
                style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Banner Image ─────────────────────────────────────────────────────────────

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      alignment: Alignment.centerRight,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.darkCard,
        highlightColor: const Color(0xFF3A3A3A),
        child: Container(color: AppColors.darkCard),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.darkCard,
        child: const Icon(
          Icons.construction_rounded,
          color: AppColors.textSecondary,
          size: 48,
        ),
      ),
    );
  }
}
