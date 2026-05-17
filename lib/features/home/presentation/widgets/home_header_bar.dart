import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Top greeting bar: "Hello, User 👋 / date" + search icon + avatar.
/// Stateless — receives user name and callbacks.
class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({
    super.key,
    required this.userName,
    required this.dateLabel,
    required this.avatarUrl,
    this.onSearchTap,
    this.onAvatarTap,
  });

  final String userName;
  final String dateLabel;
  final String? avatarUrl;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
      child: Row(
        children: [
          // ── Greeting ────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.headingLarge.copyWith(fontSize: 20),
                    children: [
                      const TextSpan(text: 'Hello, '),
                      TextSpan(
                        text: userName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const TextSpan(text: ' 👋'),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(dateLabel, style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          // ── Search Icon Button ────────────────────────────────────────────
          _CircleIconButton(
            onTap: onSearchTap,
            child: const Icon(
              Icons.search_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),

          const SizedBox(width: AppSizes.spaceSm),

          // ── Avatar ───────────────────────────────────────────────────────
          GestureDetector(
            onTap: onAvatarTap,
            child: _UserAvatar(imageUrl: avatarUrl),
          ),
        ],
      ),
    );
  }
}

// ─── Circle Icon Button ────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── User Avatar ──────────────────────────────────────────────────────────────

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 2),
        color: AppColors.divider,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _FallbackAvatar(),
              )
            : const _FallbackAvatar(),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gold.withValues(alpha: 0.2),
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.gold,
        size: 22,
      ),
    );
  }
}
