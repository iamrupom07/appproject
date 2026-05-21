import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/contact_model.dart';
import 'contact_section_title.dart';

/// Horizontally scrollable row of social platform icons with handles.
class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({super.key, required this.links});

  final List<SocialLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ContactSectionTitle(title: 'Follow Us'),
        const SizedBox(height: AppSizes.spaceMd),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: links
                .map((link) => Padding(
                      padding: const EdgeInsets.only(right: AppSizes.spaceMd),
                      child: _SocialIcon(link: link),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.link});
  final SocialLink link;

  Future<void> _launch() async {
    final uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Platform brand colours
  static const Map<SocialPlatform, Color> _bgColors = {
    SocialPlatform.facebook: Color(0xFF1877F2),
    SocialPlatform.messenger: Color(0xFF0084FF),
    SocialPlatform.instagram: Color(0xFFE1306C),
    SocialPlatform.linkedin: Color(0xFF0A66C2),
    SocialPlatform.youtube: Color(0xFFFF0000),
    SocialPlatform.tiktok: Color(0xFF010101),
    SocialPlatform.whatsapp: Color(0xFF25D366),
  };

  static const Map<SocialPlatform, IconData> _icons = {
    SocialPlatform.facebook: Icons.facebook_rounded,
    SocialPlatform.messenger: Icons.messenger_rounded,
    SocialPlatform.instagram: Icons.camera_alt_rounded,
    SocialPlatform.linkedin: Icons.work_rounded,
    SocialPlatform.youtube: Icons.play_circle_filled_rounded,
    SocialPlatform.tiktok: Icons.music_note_rounded,
    SocialPlatform.whatsapp: Icons.chat_rounded,
  };

  static const Map<SocialPlatform, String> _labels = {
    SocialPlatform.facebook: 'Facebook',
    SocialPlatform.messenger: 'Messenger',
    SocialPlatform.instagram: 'Instagram',
    SocialPlatform.linkedin: 'LinkedIn',
    SocialPlatform.youtube: 'YouTube',
    SocialPlatform.tiktok: 'TikTok',
    SocialPlatform.whatsapp: 'WhatsApp',
  };

  @override
  Widget build(BuildContext context) {
    final bg = _bgColors[link.platform] ?? AppColors.gold;
    final icon = _icons[link.platform] ?? Icons.link;
    final label = _labels[link.platform] ?? '';

    return GestureDetector(
      onTap: _launch,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: bg.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              link.handle,
              style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
