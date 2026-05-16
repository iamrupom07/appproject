import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/contact_button.dart';
import '../../../../../core/widgets/stock_badge.dart';
import '../../../../home/domain/machine_model.dart';
import '../../../../home/presentation/providers/home_providers.dart';

/// Full-width horizontal list card used on the Favorites screen.
///
/// Layout:
///   [Image 110×110] | [Name / subtitle / category chip / specs / price+actions]
///
/// Reuses [StockBadge] and [ContactButton] from core widgets.
/// Favorite toggle uses the shared [favoritesProvider] — removing here is
/// reflected everywhere else in the app automatically.
class FavoritesMachineCard extends ConsumerWidget {
  const FavoritesMachineCard({
    super.key,
    required this.machine,
  });

  final MachineModel machine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select((ids) => ids.contains(machine.id)),
    );

    return GestureDetector(
      onTap: () => context.push('/item/${machine.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: image with overlays ──────────────────────────────────
            _CardImage(
              machine: machine,
              isFav: isFav,
              onFavTap: () =>
                  ref.read(favoritesProvider.notifier).toggle(machine.id),
            ),

            // ── Right: details ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spaceMd,
                  AppSizes.spaceMd,
                  AppSizes.spaceMd,
                  AppSizes.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    _CategoryChip(category: machine.category),
                    const SizedBox(height: 6),

                    // Machine name
                    Text(
                      machine.name,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Subtitle
                    Text(
                      machine.subtitle,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spaceSm),

                    // Divider
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: AppSizes.spaceSm),

                    // Price + actions row
                    Row(
                      children: [
                        Text(
                          _formatPrice(machine.price),
                          style: AppTextStyles.priceMedium,
                        ),
                        const Spacer(),
                        ContactButton(
                          onTap: () {/* navigate to contact */},
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final s = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '\$$s';
  }
}

// ─── Card Image ───────────────────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.machine,
    required this.isFav,
    required this.onFavTap,
  });

  final MachineModel machine;
  final bool isFav;
  final VoidCallback onFavTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusMd),
            bottomLeft: Radius.circular(AppSizes.radiusMd),
          ),
          child: CachedNetworkImage(
            imageUrl: machine.imageUrl,
            width: 115,
            height: 140,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                width: 115,
                height: 140,
                color: AppColors.shimmerBase,
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              width: 115,
              height: 140,
              color: AppColors.pageBackground,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // Stock badge — top-left
        Positioned(
          top: AppSizes.spaceSm,
          left: AppSizes.spaceSm,
          child: StockBadge(status: machine.status),
        ),

        // Favorite heart — bottom-right
        Positioned(
          bottom: AppSizes.spaceSm,
          right: AppSizes.spaceSm,
          child: _FavoriteHeart(isFav: isFav, onTap: onFavTap),
        ),
      ],
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final MachineCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        category.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.goldDark,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ─── Favorite Heart ───────────────────────────────────────────────────────────

class _FavoriteHeart extends StatelessWidget {
  const _FavoriteHeart({required this.isFav, required this.onTap});

  final bool isFav;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFav),
            color: isFav ? Colors.redAccent : AppColors.textSecondary,
            size: 16,
          ),
        ),
      ),
    );
  }
}
