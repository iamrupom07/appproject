import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../utils/messenger_launcher.dart';

/// Reusable outlined "Contact" button used on machine cards.
/// Tapping it opens Facebook Messenger for abrozmachinery.
class ContactButton extends StatelessWidget {
  const ContactButton({
    super.key,
    required this.onTap,
    this.height = 34,
  });

  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Facebook Messenger icon
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF0084FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.messenger_rounded,
                  size: 9,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Contact',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
