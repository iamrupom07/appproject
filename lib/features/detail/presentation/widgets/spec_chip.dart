import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// One of the four stat boxes displayed under the price row.
/// Shows an icon, a bold value, and a muted label.
class SpecChip extends StatelessWidget {
  const SpecChip({
    super.key,
    required this.iconAsset,
    required this.value,
    required this.label,
  });

  final String iconAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSm,
        vertical: AppSizes.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconFor(iconAsset),
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headingSmall.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(String asset) => switch (asset) {
        'power' => Icons.bolt_rounded,
        'bucket' => Icons.water_drop_outlined,
        'depth' => Icons.height_rounded,
        'weight' => Icons.fitness_center_rounded,
        _ => Icons.settings_outlined,
      };
}
