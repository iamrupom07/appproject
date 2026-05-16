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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.inStock.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        'Available',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.inStock,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
