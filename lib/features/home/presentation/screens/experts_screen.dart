import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/messenger_launcher.dart';
import '../../../../../core/widgets/messenger_logo.dart';

/// Full-screen "Experts" page – navigated from the homepage split section.
class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  Future<void> _openMessenger() => openMessenger();

  Future<void> _callNow() => callAbroz();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Stack(
          children: [
            // ── Scrollable content ──────────────────────────────────────────
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Hero image with gradient overlay
                SliverToBoxAdapter(
                  child: _HeroSection(),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceMd,
                    AppSizes.spaceLg,
                    AppSizes.spaceMd,
                    AppSizes.spaceMd,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Title
                      Text(
                        'Our Experts',
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 48,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusPill),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceMd),

                      // Description
                      Text(
                        'Meet our team of certified Komatsu machinery specialists with decades of hands-on experience.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Feature cards
                      _FeatureCard(
                        icon: Icons.verified_rounded,
                        iconColor: AppColors.gold,
                        title: 'Certified Technicians',
                        description:
                            'Our team holds Komatsu-certified credentials and undergoes regular training to stay at the forefront of heavy machinery technology.',
                      ),
                      const SizedBox(height: AppSizes.spaceMd),
                      _FeatureCard(
                        icon: Icons.construction_rounded,
                        iconColor: const Color(0xFF5B8CFF),
                        title: 'Field Experience',
                        description:
                            'With over 20 years in the industry, our experts have serviced machinery across agriculture, construction, and mining sectors in the Philippines.',
                      ),
                      const SizedBox(height: AppSizes.spaceMd),
                      _FeatureCard(
                        icon: Icons.support_rounded,
                        iconColor: AppColors.inStock,
                        title: '24/7 Technical Support',
                        description:
                            'Get guidance any time. Our specialists are available via phone and Messenger to assist with parts selection, troubleshooting, and service recommendations.',
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Expert stats row
                      _StatsRow(),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Testimonial
                      _TestimonialCard(),

                      // Bottom padding for sticky CTA
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),

            // ── Back button ─────────────────────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: AppSizes.spaceMd,
              child: _BackButton(),
            ),

            // ── Sticky CTA buttons ──────────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _StickyCtaBar(
                onMessage: _openMessenger,
                onCall: _callNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1601574968106-b312ac309953?w=800&q=80',
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(color: AppColors.darkBackground);
            },
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.darkBackground,
              child: const Icon(Icons.image_not_supported_rounded,
                  color: Colors.white54, size: 48),
            ),
          ),
          // Dark gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          // Label
          Positioned(
            bottom: AppSizes.spaceLg,
            left: AppSizes.spaceMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Text(
                    'TEAM',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Expert\nSpecialists',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature Card ─────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppSizes.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(value: '20+', label: 'Years\nExperience')),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(child: _StatTile(value: '500+', label: 'Machines\nServiced')),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
            child: _StatTile(value: '100%', label: 'Customer\nSatisfaction')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.gold,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white70,
              fontSize: 10,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Testimonial Card ─────────────────────────────────────────────────────────

class _TestimonialCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded,
              color: AppColors.gold, size: 28),
          const SizedBox(height: 8),
          Text(
            'Their team immediately identified the issue with my Komatsu PC200 and had the right part in stock. Outstanding service!',
            style: AppTextStyles.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                child: const Icon(Icons.person_rounded,
                    color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jose M.',
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 13)),
                  Text('Construction Manager, Pampanga',
                      style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Back Button ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child:
            const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─── Sticky CTA Bar ───────────────────────────────────────────────────────────

class _StickyCtaBar extends StatelessWidget {
  const _StickyCtaBar({required this.onMessage, required this.onCall});

  final VoidCallback onMessage;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceMd,
        AppSizes.spaceMd,
        AppSizes.spaceMd,
        bottomInset > 0 ? bottomInset : AppSizes.spaceMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message Us
          Expanded(
            child: GestureDetector(
              onTap: onMessage,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF0084FF),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0084FF).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MessengerLogo(size: 22),
                    const SizedBox(width: 8),
                    Text('Message Us',
                        style: AppTextStyles.buttonLabel.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceSm),
          // Call Now
          Expanded(
            child: GestureDetector(
              onTap: onCall,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_rounded,
                        color: Colors.black, size: 20),
                    const SizedBox(width: 8),
                    Text('Call Now',
                        style: AppTextStyles.buttonLabel.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
