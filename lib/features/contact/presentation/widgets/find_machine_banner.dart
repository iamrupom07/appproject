import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Gold-tinted CTA banner — "Need help finding the right machine?"
/// [onTap] is forwarded to the Inventory screen (or a support flow).
class FindMachineBanner extends StatelessWidget {
  const FindMachineBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMd,
          vertical: AppSizes.spaceMd,
        ),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            // Text column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need help finding the right machine?',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our experts are ready to assist you.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),

            // Excavator illustration (emoji fallback — swap for asset if available)
            const Text('🚜', style: TextStyle(fontSize: 44)),
          ],
        ),
      ),
    );
  }
}
