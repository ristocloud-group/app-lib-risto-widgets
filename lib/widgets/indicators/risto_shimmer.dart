import 'package:flutter/material.dart';

/// A wrapper that applies a beautifully smooth, continuous shimmering gradient
/// effect to its child. This does not use an external package; it uses an
/// animated ShaderMask with optimized translation math.
class RistoShimmer extends StatefulWidget {
  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// The base color of the shimmer (the darkest part).
  final Color? baseColor;

  /// The highlight color of the shimmer (the lightest part that sweeps across).
  final Color? highlightColor;

  /// The duration of one complete shimmer cycle.
  final Duration duration;

  const RistoShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<RistoShimmer> createState() => _RistoShimmerState();
}

class _RistoShimmerState extends State<RistoShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Using linear animation to ensure a constant velocity.
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
            // OPTIMIZED MATH:
            // We map the 0.0 -> 1.0 animation value to an offset of -1.2 to 1.2.
            // This ensures the gradient starts just off-screen to the left, sweeps
            // across, and ends just off-screen to the right.
            // This eliminates the long "stuck" pause between loops.
            final offset = -1.2 + (_controller.value * 2.4);

            return LinearGradient(
              colors: [base, highlight, base],
              // Tighter stops concentrate the light beam so the edges remain pure
              // baseColor. This prevents hard lines when the loop restarts.
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
    // Translates the gradient horizontally across the bounds.
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// ===========================================================================
// PRE-BUILT SKELETON BLOCKS & LAYOUTS
// ===========================================================================

/// A set of pre-configured skeleton shapes and full-page layouts designed to be used inside a [RistoShimmer].
class RistoSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const RistoSkeleton._({
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shape = BoxShape.rectangle,
    this.margin,
  });

  /// A generic rectangular block.
  factory RistoSkeleton.block({
    double? width,
    double? height,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoSkeleton._(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  /// A generic card block.
  factory RistoSkeleton.card({
    double? width,
    double? height,
    double borderRadius = 16.0,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoSkeleton._(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  /// A generic button block.
  factory RistoSkeleton.button({
    double? width,
    double height = 48.0,
    double borderRadius = 12.0,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoSkeleton._(
      width: width,
      height: height,
      borderRadius: borderRadius,
      margin: margin,
    );
  }

  /// A circular block, typically used for avatars or leading icons.
  factory RistoSkeleton.circle({
    required double size,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoSkeleton._(
      width: size,
      height: size,
      shape: BoxShape.circle,
      margin: margin,
    );
  }

  /// Generates a column of text-like lines.
  static Widget textLines({
    int lines = 2,
    double lineHeight = 14.0,
    double spacing = 8.0,
    bool lastLineShort = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;
        return RistoSkeleton._(
          width: (isLast && lastLineShort) ? 120.0 : double.infinity,
          height: lineHeight,
          borderRadius: lineHeight / 2,
          margin: EdgeInsets.only(bottom: isLast ? 0 : spacing),
        );
      }),
    );
  }

  // --- FULL LAYOUT FACTORIES ---

  /// Replicates a complex layout with split top action buttons and a horizontal scrolling list of cards.
  static Widget buttonsAndHorizontalCards({
    double buttonHeight = 54.0,
    double cardWidth = 140.0,
    double cardHeight = 160.0,
    double horizontalPadding = 16.0,
    double spacing = 12.0,
    int cardCount = 4,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: RistoSkeleton.button(height: buttonHeight)),
                  SizedBox(width: spacing),
                  Expanded(child: RistoSkeleton.button(height: buttonHeight)),
                ],
              ),
              SizedBox(height: spacing),
              RistoSkeleton.button(
                width: double.infinity,
                height: buttonHeight,
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
            itemBuilder: (_, _) =>
                RistoSkeleton.card(width: cardWidth, height: cardHeight),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The color here doesn't matter much as long as it's solid,
    // because RistoShimmer (ShaderMask) overrides it completely with srcATop.
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
