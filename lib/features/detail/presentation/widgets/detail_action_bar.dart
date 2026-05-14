import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Sticky bottom bar with:
///  - Save (icon only)
///  - Message via Messenger (icon + label)
///  - Call Now primary CTA
class DetailActionBar extends StatelessWidget {
  const DetailActionBar({
    super.key,
    required this.onSave,
    required this.onMessage,
    required this.onCall,
    required this.isSaved,
  });

  final VoidCallback onSave;
  final VoidCallback onMessage;
  final VoidCallback onCall;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceMd,
        AppSizes.spaceSm,
        AppSizes.spaceMd,
        MediaQuery.of(context).padding.bottom + AppSizes.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Save ────────────────────────────────────────────────────────
          _SaveButton(isSaved: isSaved, onTap: onSave),

          const SizedBox(width: AppSizes.spaceMd),

          // ── Message ─────────────────────────────────────────────────────
          Expanded(
            child: _MessageButton(onTap: onMessage),
          ),

          const SizedBox(width: AppSizes.spaceSm),

          // ── Call Now ────────────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: _CallButton(onTap: onCall),
          ),
        ],
      ),
    );
  }
}

// ─── Save Button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, required this.onTap});

  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.elasticOut,
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              key: ValueKey(isSaved),
              size: 26,
              color: isSaved ? AppColors.gold : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Save',
            style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─── Message Button ───────────────────────────────────────────────────────────

class _MessageButton extends StatelessWidget {
  const _MessageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.pageBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Messenger-style blue circle icon
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF0084FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                ),
                Text(
                  'Chat on Messenger',
                  style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Call Now Button ──────────────────────────────────────────────────────────

class _CallButton extends StatelessWidget {
  const _CallButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Call Now',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                ),
                Text(
                  'Speak with our team',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textPrimary.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
