import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Dark "Stay updated with latest machines & offers" banner at the bottom of
/// the Contact screen.  Tapping it opens the company's primary social channel.
class NewsletterBanner extends StatelessWidget {
  const NewsletterBanner({
    super.key,
    this.primaryUrl = 'https://instagram.com/abrozmachinery',
  });

  final String primaryUrl;

  Future<void> _launch() async {
    final uri = Uri.parse(primaryUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launch,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // ── Gold accent stripe ───────────────────────────────────────────
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: AppColors.gold),
            ),

            // ── Content ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceLg,
                AppSizes.spaceMd,
                AppSizes.spaceMd,
                AppSizes.spaceMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay updated with\nlatest machines & offers',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.textOnDark,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Follow our social channels and\nnever miss an update.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textOnDark.withValues(alpha: 0.65),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceSm),

                  // Machinery emoji illustration
                  const Text('🚛', style: TextStyle(fontSize: 56)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
