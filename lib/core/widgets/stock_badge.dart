import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../../features/home/domain/machine_model.dart';

/// Reusable pill badge that reflects stock availability.
/// Used on machine cards, detail screens, etc.
class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = _colors(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _colors(StockStatus s) => switch (s) {
        StockStatus.inStock => (
            AppColors.inStock,
            AppColors.inStock.withValues(alpha: 0.12)
          ),
        StockStatus.lowStock => (
            AppColors.lowStock,
            AppColors.lowStock.withValues(alpha: 0.12)
          ),
        StockStatus.outOfStock => (
            AppColors.outOfStock,
            AppColors.outOfStock.withValues(alpha: 0.12)
          ),
      };
}
