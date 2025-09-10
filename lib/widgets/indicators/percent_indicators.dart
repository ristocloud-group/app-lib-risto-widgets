import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// ------------------------------
/// LinearPercentIndicator
/// ------------------------------
class LinearPercentIndicator extends StatelessWidget {
  final double percent; // 0..1
  final double lineHeight;
  final Radius? barRadius;
  final bool animation;
  final int animationDuration; // ms
  final Color? backgroundColor;
  final Color? progressColor;
  final EdgeInsetsGeometry padding;

  const LinearPercentIndicator({
    super.key,
    required this.percent,
    this.lineHeight = 8.0,
    this.barRadius,
    this.animation = false,
    this.animationDuration = 500,
    this.backgroundColor,
    this.progressColor,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    final radius = barRadius ?? const Radius.circular(10);

    Widget buildBar(double value) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final total = constraints.maxWidth;
          final filled = total * value;
          return ClipRRect(
            borderRadius: BorderRadius.all(radius),
            child: SizedBox(
              height: lineHeight,
              child: Stack(
                children: [
                  Container(color: (backgroundColor ?? Colors.white)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      key: const ValueKey('linear_percent_filled'),
                      width: filled,
                      child: Container(
                        color: progressColor ??
                            Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: padding,
      child: animation
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: p.toDouble()),
              duration: Duration(milliseconds: animationDuration),
              curve: Curves.easeInOut,
              builder: (context, value, _) => buildBar(value),
            )
          : buildBar(p.toDouble()),
    );
  }
}

/// ------------------------------
/// CircularPercentIndicator
/// ------------------------------
class CircularPercentIndicator extends StatelessWidget {
  final double percent; // 0..1
  final double radius; // outer radius in logical px
  final double lineWidth;
  final bool animation;
  final int animationDuration; // ms
  final Widget? center;
  final Color? backgroundColor;
  final Color? progressColor;

  /// Kept for API compatibility; not used here (no gradient rotation).
  final bool rotateLinearGradient;

  const CircularPercentIndicator({
    super.key,
    required this.percent,
    required this.radius,
    this.lineWidth = 10.0,
    this.animation = false,
    this.animationDuration = 600,
    this.center,
    this.backgroundColor,
    this.progressColor,
    this.rotateLinearGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0).toDouble();
    final size = radius * 2;

    Widget ring(double value) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          key: const ValueKey('circular_percent_painter'),
          painter: _RingPainter(
            value: value,
            lineWidth: lineWidth,
            bgColor: backgroundColor ??
                Theme.of(context).dividerColor.withCustomOpacity(.4),
            fgColor: progressColor ?? Theme.of(context).colorScheme.primary,
          ),
          child: center == null ? null : Center(child: center),
        ),
      );
    }

    return animation
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: p),
            duration: Duration(milliseconds: animationDuration),
            curve: Curves.easeInOut,
            builder: (_, value, __) => ring(value),
          )
        : ring(p);
  }
}

class _RingPainter extends CustomPainter {
  final double value; // 0..1
  final double lineWidth;
  final Color bgColor;
  final Color fgColor;

  _RingPainter({
    required this.value,
    required this.lineWidth,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - lineWidth) / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = bgColor
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = fgColor
      ..strokeCap = StrokeCap.round;

    // Background circle
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc (starts at top, -90°)
    final startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * value;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.lineWidth != lineWidth ||
      old.bgColor != bgColor ||
      old.fgColor != fgColor;
}
