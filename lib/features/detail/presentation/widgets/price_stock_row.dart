import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/stock_badge.dart';
import '../../../home/domain/machine_model.dart';

/// Price on the left, availability badge on the right.
class PriceStockRow extends StatelessWidget {
  const PriceStockRow({
    super.key,
    required this.price,
    required this.status,
  });

  final double price;
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
              _formatPrice(price),
              style: AppTextStyles.priceLarge,
            ),
          ],
        ),
        const Spacer(),
        _StockPill(status: status),
      ],
    );
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '\$$formatted';
  }
}

// ─── Extended Stock Pill (icon + label + sub-label) ───────────────────────────

class _StockPill extends StatelessWidget {
  const _StockPill({required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _color(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd,
        vertical: AppSizes.spaceSm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
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
                    color: color.withOpacity(0.75),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Color _color(StockStatus s) => switch (s) {
        StockStatus.inStock => AppColors.inStock,
        StockStatus.lowStock => AppColors.lowStock,
        StockStatus.outOfStock => AppColors.outOfStock,
      };
}
