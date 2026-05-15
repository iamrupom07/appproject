import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../providers/inventory_providers.dart';

/// "128 Machines Found" label + grid/list toggle buttons.
class InventoryResultHeader extends ConsumerWidget {
  const InventoryResultHeader({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(inventoryViewModeProvider);

    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$count',
                style: AppTextStyles.headingMedium.copyWith(fontSize: 15),
              ),
              TextSpan(
                text: ' Machines Found',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Grid toggle
        _ViewToggleButton(
          icon: Icons.grid_view_rounded,
          isActive: viewMode == InventoryViewMode.grid,
          onTap: () => ref.read(inventoryViewModeProvider.notifier).state =
              InventoryViewMode.grid,
        ),
        const SizedBox(width: AppSizes.spaceSm),
        // List toggle
        _ViewToggleButton(
          icon: Icons.view_list_rounded,
          isActive: viewMode == InventoryViewMode.list,
          onTap: () => ref.read(inventoryViewModeProvider.notifier).state =
              InventoryViewMode.list,
        ),
      ],
    );
  }
}

// ─── Toggle Button ────────────────────────────────────────────────────────────

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isActive ? AppColors.gold : AppColors.divider,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
