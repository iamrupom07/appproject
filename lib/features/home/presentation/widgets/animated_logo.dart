import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Reusable ABROZ brand logo with optional entrance animation.
///
/// Displays the gold "A" triangular mark, the wordmark "ABROZ",
/// and the sub-brand line "MACHINERY INC." with letter-spacing.
///
/// Set [animate] to false for static use (e.g., in an AppBar or About page).
///
/// Usage:
/// ```dart
/// AnimatedLogo(animate: true, delay: Duration(milliseconds: 400))
/// ```
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({
    super.key,
    this.animate = true,
    this.delay = Duration.zero,
    this.logoSize = 80.0,
    this.wordmarkFontSize = 40.0,
    this.subbrandFontSize = 12.0,
    this.color = AppColors.gold,
    this.textColor = Colors.white,
  });

  final bool animate;
  final Duration delay;
  final double logoSize;
  final double wordmarkFontSize;
  final double subbrandFontSize;
  final Color color;
  final Color textColor;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gold "A" mark
        _AbrozAMark(size: widget.logoSize, color: widget.color),
        SizedBox(height: AppSizes.spaceMd),
        // Wordmark
        Text(
          'ABROZ',
          style: GoogleFonts.outfit(
            fontSize: widget.wordmarkFontSize,
            fontWeight: FontWeight.w800,
            color: widget.textColor,
            letterSpacing: 4,
            height: 1,
          ),
        ),
        SizedBox(height: AppSizes.spaceXs + 2),
        // Sub-brand
        Text(
          'MACHINERY INC.',
          style: GoogleFonts.outfit(
            fontSize: widget.subbrandFontSize,
            fontWeight: FontWeight.w400,
            color: widget.textColor.withValues(alpha: 0.65),
            letterSpacing: 3.5,
          ),
        ),
      ],
    );

    if (!widget.animate) return content;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: content,
      ),
    );
  }
}

/// The triangular "A" logo mark rendered purely with CustomPaint —
/// no asset dependency, always crisp at any size.
class _AbrozAMark extends StatelessWidget {
  const _AbrozAMark({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.85, size),
      painter: _AMarkPainter(color: color),
    );
  }
}

class _AMarkPainter extends CustomPainter {
  _AMarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer triangle
    final outer = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    // Inner cutout (upside-down triangle — the negative space of the "A")
    final cutoutTop = h * 0.52;
    final cutoutW = w * 0.28;
    final inner = Path()
      ..moveTo(w / 2, cutoutTop - h * 0.14)
      ..lineTo(w / 2 + cutoutW, h - h * 0.08)
      ..lineTo(w / 2 - cutoutW, h - h * 0.08)
      ..close();

    // Horizontal crossbar cutout
    final barTop = h * 0.56;
    final barBottom = h * 0.645;
    final barLeft = w * 0.22;
    final barRight = w * 0.78;
    final bar = Path()
      ..addRect(Rect.fromLTRB(barLeft, barTop, barRight, barBottom));

    final combined = Path.combine(PathOperation.difference, outer, inner);
    final withBar = Path.combine(PathOperation.difference, combined, bar);

    canvas.drawPath(withBar, paint);
  }

  @override
  bool shouldRepaint(_AMarkPainter old) => old.color != color;
}
