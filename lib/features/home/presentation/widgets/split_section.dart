import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Two-column split section that replaces the featured carousel on the home
/// screen. Left tile → Spare Parts; Right tile → Mechanical Services.
class HomeSplitSection extends StatelessWidget {
  const HomeSplitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Left: Spare Parts ───────────────────────────────────────
            Expanded(
              child: _SplitTile(
                label: 'SPARE PARTS',
                icon: Icons.construction_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8B84B), Color(0xFFD4A017)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () => context.push('/spare-parts'),
              ),
            ),

            // ── Vertical divider ────────────────────────────────────────
            Container(
              width: 1,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: AppColors.divider,
            ),

            // ── Right: Mechanical Services ──────────────────────────────
            Expanded(
              child: _SplitTile(
                label: 'MECHANICAL\nSERVICES',
                icon: Icons.build_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF2D2D52)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                iconColor: AppColors.gold,
                textColor: Colors.white,
                onTap: () => context.push('/mechanical-services'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplitTile extends StatelessWidget {
  const _SplitTile({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXs),
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
