import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Sticky bottom bar with "Refine Search" button + gold phone FAB.
class InventoryBottomBar extends StatelessWidget {
  const InventoryBottomBar({
    super.key,
    this.onRefineTap,
    this.onCallTap,
  });

  final VoidCallback? onRefineTap;
  final VoidCallback? onCallTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.spaceMd,
        right: AppSizes.spaceMd,
        bottom: AppSizes.spaceMd,
      ),
      child: Row(
        children: [
          // ── Refine Search pill ─────────────────────────────────────────
          Expanded(
            child: Material(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.12),
              child: InkWell(
                onTap: onRefineTap,
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppSizes.spaceSm),
                      Text(
                        'Refine Search',
                        style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceMd),

          // ── Phone FAB ──────────────────────────────────────────────────
          GestureDetector(
            onTap: onCallTap,
            child: Container(
              width: AppSizes.fabSize,
              height: AppSizes.fabSize,
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.phone_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
