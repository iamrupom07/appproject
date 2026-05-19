import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/stock_badge.dart';
import '../../domain/machine_model.dart';
import '../../domain/machine_model.dart';
import '../providers/home_providers.dart';

/// Reusable vertical card used in Trending Inventory + Recently Added grids.
/// Handles favorite toggle, stock badge, and contact action.
class MachineGridCard extends ConsumerWidget {
  const MachineGridCard({
    super.key,
    required this.machine,
    this.showNewBadge = false,
  });

  final MachineModel machine;

  /// When true, shows a "New" badge instead of the stock status badge.
  final bool showNewBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select((favs) => favs.contains(machine.id)),
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
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badges ─────────────────────────────────────────────
            _CardImage(
              imageUrl: machine.imageUrl,
              isFav: isFav,
              showNewBadge: showNewBadge,
              status: machine.status,
              discountPercent: machine.discountPercent,
              onFavTap: () =>
                  ref.read(favoritesProvider.notifier).toggle(machine.id),
            ),

            // ── Info ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceSm,
                AppSizes.spaceSm,
                AppSizes.spaceSm,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    machine.name,
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    machine.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price upon request',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceSm),

            // ── Contact Button ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceSm,
                0,
                AppSizes.spaceSm,
                AppSizes.spaceSm,
              ),
              child: _ContactButton(
                onTap: () {/* navigate to contact */},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card Image ───────────────────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.imageUrl,
    required this.isFav,
    required this.showNewBadge,
    required this.status,
    required this.onFavTap,
    this.discountPercent,
  });

  final String imageUrl;
  final bool isFav;
  final bool showNewBadge;
  final StockStatus status;
  final VoidCallback onFavTap;
  final int? discountPercent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(color: AppColors.shimmerBase),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.pageBackground,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // Stock / New badge — top-left
        Positioned(
          top: AppSizes.spaceSm,
          left: AppSizes.spaceSm,
          child: showNewBadge ? _NewBadge() : StockBadge(status: status),
        ),

        // Favorite heart — bottom-right
        Positioned(
          bottom: AppSizes.spaceSm,
          right: AppSizes.spaceSm,
          child: _FavoriteHeart(isFav: isFav, onTap: onFavTap),
        ),

        // Discount badge — top-right (only when discount is active)
        if (discountPercent != null)
          Positioned(
            top: AppSizes.spaceSm,
            right: AppSizes.spaceSm,
            child: DiscountBadge(percent: discountPercent!),
          ),
      ],
    );
  }
}

// ─── New Badge ────────────────────────────────────────────────────────────────

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.newBadge,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        'New',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
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
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFav),
            color: isFav ? Colors.redAccent : Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

// ─── Contact Button ───────────────────────────────────────────────────────────

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 13,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Contact',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
