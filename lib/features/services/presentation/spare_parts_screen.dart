import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/messenger_launcher.dart';
import '../../contact/domain/contact_model.dart';
import 'widgets/service_media_section.dart';

class SparePartsScreen extends StatelessWidget {
  const SparePartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── App bar ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceSm, AppSizes.spaceSm, AppSizes.spaceMd, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Text('Spare Parts', style: AppTextStyles.displayMedium),
                  ],
                ),
              ),

              // ── Scrollable body ──────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceMd, AppSizes.spaceMd,
                      AppSizes.spaceMd, AppSizes.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Media section
                      const ServiceMediaSection(
                        imageUrls: [
                          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
                          'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=800&q=80',
                          'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=800&q=80',
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceLg),

                      // Description
                      Text('About Our Spare Parts',
                          style: AppTextStyles.headingMedium),
                      const SizedBox(height: AppSizes.spaceSm),
                      Text(
                        'AB & Abroz Machinery Inc. carries a comprehensive inventory of '
                        'genuine and aftermarket spare parts for Komatsu, Caterpillar, '
                        'Hitachi, Volvo, and other leading heavy-equipment brands. '
                        'From filters, seals, and bearings to engine components and '
                        'hydraulic parts — we help keep your machines running at peak '
                        'performance with minimal downtime.\n\n'
                        'All parts are sourced from trusted suppliers and verified for '
                        'compatibility. Contact us today to check availability and pricing.',
                        style: AppTextStyles.bodyMedium
                            .copyWith(height: 1.6, color: AppColors.textSecondary),
                      ),
                      // Bottom padding to clear the action bar
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Bottom action bar ────────────────────────────────────────────────
        bottomNavigationBar: _ServiceActionBar(
          onMessengerTap: openMessenger,
          onCallTap: callAbroz,
        ),
      ),
    );
  }
}

// ─── Bottom Action Bar ─────────────────────────────────────────────────────────

class _ServiceActionBar extends StatelessWidget {
  const _ServiceActionBar({
    required this.onMessengerTap,
    required this.onCallTap,
  });

  final VoidCallback onMessengerTap;
  final VoidCallback onCallTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Material(
      color: AppColors.cardBackground,
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spaceMd,
          AppSizes.spaceSm,
          AppSizes.spaceMd,
          bottomInset > 0 ? bottomInset : AppSizes.spaceMd,
        ),
        child: Row(
          children: [
            // Messenger button
            Expanded(
              child: _ActionBarButton(
                onTap: onMessengerTap,
                icon: _MessengerIcon(),
                label: 'Messenger',
                backgroundColor: const Color(0xFF0084FF),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            // Call Now button
            Expanded(
              child: _ActionBarButton(
                onTap: onCallTap,
                icon: const Icon(Icons.phone_rounded,
                    size: 20, color: AppColors.textPrimary),
                label: 'Call Now',
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBarButton extends StatelessWidget {
  const _ActionBarButton({
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
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.buttonHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: foregroundColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessengerIcon extends StatelessWidget {
  const _MessengerIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _MessengerPainter(color: Colors.white),
    );
  }
}

class _MessengerPainter extends CustomPainter {
  final Color color;
  const _MessengerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.48;

    // Outer circle
    final outerPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));

    // Lightning bolt tail
    final tailPath = Path()
      ..moveTo(cx - r * 0.1, cy + r * 0.35)
      ..lineTo(cx - r * 0.1, cy + r * 0.78)
      ..lineTo(cx + r * 0.32, cy + r * 0.45);

    canvas.drawPath(outerPath, paint);

    // Inner cut-out (background circle)
    final cutPaint = Paint()
      ..color = const Color(0xFF0084FF)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCircle(center: Offset(cx, cy - r * 0.05), radius: r * 0.68),
      cutPaint,
    );

    // Bolt
    canvas.drawPath(tailPath, paint);

    // Lightning bolt body (upward pointing)
    final boltPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final boltPath = Path()
      ..moveTo(cx - r * 0.35, cy + r * 0.1)
      ..lineTo(cx - r * 0.02, cy - r * 0.38)
      ..lineTo(cx - r * 0.02, cy - r * 0.02)
      ..lineTo(cx + r * 0.35, cy - r * 0.45)
      ..lineTo(cx + r * 0.02, cy + r * 0.02)
      ..lineTo(cx + r * 0.02, cy + r * 0.38)
      ..close();

    final boltFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(boltPath, boltFill);
  }

  @override
  bool shouldRepaint(_MessengerPainter oldDelegate) => oldDelegate.color != color;
}
