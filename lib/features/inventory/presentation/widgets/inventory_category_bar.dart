import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../home/domain/machine_model.dart';
import '../providers/inventory_providers.dart';

/// Horizontally scrollable category chip row.
/// Reuses [MachineCategory] enum from the home feature.
class InventoryCategoryBar extends ConsumerWidget {
  const InventoryCategoryBar({super.key});

  // Categories shown in the bar (subset + "More" placeholder)
  static const List<MachineCategory> _categories = [
    MachineCategory.all,
    MachineCategory.excavators,
    MachineCategory.wheelLoaders,
    MachineCategory.bulldozers,
    MachineCategory.dumpTrucks,
    MachineCategory.graders,
    MachineCategory.cranes,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(inventoryCategoryProvider);

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isActive = category == selected;
          return _CategoryChip(
            category: category,
            isActive: isActive,
            onTap: () =>
                ref.read(inventoryCategoryProvider.notifier).state = category,
          );
        },
      ),
    );
  }
}

// ─── Individual Chip ──────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final MachineCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 72,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withOpacity(0.15)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isActive ? AppColors.gold : AppColors.divider,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconFor(category),
              size: 24,
              color: isActive ? AppColors.gold : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              category.label,
              style: AppTextStyles.labelSmall.copyWith(
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 9.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(MachineCategory cat) => switch (cat) {
        MachineCategory.all => Icons.grid_view_rounded,
        MachineCategory.excavators => Icons.precision_manufacturing_rounded,
        MachineCategory.wheelLoaders => Icons.agriculture_rounded,
        MachineCategory.bulldozers => Icons.construction_rounded,
        MachineCategory.dumpTrucks => Icons.local_shipping_rounded,
        MachineCategory.graders => Icons.straighten_rounded,
        MachineCategory.cranes => Icons.account_tree_rounded,
      };
}
