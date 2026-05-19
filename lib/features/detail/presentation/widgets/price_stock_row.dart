import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../home/domain/machine_model.dart';

/// "Upon Request" price label on the left, stock pill on the right.
class PriceStockRow extends StatelessWidget {
  const PriceStockRow({
    super.key,
    required this.status,
  });

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              'Upon Request',
              style: AppTextStyles.priceLarge.copyWith(fontSize: 18),
            ),
          ],
        ),
        const Spacer(),
        _StockPill(status: status),
      ],
    );
  }
}

// ─── Extended Stock Pill (dot + label) ───────────────────────────────────────

class _StockPill extends StatelessWidget {
  const _StockPill({required this.status});

  final StockStatus status;

  Color get _color {
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
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd,
        vertical: AppSizes.spaceSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              if (status == StockStatus.inStock)
                Text(
                  'Available Now',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
              if (status == StockStatus.lowStock)
                Text(
                  'Hurry — Few Left',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
