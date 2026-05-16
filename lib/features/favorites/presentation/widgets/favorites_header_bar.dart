import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Top header for the Favorites screen.
/// Mirrors the [InventoryHeaderBar] visual pattern — bold title with gold dot,
/// subtitle showing saved count, and a clear-all action button.
class FavoritesHeaderBar extends StatelessWidget {
  const FavoritesHeaderBar({
    super.key,
    required this.savedCount,
    this.onClearAll,
  });

  final int savedCount;

  /// Called when the user taps "Clear All". Pass null to hide the button.
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title block ──────────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favourites', style: AppTextStyles.displayMedium),
                  const SizedBox(width: 4),
                  // Gold dot accent — same as ContactScreen / InventoryHeaderBar
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                savedCount == 0
                    ? 'No machines saved yet'
                    : '$savedCount machine${savedCount == 1 ? '' : 's'} saved',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        // ── Clear all button (visible only when list is non-empty) ───────────
        if (onClearAll != null && savedCount > 0)
          _ClearAllButton(onTap: onClearAll!),
      ],
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  const _ClearAllButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMd,
            vertical: AppSizes.spaceSm,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Clear All',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
