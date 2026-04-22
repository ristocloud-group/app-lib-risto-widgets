import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart'; // Ensure this points to your extensions

/// A unified widget that applies a smooth shimmering gradient effect.
/// It acts as a wrapper for custom children, or can generate pre-built
/// skeleton shapes (blocks, circles, text lines) via its static methods.
class RistoShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const RistoShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  // ===========================================================================
  // 1. SHIMMER WRAPPER FACTORIES (Custom Colors)
  // ===========================================================================

  /// A pre-configured shimmer for light-themed interfaces.
  factory RistoShimmer.light({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return RistoShimmer(
      key: key,
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      duration: duration,
      child: child,
    );
  }

  /// A pre-configured shimmer for dark-themed interfaces.
  factory RistoShimmer.dark({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return RistoShimmer(
      key: key,
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      duration: duration,
      child: child,
    );
  }

  /// Automatically generates the highlight sweeping color based on a single base color.
  factory RistoShimmer.fromColor({
    Key? key,
    required Widget child,
    required Color color,
    double lightnessFactor = 0.4,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return RistoShimmer(
      key: key,
      baseColor: color,
      highlightColor: color.lighter(lightnessFactor),
      duration: duration,
      child: child,
    );
  }

  // ===========================================================================
  // 2. PRE-BUILT SKELETON SHAPE FACTORIES
  // ===========================================================================

  /// Internal helper to generate the physical solid shapes
  static Widget _buildShape({
    double? width,
    double? height,
    double borderRadius = 8.0,
    BoxShape shape = BoxShape.rectangle,
    EdgeInsetsGeometry? margin,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Generates a standard rectangular skeleton block, automatically shimmering.
  static Widget block({
    double? width,
    double? height,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? margin,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    final shape = _buildShape(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
      color: staticColor,
    );
    if (!animated) return shape;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: shape,
    );
  }

  /// Generates a large card skeleton block.
  static Widget card({
    double? width,
    double? height,
    double borderRadius = 16.0,
    EdgeInsetsGeometry? margin,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    final shape = _buildShape(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
      color: staticColor,
    );
    if (!animated) return shape;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: shape,
    );
  }

  /// Generates a skeleton block styled like a standard button.
  static Widget button({
    double? width,
    double height = 48.0,
    double borderRadius = 12.0,
    EdgeInsetsGeometry? margin,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    final shape = _buildShape(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
      color: staticColor,
    );
    if (!animated) return shape;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: shape,
    );
  }

  /// Generates a circular skeleton block (e.g., for avatars).
  static Widget circle({
    required double size,
    EdgeInsetsGeometry? margin,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    final shape = _buildShape(
      width: size,
      height: size,
      shape: BoxShape.circle,
      margin: margin,
      color: staticColor,
    );
    if (!animated) return shape;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: shape,
    );
  }

  /// Generates a layout of multiple skeleton text lines.
  /// Wraps all lines in a SINGLE shimmer so the sweep effect travels across them seamlessly.
  static Widget textLines({
    int lines = 2,
    double lineHeight = 14.0,
    double spacing = 8.0,
    bool lastLineShort = true,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return _buildShape(
          width: (isLast && lastLineShort) ? 120.0 : double.infinity,
          height: lineHeight,
          borderRadius: lineHeight / 2,
          color: staticColor,
          margin: EdgeInsets.only(bottom: isLast ? 0 : spacing),
        );
      }),
    );

    if (!animated) return content;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: content,
    );
  }

  // ===========================================================================
  // 3. COMPLEX PRE-BUILT LAYOUTS
  // ===========================================================================

  /// Replicates a complex layout with split top action buttons and a horizontal scrolling list of cards.
  static Widget layoutButtonsAndCards({
    double buttonHeight = 54.0,
    double cardWidth = 140.0,
    double cardHeight = 160.0,
    double horizontalPadding = 16.0,
    double spacing = 12.0,
    int cardCount = 4,
    Color? staticColor,
    bool animated = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    Widget content = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildShape(
                      height: buttonHeight,
                      borderRadius: 12,
                      color: staticColor,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildShape(
                      height: buttonHeight,
                      borderRadius: 12,
                      color: staticColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              _buildShape(
                width: double.infinity,
                height: buttonHeight,
                borderRadius: 12,
                color: staticColor,
              ),
            ],
          ),
        ),
        SizedBox(height: spacing * 2),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: cardCount,
            separatorBuilder: (_, _) => SizedBox(width: spacing),
            itemBuilder: (_, _) => _buildShape(
              width: cardWidth,
              height: cardHeight,
              borderRadius: 16,
              color: staticColor,
            ),
          ),
        ),
      ],
    );

    if (!animated) return content;
    return RistoShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: content,
    );
  }

  @override
  State<RistoShimmer> createState() => _RistoShimmerState();
}

class _RistoShimmerState extends State<RistoShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlight = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final offset = -1.2 + (_controller.value * 2.4);
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(slidePercent: offset),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
