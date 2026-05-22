import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/messenger_launcher.dart';
import '../../../core/widgets/messenger_logo.dart';
import 'widgets/service_media_section.dart';

class MechanicalServicesScreen extends StatelessWidget {
  const MechanicalServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── App bar ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceSm, AppSizes.spaceSm, AppSizes.spaceMd, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('Mechanical Services',
                          style: AppTextStyles.displayMedium),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ──────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppSizes.spaceMd,
                      AppSizes.spaceMd, AppSizes.spaceMd, AppSizes.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Media section
                      const ServiceMediaSection(
                        imageUrls: [
                          'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&q=80',
                          'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=800&q=80',
                          'https://images.unsplash.com/photo-1581092335397-9583eb92d232?w=800&q=80',
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Description
                      Text('Our Mechanical Services',
                          style: AppTextStyles.headingMedium),
                      const SizedBox(height: AppSizes.spaceSm),
                      Text(
                        'AB & Abroz Machinery Inc. provides expert mechanical services '
                        'for all types of heavy equipment. Our certified technicians '
                        'handle everything from routine preventive maintenance and '
                        'engine overhauls to hydraulic system repairs and structural '
                        'welding.\n\n'
                        'We service Komatsu, Caterpillar, Hitachi, Volvo, and other '
                        'leading brands. Our mobile service team can come to your job '
                        'site across Pampanga and Metro Manila, minimising costly '
                        'downtime and keeping your fleet operational.\n\n'
                        'Call or message us now to schedule a service visit or get a '
                        'free diagnostic assessment.',
                        style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.6, color: AppColors.textSecondary),
                      ),
                      // Bottom padding to clear the action bar
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Bottom action bar ────────────────────────────────────────────────
        bottomNavigationBar: _ServiceActionBar(
          onMessengerTap: openMessenger,
          onCallTap: callAbroz,
        ),
      ),
    );
  }
}

// ─── Reuse the same action bar layout ─────────────────────────────────────────

class _ServiceActionBar extends StatelessWidget {
  const _ServiceActionBar({
    required this.onMessengerTap,
    required this.onCallTap,
  });

  final VoidCallback onMessengerTap;
  final VoidCallback onCallTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Material(
      color: AppColors.cardBackground,
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spaceMd,
          AppSizes.spaceSm,
          AppSizes.spaceMd,
          bottomInset > 0 ? bottomInset : AppSizes.spaceMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: _ActionBarButton(
                onTap: onMessengerTap,
                icon: const MessengerLogo(size: 22),
                label: 'Messenger',
                backgroundColor: const Color(0xFF0084FF),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Expanded(
              child: _ActionBarButton(
                onTap: onCallTap,
                icon: const Icon(Icons.phone_rounded,
                    size: 20, color: AppColors.textPrimary),
                label: 'Call Now',
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBarButton extends StatelessWidget {
  const _ActionBarButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final VoidCallback onTap;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.buttonHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: foregroundColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Messenger Icon (Facebook gradient bolt) ──────────────────────────────────
