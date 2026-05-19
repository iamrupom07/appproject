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

  Color get _bgColor {
    switch (status) {
      case StockStatus.inStock:
        return AppColors.inStock;
      case StockStatus.lowStock:
        return AppColors.lowStock;
      case StockStatus.outOfStock:
        return AppColors.outOfStock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(color: _bgColor.withValues(alpha: 0.35), width: 0.5),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: _bgColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Compact discount badge — e.g. "-15%"
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        '-$percent%',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
