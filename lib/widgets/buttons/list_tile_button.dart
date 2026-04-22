import 'package:flutter/material.dart';

import '../layouts/risto_decorator.dart'; // Import our new universal decorator

/// A customizable, tappable list tile styled as a rounded card.
///
/// Features:
/// - Leading widget support (icon or custom widget).
/// - Main content (`body`) and optional `subtitle`, both aligned via `contentAlignment`.
/// - Optional trailing widget (icon or custom).
/// - Disabled state with reduced opacity and callbacks disabled.
/// - Configurable margins, paddings, border, background, elevation, and shadow color.
/// - Configurable width and height constraints.
class ListTileButton extends StatelessWidget {
  /// Called when the tile is tapped.
  final VoidCallback? onPressed;

  /// Called when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// When true, reduces opacity and disables tap callbacks.
  final bool disabled;

  /// Outer margin around the rounded container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the container around the row.
  final EdgeInsetsGeometry? padding;

  /// Horizontal padding applied around the text block.
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding around the leading widget.
  final EdgeInsetsGeometry? leadingPadding;

  /// Padding around the trailing widget.
  final EdgeInsetsGeometry? trailingPadding;

  /// Optional leading widget (icon or custom).
  final Widget? leading;

  /// Scale factor for the leading widget’s size.
  final double leadingSizeFactor;

  /// Main content of the tile.
  final Widget body;

  /// Optional subtitle below [body].
  final Widget? subtitle;

  /// Optional trailing widget (icon or custom).
  final Widget? trailing;

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Gradient background color of the tile.
  final Gradient? backgroundGradient;

  /// Disabled background color of the tile.
  final Gradient? disabledBackgroundGradient;

  /// Border color of the tile.
  final Color? borderColor;

  /// Color of the shadow when [elevation] is set.
  final Color? shadowColor;

  /// Corner radius of the tile.
  final double borderRadius;

  /// Elevation (shadow depth) of the tile.
  final double? elevation;

  /// Alignment of the [body] and [subtitle] within their column.
  final Alignment contentAlignment;

  /// Fixed width of the tile. If provided, overrides [minWidth] and [maxWidth].
  final double? width;

  /// Fixed height of the tile. If provided, overrides [minHeight] and [maxHeight].
  final double? height;

  /// Minimum width of the tile.
  final double? minWidth;

  /// Maximum width of the tile.
  final double? maxWidth;

  /// Minimum height of the tile. Defaults to 60.0.
  final double minHeight;

  /// Maximum height of the tile.
  final double? maxHeight;

  const ListTileButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.disabled = false,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.bodyPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.leading,
    this.leadingSizeFactor = 1.0,
    required this.body,
    this.subtitle,
    this.trailing,
    this.backgroundColor,
    this.backgroundGradient,
    this.disabledBackgroundGradient,
    this.borderColor,
    this.shadowColor,
    this.borderRadius = 10,
    this.elevation,
    this.contentAlignment = Alignment.centerLeft,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight = 60.0,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final CrossAxisAlignment textCross = contentAlignment.x <= -0.5
        ? CrossAxisAlignment.start
        : contentAlignment.x >= 0.5
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.center;

    final Widget? leadingWidget = leading == null
        ? null
        : Padding(
            padding: leadingPadding ?? EdgeInsets.zero,
            child: SizedBox(
              width: (IconTheme.of(context).size ?? 24) * leadingSizeFactor,
              height: (IconTheme.of(context).size ?? 24) * leadingSizeFactor,
              child: FittedBox(child: leading!),
            ),
          );

    final Widget? trailingWidget = trailing == null
        ? null
        : Padding(padding: trailingPadding ?? EdgeInsets.zero, child: trailing);

    final Widget textBlock = Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: textCross,
          children: [
            body,
            if (subtitle != null) ...[const SizedBox(height: 4), subtitle!],
          ],
        ),
      ),
    );

    final Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [?leadingWidget, textBlock, ?trailingWidget],
    );

    final Gradient? effectiveGradient = disabled
        ? disabledBackgroundGradient ?? backgroundGradient
        : backgroundGradient;

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      // Replaced RoundedContainer with RistoDecorator!
      child: RistoDecorator(
        margin: margin,
        backgroundColor: backgroundColor,
        backgroundGradient: effectiveGradient,
        borderColor: borderColor,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation ?? 0.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: width ?? minWidth ?? 0.0,
            maxWidth: width ?? maxWidth ?? double.infinity,
            minHeight: height ?? minHeight,
            maxHeight: height ?? maxHeight ?? double.infinity,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: disabled ? null : onPressed,
              onLongPress: disabled ? null : onLongPress,
              child: Padding(padding: padding ?? EdgeInsets.zero, child: row),
            ),
          ),
        ),
      ),
    );
  }
}

/// A convenience widget that combines an icon with a [ListTileButton].
/// Supports a disabled state, shadow color, gradient backgrounds,
/// and multiple sizing constraints.
class IconListTileButton extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool disabled;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Gradient? disabledBackgroundGradient;
  final Color? borderColor;
  final Color? iconColor;
  final Color? shadowColor;
  final double leadingSizeFactor;
  final double? elevation;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? bodyPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;
  final Alignment contentAlignment;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final double minHeight;
  final double? maxHeight;

  const IconListTileButton({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onPressed,
    this.disabled = false,
    this.backgroundColor,
    this.backgroundGradient,
    this.disabledBackgroundGradient,
    this.borderColor,
    this.iconColor,
    this.shadowColor,
    this.leadingSizeFactor = 1.0,
    this.elevation,
    this.borderRadius = 10,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.bodyPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.contentAlignment = Alignment.centerLeft,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight = 60.0,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileButton(
      onPressed: onPressed,
      disabled: disabled,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
      bodyPadding: bodyPadding,
      leadingPadding:
          leadingPadding ?? const EdgeInsets.symmetric(horizontal: 5),
      trailingPadding: trailingPadding,
      width: width,
      height: height,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      leadingSizeFactor: leadingSizeFactor,
      body: title,
      subtitle: subtitle,
      trailing: trailing,
      contentAlignment: contentAlignment,
    );
  }
}

/// A widget that displays two buttons side by side.
class DoubleListTileButtons extends StatelessWidget {
  final Widget firstButton;
  final Widget secondButton;
  final EdgeInsetsGeometry padding;
  final bool expanded;
  final double? space;

  const DoubleListTileButtons({
    super.key,
    required this.firstButton,
    required this.secondButton,
    this.padding = EdgeInsets.zero,
    this.expanded = true,
    this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: expanded
            ? [
                Expanded(child: firstButton),
                SizedBox(width: space ?? 8),
                Expanded(child: secondButton),
              ]
            : [firstButton, SizedBox(width: space ?? 8), secondButton],
      ),
    );
  }
}
