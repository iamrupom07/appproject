import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/contact_model.dart';
import 'contact_section_title.dart';

/// Displays Mon–Fri / Saturday / Sunday business hours in a horizontal row.
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
          color: hour.isOpen ? AppColors.gold : AppColors.textSecondary,
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
                  color: hour.isOpen
                      ? AppColors.textSecondary
                      : AppColors.outOfStock,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
