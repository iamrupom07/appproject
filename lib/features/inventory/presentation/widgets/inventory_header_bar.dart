import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Top header for the Inventory screen.
/// Shows "Inventory" title with orange dot, machine count subtitle,
/// and icon buttons for search and filter.
class InventoryHeaderBar extends StatelessWidget {
  const InventoryHeaderBar({
    super.key,
    required this.machineCount,
    this.onSearchTap,
    this.onFilterTap,
  });

  final int machineCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title block ────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventory', style: AppTextStyles.displayMedium),
                  const SizedBox(width: 3),
                  // Orange notification dot
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$machineCount premium machines available',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        // ── Action buttons ─────────────────────────────────────────────
        _IconBtn(icon: Icons.search_rounded, onTap: onSearchTap),
        const SizedBox(width: AppSizes.spaceSm),
        _FilterIconBtn(onTap: onFilterTap),
      ],
    );
  }
}

// ─── Plain circular icon button ───────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─── Filter icon button with gold badge dot ───────────────────────────────────

class _FilterIconBtn extends StatelessWidget {
  const _FilterIconBtn({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Stack(
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.tune_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
