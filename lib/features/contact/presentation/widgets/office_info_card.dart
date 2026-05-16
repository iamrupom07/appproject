import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/contact_model.dart';
import 'contact_section_title.dart';

/// Card displaying company address, email, website and an office photo.
/// Includes a "View on Map" button that opens Google Maps.
class OfficeInfoCard extends StatelessWidget {
  const OfficeInfoCard({super.key, required this.info});

  final OfficeInfo info;

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${info.mapsQuery}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _sendEmail() async {
    final uri = Uri.parse('mailto:${info.email}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse('https://${info.website}');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
          // ── Header row ─────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContactSectionTitle(title: 'Office Information'),
              _MapButton(onTap: _openMap),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),

          // ── Body: contact details + photo ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.companyName,
                            style: AppTextStyles.headingSmall,
                          ),
                          const SizedBox(height: 2),
                          ...info.addressLines.map(
                            (line) => Text(
                              line,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceMd),
                    _InfoRow(
                      icon: Icons.mail_outline_rounded,
                      onTap: _sendEmail,
                      child: Text(info.email, style: AppTextStyles.bodySmall),
                    ),
                    const SizedBox(height: AppSizes.spaceMd),
                    _InfoRow(
                      icon: Icons.language_rounded,
                      onTap: _openWebsite,
                      child: Text(info.website, style: AppTextStyles.bodySmall),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),

              // Office photo
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: CachedNetworkImage(
                  imageUrl: info.imageUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 130,
                    height: 130,
                    color: AppColors.shimmerBase,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 130,
                    height: 130,
                    color: AppColors.shimmerBase,
                    child: const Icon(Icons.business,
                        color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Internal helpers ──────────────────────────────────────────────────────────

class _MapButton extends StatelessWidget {
  const _MapButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.gold),
            const SizedBox(width: 4),
            Text(
              'View on Map',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.child,
    this.onTap,
  });

  final IconData icon;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: AppSizes.spaceSm),
          Expanded(child: child),
        ],
      ),
    );
  }
}
