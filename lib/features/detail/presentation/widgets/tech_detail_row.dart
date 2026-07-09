import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// A single row in the Technical Details grid.
/// Renders an icon, a muted label, and a bold value side by side.
class TechDetailRow extends StatelessWidget {
  const TechDetailRow({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.value,
  });

  final String iconAsset;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          _iconFor(iconAsset),
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.headingSmall.copyWith(fontSize: 13),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  static IconData _iconFor(String asset) => switch (asset) {
        'engine' => Icons.settings_outlined,
        'clock' => Icons.access_time_rounded,
        'weight' => Icons.fitness_center_rounded,
        'calendar' => Icons.calendar_today_outlined,
        'bucket' => Icons.water_drop_outlined,
        'shield' => Icons.shield_outlined,
        _ => Icons.info_outline_rounded,
      };
}
