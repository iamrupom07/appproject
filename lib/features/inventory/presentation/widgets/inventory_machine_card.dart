import 'package:ab_abroz_inventory/features/home/presentation/providers/home_providers.dart';
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
import '../../../../features/home/presentation/providers/home_providers.dart';
import '../../domain/inventory_machine_model.dart';

/// Grid card for the Inventory screen.
/// Matches the design: image with overlays, spec row, price + contact.
class InventoryMachineCard extends ConsumerWidget {
  const InventoryMachineCard({
    super.key,
    required this.machine,
  });

  final InventoryMachineModel machine;

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
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image with overlays ────────────────────────────────────────
            _CardImage(
              machine: machine,
              isFav: isFav,
              onFavTap: () =>
                  ref.read(favoritesProvider.notifier).toggle(machine.id),
            ),

            // ── Text info ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    machine.name,
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Subtitle
                  Text(
                    machine.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // ── Specs row ────────────────────────────────────────────
                  _SpecsRow(machine: machine),

                  const SizedBox(height: 10),

                  // ── Price + Contact ──────────────────────────────────────
                  Row(
                    children: [
                      Text(
                        _formatPrice(machine.price),
                        style: AppTextStyles.priceSmall,
                      ),
                      const Spacer(),
                      ContactButton(
                        onTap: () {/* navigate to contact */},
                        height: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
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

// ─── Card Image with overlays ─────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.machine,
    required this.isFav,
    required this.onFavTap,
  });

  final InventoryMachineModel machine;
  final bool isFav;
  final VoidCallback onFavTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Machine image ──────────────────────────────────────────────────
        AspectRatio(
          aspectRatio: 4 / 3,
          child: CachedNetworkImage(
            imageUrl: machine.imageUrl,
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

        // ── Gradient scrim (bottom) ────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
        ),

        // ── Stock badge — top-left ─────────────────────────────────────────
        Positioned(
          top: AppSizes.spaceSm,
          left: AppSizes.spaceSm,
          child: StockBadge(status: machine.status),
        ),

        // ── Favorite heart — top-right ─────────────────────────────────────
        Positioned(
          top: AppSizes.spaceSm,
          right: AppSizes.spaceSm,
          child: _FavoriteHeart(isFav: isFav, onTap: onFavTap),
        ),

        // ── Photo counter — bottom-left ────────────────────────────────────
        Positioned(
          bottom: 6,
          left: AppSizes.spaceSm,
          child: _PhotoCounter(current: 1, total: machine.totalImages),
        ),
      ],
    );
  }
}

// ─── Specs Row ────────────────────────────────────────────────────────────────

class _SpecsRow extends StatelessWidget {
  const _SpecsRow({required this.machine});

  final InventoryMachineModel machine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SpecItem(
            icon: Icons.fitness_center_rounded,
            value: machine.formattedWeight,
            label: 'Operating Weight',
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _SpecItem(
            icon: Icons.water_rounded,
            value: machine.formattedCapacity,
            label: machine.capacityLabel,
          ),
        ),
      ],
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(fontSize: 9.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Photo Counter ────────────────────────────────────────────────────────────

class _PhotoCounter extends StatelessWidget {
  const _PhotoCounter({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_library_outlined,
              size: 10, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            '$current/$total',
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
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
            size: 17,
          ),
        ),
      ),
    );
  }
}
