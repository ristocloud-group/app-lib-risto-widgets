import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

// ===========================================================================
// RISTO DECORATOR (The Core Styling Engine)
// ===========================================================================

/// A universal decorator widget that applies standard Risto styling
/// (backgrounds, gradients, borders, soft shadows) to any child widget.
class RistoDecorator extends StatelessWidget {
  final Widget child;

  /// Outer margin around the decorated box.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the decorated box.
  final EdgeInsetsGeometry? padding;

  /// Solid background color. Ignored if [backgroundGradient] is provided.
  /// Defaults to the theme's card color.
  final Color? backgroundColor;

  /// Gradient background.
  final Gradient? backgroundGradient;

  /// Color of the border.
  final Color? borderColor;

  /// Width of the border. Defaults to 1.0.
  final double borderWidth;

  /// Radius of the corners. Defaults to BorderRadius.circular(12.0).
  /// Ignored if shape is BoxShape.circle.
  final BorderRadiusGeometry? borderRadius;

  /// Elevation (shadow depth). Automatically generates a soft, spread shadow
  /// consistent with the Risto design language.
  final double elevation;

  /// Color of the shadow. Defaults to the theme's shadow color.
  final Color? shadowColor;

  /// The shape of the decorator (rectangle or circle).
  final BoxShape shape;

  /// Controls how the child is clipped.
  final Clip clipBehavior;

  const RistoDecorator({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.elevation = 0.0,
    this.shadowColor,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveShadowColor = shadowColor ?? theme.colorScheme.shadow;

    // Default to 12.0 radius if rectangle and no radius is provided
    final effectiveRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ?? BorderRadius.circular(12.0));

    final bool isShadowVisible = elevation > 0 && effectiveShadowColor.a > 0;

    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundGradient == null
            ? (backgroundColor ?? theme.cardColor)
            : null,
        gradient: backgroundGradient,
        shape: shape,
        borderRadius: effectiveRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: isShadowVisible
            ? [
                BoxShadow(
                  color: effectiveShadowColor.withCustomOpacity(
                    effectiveShadowColor.a * 0.15,
                  ),
                  blurRadius: elevation * 2.5,
                  spreadRadius: 0,
                  offset: Offset(0, elevation * 0.8),
                ),
              ]
            : null,
      ),
      // We wrap the child in a transparent Material so InkWells inside work perfectly
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}

// ===========================================================================
// ROUNDED CONTAINER (Legacy / Sizing Utility)
// ===========================================================================

/// A container with rounded corners, optional border, and elevation with custom shadow color.
/// Supports both solid background colors and gradient backgrounds.
///
/// This widget acts as a backwards-compatible wrapper around [RistoDecorator]
/// that easily injects highly specific sizing constraints.
class RoundedContainer extends StatelessWidget {
  /// Outer margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding within the container.
  final EdgeInsetsGeometry? padding;

  /// The child widget to display inside the container.
  final Widget child;

  /// Background color of the container.
  final Color? backgroundColor;

  /// Gradient background of the container.
  final Gradient? backgroundGradient;

  /// Color of the border around the container.
  final Color? borderColor;

  /// Width of the border.
  final double borderWidth;

  /// Radius of the container's corners.
  final double borderRadius;

  /// Elevation (shadow depth) of the container.
  final double? elevation;

  /// Color of the container's shadow.
  final Color? shadowColor;

  /// Fixed width of the container. If provided, overrides [minWidth] and [maxWidth].
  final double? width;

  /// Fixed height of the container. If provided, overrides [minHeight] and [maxHeight].
  final double? height;

  /// Minimum width of the container.
  final double? minWidth;

  /// Maximum width of the container.
  final double? maxWidth;

  /// Minimum height of the container.
  final double? minHeight;

  /// Maximum height of the container.
  final double? maxHeight;

  /// The clip behavior for the container. Defaults to [Clip.none].
  /// Use [Clip.antiAlias] for smooth, rounded clipping.
  final Clip clipBehavior;

  const RoundedContainer({
    super.key,
    this.margin,
    this.padding,
    required this.child,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderRadius = 10,
    this.borderWidth = 1,
    this.elevation,
    this.shadowColor,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return RistoDecorator(
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: elevation ?? 0.0,
      shadowColor: shadowColor,
      clipBehavior: clipBehavior,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? minWidth ?? 0.0,
          maxWidth: width ?? maxWidth ?? double.infinity,
          minHeight: height ?? minHeight ?? 0.0,
          maxHeight: height ?? maxHeight ?? double.infinity,
        ),
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}
