import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Generic action card used for both the "Chat on Messenger" (gold) and
/// "Call Us Now" (dark) tiles on the Contact screen.
///
/// ```dart
/// ContactActionCard(
///   backgroundColor: AppColors.gold,
///   iconWidget: Icon(Icons.chat, color: Colors.white),
///   label: 'Chat on',
///   title: 'Messenger',
///   subtitle: 'Get quick response',
///   isDark: false,
///   onTap: () {},
/// )
/// ```
class ContactActionCard extends StatelessWidget {
  const ContactActionCard({
    super.key,
    required this.backgroundColor,
    required this.iconWidget,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  final Color backgroundColor;
  final Widget iconWidget;
  final String label;
  final String title;
  final String subtitle;

  /// When [isDark] is true, text and arrow use light colours.
  final bool isDark;
  final VoidCallback onTap;

  Color get _textColor => isDark ? AppColors.textOnDark : AppColors.textPrimary;
  Color get _subtitleColor => isDark
      ? AppColors.textOnDark.withValues(alpha: 0.7)
      : AppColors.textPrimary.withValues(alpha: 0.7);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceMd),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon circle ───────────────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.35),
                  shape: BoxShape.circle,
                ),
                child: Center(child: iconWidget),
              ),
              const SizedBox(height: AppSizes.spaceSm),

              // ── Label (small) ─────────────────────────────────────────────
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: _subtitleColor),
              ),

              // ── Title (bold) ──────────────────────────────────────────────
              Text(
                title,
                style: AppTextStyles.headingMedium.copyWith(
                  color: _textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXs),

              // ── Subtitle + arrow row ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subtitle,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: _subtitleColor),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withValues(alpha: isDark ? 0.15 : 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
