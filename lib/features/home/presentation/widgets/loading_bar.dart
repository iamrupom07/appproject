import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// A reusable animated horizontal progress bar.
///
/// Animates from 0 to 1 over [duration]. The bar fills with [color]
/// on top of a translucent [backgroundColor] track.
///
/// Usage anywhere in the app:
/// ```dart
/// LoadingBar(duration: Duration(seconds: 3), onComplete: () { ... })
/// ```
class LoadingBar extends StatefulWidget {
  const LoadingBar({
    super.key,
    this.duration = const Duration(milliseconds: 2800),
    this.color = AppColors.gold,
    this.backgroundColor,
    this.height = 3.0,
    this.borderRadius = AppSizes.radiusPill,
    this.onComplete,
  });

  final Duration duration;
  final Color color;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final VoidCallback? onComplete;

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward().whenComplete(() {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackColor = widget.backgroundColor ?? Colors.white.withValues(alpha: 0.15);

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Track
                Container(
                  height: widget.height,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
                // Fill
                Container(
                  height: widget.height,
                  width: constraints.maxWidth * _progress.value,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
