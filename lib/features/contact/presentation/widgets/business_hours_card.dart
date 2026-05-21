import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/contact_model.dart';
import 'contact_section_title.dart';

/// Displays business hours. Updated: Open Every Day 8:00 AM – 8:00 PM
class BusinessHoursCard extends StatelessWidget {
  const BusinessHoursCard({super.key, required this.hours});

  final List<BusinessHour> hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContactSectionTitle(title: 'Business Hours'),
          const SizedBox(height: 8),
          // "Open Every Day" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.inStock.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.inStock,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Open Every Day',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.inStock,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Row(
            children: hours
                .map(
                  (h) => Expanded(
                    child: _HourTile(hour: h),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({required this.hour});
  final BusinessHour hour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 16,
          color: AppColors.gold,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hour.label,
                style: AppTextStyles.headingSmall.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                hour.hours,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
