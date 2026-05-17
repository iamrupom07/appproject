import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../domain/contact_model.dart';
import 'widgets/business_hours_card.dart';
import 'widgets/contact_action_card.dart';
import 'widgets/find_machine_banner.dart';
import 'widgets/newsletter_banner.dart';
import 'widgets/office_info_card.dart';
import 'widgets/social_links_row.dart';

/// Contact screen — pixel-faithful to the provided mockup.
///
/// All sub-sections are independent widgets so they can be reused or tested
/// in isolation. Data comes from [ContactData] static seed; swap for a
/// Riverpod provider when a real API is available.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _openMessenger() async {
    final uri = Uri.parse(ContactData.messengerUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callUs() async {
    final uri = Uri.parse(ContactData.phoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    // Keep status bar icons dark on the light background.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App bar ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _ContactAppBar(),
              ),

              // ── Body sections ────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spaceMd,
                  AppSizes.spaceSm,
                  AppSizes.spaceMd,
                  AppSizes.spaceLg,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // 1. Action cards row
                    _ActionCardsRow(
                      onMessengerTap: _openMessenger,
                      onCallTap: _callUs,
                    ),
                    const SizedBox(height: AppSizes.spaceMd),

                    // 2. Office information
                    OfficeInfoCard(info: ContactData.office),
                    const SizedBox(height: AppSizes.spaceMd),

                    // 3. Business hours
                    BusinessHoursCard(hours: ContactData.businessHours),
                    const SizedBox(height: AppSizes.spaceMd),

                    // 4. Find machine CTA
                    FindMachineBanner(
                      onTap: () => context.go('/inventory'),
                    ),
                    const SizedBox(height: AppSizes.spaceLg),

                    // 5. Social links
                    SocialLinksRow(links: ContactData.socialLinks),
                    const SizedBox(height: AppSizes.spaceLg),

                    // 6. Newsletter / stay updated banner
                    NewsletterBanner(
                      primaryUrl: ContactData.socialLinks
                          .firstWhere(
                            (l) => l.platform == SocialPlatform.instagram,
                            orElse: () => ContactData.socialLinks.firstWhere(
                              (l) => l.platform == SocialPlatform.facebook,
                              orElse: () => const SocialLink(
                                platform: SocialPlatform.facebook,
                                handle: '',
                                url: ContactData.messengerUrl,
                              ),
                            ),
                          )
                          .url,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _ContactAppBar extends StatelessWidget {
  const _ContactAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceMd,
        AppSizes.spaceMd,
        AppSizes.spaceMd,
        AppSizes.spaceSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Contact Us', style: AppTextStyles.displayMedium),
                    const SizedBox(width: 4),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "We're here to help you.",
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          // Support button
          _SupportButton(),
          const SizedBox(width: AppSizes.spaceSm),

          // Logo badge
          _LogoBadge(),
        ],
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.headset_mic_rounded,
              size: 20, color: AppColors.textPrimary),
          const SizedBox(height: 1),
          Text(
            'Support',
            style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkBackground,
        border: Border.all(color: AppColors.gold, width: 2.5),
      ),
      child: Center(
        child: Text(
          'A',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.gold,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ─── Action Cards Row ─────────────────────────────────────────────────────────

class _ActionCardsRow extends StatelessWidget {
  const _ActionCardsRow({
    required this.onMessengerTap,
    required this.onCallTap,
  });

  final VoidCallback onMessengerTap;
  final VoidCallback onCallTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Messenger card (gold)
          ContactActionCard(
            backgroundColor: AppColors.gold,
            iconWidget: const Icon(
              Icons.messenger_rounded,
              color: Colors.white,
              size: 22,
            ),
            label: 'Chat on',
            title: 'Messenger',
            subtitle: 'Get quick response',
            isDark: false,
            onTap: onMessengerTap,
          ),
          const SizedBox(width: AppSizes.spaceSm),

          // Call card (dark)
          ContactActionCard(
            backgroundColor: AppColors.darkBackground,
            iconWidget: const Icon(
              Icons.phone_rounded,
              color: Colors.white,
              size: 22,
            ),
            label: '',
            title: 'Call Us Now',
            subtitle: 'Speak with our team',
            isDark: true,
            onTap: onCallTap,
          ),
        ],
      ),
    );
  }
}
