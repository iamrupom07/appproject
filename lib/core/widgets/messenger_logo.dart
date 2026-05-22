import 'package:flutter/material.dart';

/// Facebook Messenger logo mark used across contact actions.
class MessengerLogo extends StatelessWidget {
  const MessengerLogo({
    super.key,
    this.size = 24,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const CustomPaint(
        painter: _MessengerLogoPainter(),
      ),
    );
  }
}

class _MessengerLogoPainter extends CustomPainter {
  const _MessengerLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = size.shortestSide;
    final origin = Offset(
      (size.width - shortestSide) / 2,
      (size.height - shortestSide) / 2,
    );
    final s = shortestSide;
    final bounds = origin & Size.square(s);

    final bubble = Path()
      ..addOval(Rect.fromLTWH(
        origin.dx + s * 0.04,
        origin.dy + s * 0.04,
        s * 0.92,
        s * 0.82,
      ))
      ..moveTo(origin.dx + s * 0.43, origin.dy + s * 0.78)
      ..lineTo(origin.dx + s * 0.34, origin.dy + s * 0.97)
      ..lineTo(origin.dx + s * 0.58, origin.dy + s * 0.82)
      ..close();

    final bubblePaint = Paint()
      ..isAntiAlias = true
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF00B2FF),
          Color(0xFF006AFF),
          Color(0xFFA033FF),
          Color(0xFFFF2D75),
        ],
        stops: [0.05, 0.45, 0.72, 1],
      ).createShader(bounds);

    canvas.drawPath(bubble, bubblePaint);

    final bolt = Path()
      ..moveTo(origin.dx + s * 0.23, origin.dy + s * 0.54)
      ..lineTo(origin.dx + s * 0.44, origin.dy + s * 0.32)
      ..lineTo(origin.dx + s * 0.53, origin.dy + s * 0.47)
      ..lineTo(origin.dx + s * 0.77, origin.dy + s * 0.32)
      ..lineTo(origin.dx + s * 0.56, origin.dy + s * 0.58)
      ..lineTo(origin.dx + s * 0.47, origin.dy + s * 0.43)
      ..close();

    canvas.drawPath(
      bolt,
      Paint()
        ..isAntiAlias = true
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
