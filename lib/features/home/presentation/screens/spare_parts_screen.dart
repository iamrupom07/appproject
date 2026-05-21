import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../features/contact/domain/contact_model.dart';

/// Full-screen "Spare Parts & Mechanical Services" page.
class SparePartsScreen extends StatelessWidget {
  const SparePartsScreen({super.key});

  Future<void> _openMessenger() async {
    final uri = Uri.parse(ContactData.messengerUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callNow() async {
    final uri = Uri.parse(ContactData.phoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

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
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _HeroSection()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceMd,
                    AppSizes.spaceLg,
                    AppSizes.spaceMd,
                    AppSizes.spaceMd,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(
                        'Spare Parts &\nMechanical Services',
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
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
                      Text(
                        'We supply genuine and refurbished Komatsu spare parts and provide comprehensive mechanical services for all your heavy machinery needs.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Category grid
                      const _CategoryTitle(title: 'Parts Categories'),
                      const SizedBox(height: AppSizes.spaceMd),
                      _PartsGrid(),

                      const SizedBox(height: AppSizes.spaceLg),
                      const _CategoryTitle(title: 'Mechanical Services'),
                      const SizedBox(height: AppSizes.spaceMd),

                      _ServiceCard(
                        icon: Icons.build_rounded,
                        title: 'Engine Overhaul',
                        description:
                            'Complete engine rebuilding with genuine Komatsu-grade components. Pressure-tested before delivery.',
                      ),
                      const SizedBox(height: AppSizes.spaceSm),
                      _ServiceCard(
                        icon: Icons.water_drop_rounded,
                        title: 'Hydraulic Repair',
                        description:
                            'Hydraulic pump and cylinder reconditioning with full leak testing and performance verification.',
                      ),
                      const SizedBox(height: AppSizes.spaceSm),
                      _ServiceCard(
                        icon: Icons.settings_rounded,
                        title: 'Undercarriage Service',
                        description:
                            'Track roller, idler, and sprocket replacement. Full undercarriage inspection and alignment.',
                      ),
                      const SizedBox(height: AppSizes.spaceSm),
                      _ServiceCard(
                        icon: Icons.electric_bolt_rounded,
                        title: 'Electrical Diagnostics',
                        description:
                            'Modern diagnostic tools for quick fault identification and electrical system repair.',
                      ),

                      const SizedBox(height: AppSizes.spaceLg),

                      // Availability banner
                      _AvailabilityBanner(),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),

            // Back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: AppSizes.spaceMd,
              child: _BackButton(),
            ),

            // Sticky CTA
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
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1518459031867-a89b944bffe4?w=800&q=80',
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
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
                    'GENUINE & REFURBISHED',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Spare Parts &\nServices',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
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

// ─── Category Title ───────────────────────────────────────────────────────────

class _CategoryTitle extends StatelessWidget {
  const _CategoryTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.headingMedium),
      ],
    );
  }
}

// ─── Parts Grid ───────────────────────────────────────────────────────────────

class _PartsGrid extends StatelessWidget {
  final List<_PartCategory> _categories = const [
    _PartCategory(icon: Icons.settings_rounded, label: 'Engine Parts'),
    _PartCategory(icon: Icons.water_drop_rounded, label: 'Hydraulics'),
    _PartCategory(icon: Icons.track_changes_rounded, label: 'Undercarriage'),
    _PartCategory(icon: Icons.electric_bolt_rounded, label: 'Electrical'),
    _PartCategory(icon: Icons.air_rounded, label: 'Filters'),
    _PartCategory(
        icon: Icons.precision_manufacturing_rounded, label: 'Attachments'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSizes.spaceSm,
      mainAxisSpacing: AppSizes.spaceSm,
      childAspectRatio: 1.05,
      children: _categories.map((c) => _PartCategoryTile(category: c)).toList(),
    );
  }
}

class _PartCategory {
  const _PartCategory({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _PartCategoryTile extends StatelessWidget {
  const _PartCategoryTile({required this.category});
  final _PartCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(category.icon, color: AppColors.gold, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            category.label,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// ─── Service Card ─────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
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
            blurRadius: 8,
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
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: AppColors.gold, size: 22),
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

// ─── Availability Banner ──────────────────────────────────────────────────────

class _AvailabilityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parts In Stock',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wide inventory of genuine and refurbished Komatsu parts ready for immediate dispatch.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white60,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spaceMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
            child: Text(
              'In Stock',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
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
                    const Icon(Icons.messenger_rounded,
                        color: Colors.white, size: 20),
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
