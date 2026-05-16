import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../home/presentation/providers/home_providers.dart';

/// Horizontally scrollable sort-chip row for the Favorites screen.
/// Uses the same pill-chip visual pattern as [InventoryCategoryBar].
class FavoritesSortBar extends ConsumerWidget {
  const FavoritesSortBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(favoritesSortProvider);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: FavoritesSort.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
        itemBuilder: (context, index) {
          final sort = FavoritesSort.values[index];
          final isActive = sort == selected;
          return _SortChip(
            sort: sort,
            isActive: isActive,
            onTap: () => ref.read(favoritesSortProvider.notifier).state = sort,
          );
        },
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.sort,
    required this.isActive,
    required this.onTap,
  });

  final FavoritesSort sort;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMd,
          vertical: AppSizes.spaceXs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          border: Border.all(
            color: isActive ? AppColors.gold : AppColors.divider,
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconFor(sort),
              size: 13,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              sort.label,
              style: AppTextStyles.labelSmall.copyWith(
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(FavoritesSort s) => switch (s) {
        FavoritesSort.recent => Icons.access_time_rounded,
        FavoritesSort.priceAsc => Icons.arrow_upward_rounded,
        FavoritesSort.priceDesc => Icons.arrow_downward_rounded,
        FavoritesSort.category => Icons.category_rounded,
      };
}
