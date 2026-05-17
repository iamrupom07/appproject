import 'package:abroz_parts_plus/features/home/presentation/providers/home_providers.dart';
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

/// Horizontal list card for inventory list-view mode.
class InventoryListCard extends ConsumerWidget {
  const InventoryListCard({
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
        height: 110,
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
        child: Row(
          children: [
            // ── Thumbnail ────────────────────────────────────────────────
            SizedBox(
              width: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
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
                  Positioned(
                    top: AppSizes.spaceSm,
                    left: AppSizes.spaceSm,
                    child: StockBadge(status: machine.status),
                  ),
                ],
              ),
            ),

            // ── Details ──────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            machine.name,
                            style: AppTextStyles.headingSmall
                                .copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _FavoriteHeart(
                          isFav: isFav,
                          onTap: () => ref
                              .read(favoritesProvider.notifier)
                              .toggle(machine.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      machine.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'Price upon request',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        ContactButton(
                          onTap: () {/* navigate to contact */},
                          height: 28,
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
}

class _FavoriteHeart extends StatelessWidget {
  const _FavoriteHeart({required this.isFav, required this.onTap});

  final bool isFav;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFav),
          color: isFav ? Colors.redAccent : AppColors.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}
