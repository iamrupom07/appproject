import 'package:flutter/material.dart';

import 'package:abroz_parts_plus/core/constants/app_colors.dart';
import 'package:abroz_parts_plus/core/constants/app_sizes.dart';
import 'package:abroz_parts_plus/core/constants/app_text_styles.dart';
import 'package:abroz_parts_plus/core/widgets/messenger_logo.dart';

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
      icon: const MessengerLogo(size: 24),
      label: 'Messenger',
      backgroundColor: AppColors.pageBackground,
      foregroundColor: AppColors.textPrimary,
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
      icon: const Icon(
        Icons.phone_rounded,
        size: 20,
        color: AppColors.textPrimary,
      ),
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
  });

  final VoidCallback onTap;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

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
                  icon,
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
