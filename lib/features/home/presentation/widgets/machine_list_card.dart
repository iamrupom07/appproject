import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/stock_badge.dart';
import '../../domain/machine_model.dart';
import '../providers/home_providers.dart';

/// Production-level machine card for the home list.
/// Handles image loading, favorite toggle, and detail navigation.
class MachineListCard extends ConsumerWidget {
  const MachineListCard({super.key, required this.machine});

  final MachineModel machine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select((favs) => favs.contains(machine.id)),
    );

    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: () => context.push('/item/${machine.id}'),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMd),
          child: Row(
            children: [
              _MachineImage(imageUrl: machine.imageUrl),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockBadge(status: machine.status),
                    const SizedBox(height: AppSizes.spaceXs),
                    Text(
                      machine.name,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      machine.subtitle,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spaceXs),
                    Text(
                      'Price upon request',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FavoriteButton(
                    isFavorite: isFav,
                    onTap: () =>
                        ref.read(favoritesProvider.notifier).toggle(machine.id),
                  ),
                  const SizedBox(height: AppSizes.spaceMd),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MachineImage extends StatelessWidget {
  const _MachineImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: 88,
            height: 88,
            color: AppColors.shimmerBase,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 88,
          height: 88,
          color: AppColors.pageBackground,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.elasticOut,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFavorite),
          color: isFavorite ? Colors.redAccent : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}
