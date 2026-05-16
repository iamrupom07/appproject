import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../../features/contact/domain/contact_model.dart';

/// Persistent gold FAB shown on every main screen.
/// Tapping it opens a compact bottom sheet with Call and Message options.
class FloatingContactButton extends StatelessWidget {
  const FloatingContactButton({super.key});

  void _openSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => const _ContactSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSheet(context),
      child: Container(
        width: AppSizes.fabSize,
        height: AppSizes.fabSize,
        decoration: BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.support_agent_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

// ─── Contact Sheet ────────────────────────────────────────────────────────────

class _ContactSheet extends StatelessWidget {
  const _ContactSheet();

  Future<void> _call(BuildContext context) async {
    Navigator.pop(context);
    final uri = Uri.parse(ContactData.phoneNumber);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _message(BuildContext context) async {
    Navigator.pop(context);
    final uri = Uri.parse(ContactData.messengerUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.spaceMd,
        0,
        AppSizes.spaceMd,
        AppSizes.spaceMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                ),
              ),

              // Header
              Text(
                'Contact AB & Abroz',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "We're here to help — reach out any time.",
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceLg),

              // Call button
              _SheetAction(
                icon: Icons.phone_rounded,
                iconBg: AppColors.inStock,
                label: 'Call Us Now',
                sublabel: '+63 917 510 0030',
                onTap: () => _call(context),
              ),
              const SizedBox(height: AppSizes.spaceSm),

              // Message button
              _SheetAction(
                icon: Icons.messenger_rounded,
                iconBg: const Color(0xFF0084FF),
                label: 'Message on Facebook',
                sublabel: 'Usually replies within an hour',
                onTap: () => _message(context),
              ),
              const SizedBox(height: AppSizes.spaceSm),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sheet Action Row ─────────────────────────────────────────────────────────

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageBackground,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMd,
            vertical: AppSizes.spaceMd,
          ),
          child: Row(
            children: [
              // Icon bubble
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppSizes.spaceMd),

              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 2),
                    Text(sublabel, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
