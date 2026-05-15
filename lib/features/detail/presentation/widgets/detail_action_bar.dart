import 'package:flutter/material.dart';

import 'package:ab_abroz_inventory/core/constants/app_colors.dart';
import 'package:ab_abroz_inventory/core/constants/app_sizes.dart';
import 'package:ab_abroz_inventory/core/constants/app_text_styles.dart';

/// Sticky bottom bar with save, message, and call actions.
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: AppColors.cardBackground,
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spaceMd,
            AppSizes.spaceSm,
            AppSizes.spaceMd,
            bottomInset > 0 ? AppSizes.spaceSm : AppSizes.spaceMd,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: _SaveButton(isSaved: isSaved, onTap: onSave),
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Expanded(
                flex: 4,
                child: _MessageButton(onTap: onMessage),
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Expanded(
                flex: 5,
                child: _CallButton(onTap: onCall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, required this.onTap});

  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSaved,
      label: isSaved ? 'Saved' : 'Save',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: SizedBox(
          height: AppSizes.buttonHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.elasticOut,
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  key: ValueKey(isSaved),
                  size: 25,
                  color: isSaved ? AppColors.gold : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Save',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageButton extends StatelessWidget {
  const _MessageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _BarButton(
      onTap: onTap,
      icon: Icons.chat_bubble_rounded,
      label: 'Message',
      backgroundColor: AppColors.pageBackground,
      foregroundColor: AppColors.textPrimary,
      iconBackgroundColor: const Color(0xFF0084FF),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _BarButton(
      onTap: onTap,
      icon: Icons.phone_rounded,
      label: 'Call Now',
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.textPrimary,
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.iconBackgroundColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: AppSizes.buttonHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceSm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionIcon(
                    icon: icon,
                    iconColor: foregroundColor,
                    backgroundColor: iconBackgroundColor,
                  ),
                  const SizedBox(width: AppSizes.spaceSm),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: foregroundColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (backgroundColor == null) {
      return Icon(icon, size: 20, color: iconColor);
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 15),
    );
  }
}
