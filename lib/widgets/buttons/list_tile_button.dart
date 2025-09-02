import 'package:flutter/material.dart';

/// A customizable, tappable list tile styled as a rounded card.
///
/// Features:
/// - Leading widget support (icon or custom widget).
/// - Main content (`body`) and optional `subtitle`, both aligned via `contentAlignment`.
/// - Optional trailing widget (icon or custom).
/// - Disabled state with reduced opacity and callbacks disabled.
/// - Configurable margins, paddings, border, background, elevation, and shadow color.
/// - Minimum height constraint for consistent sizing.
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

  /// Alignment of the [body] and [subtitle] within their column
  /// (e.g. `Alignment.centerLeft`, `Alignment.center`, `Alignment.centerRight`).
  final Alignment contentAlignment;

  /// Minimum height of the tile.
  final double minHeight;

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
    this.minHeight = 60.0,
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
        : Padding(
            padding: trailingPadding ?? EdgeInsets.zero,
            child: trailing,
          );

    final Widget textBlock = Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: textCross,
          children: [
            body,
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              subtitle!,
            ],
          ],
        ),
      ),
    );

    final Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingWidget != null) leadingWidget,
        textBlock,
        if (trailingWidget != null) trailingWidget,
      ],
    );

    // Pick active/disabled gradient if present
    final Gradient? effectiveGradient = disabled
        ? disabledBackgroundGradient ?? backgroundGradient
        : backgroundGradient;

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: RoundedContainer(
        margin: margin,
        backgroundColor:
            effectiveGradient != null ? Colors.transparent : backgroundColor,
        borderColor: borderColor,
        shadowColor: shadowColor,
        borderRadius: borderRadius,
        elevation: elevation,
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: effectiveGradient,
              color: effectiveGradient == null ? backgroundColor : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: disabled ? null : onPressed,
              onLongPress: disabled ? null : onLongPress,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: row,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A convenience widget that combines an icon with a [ListTileButton].
/// Supports a disabled state, shadow color, gradient backgrounds,
/// and minimum height constraint.
///
/// Example usage:
/// ```dart
/// IconListTileButton(
///   icon: Icons.settings,
///   title: Text('Settings'),
///   onPressed: () {},
///   disabled: true,
///   shadowColor: Colors.grey,
///   backgroundGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
///   minHeight: 70,
/// );
/// ```
class IconListTileButton extends StatelessWidget {
  /// The icon to display as the leading widget.
  final IconData icon;

  /// The primary text of the tile.
  final Widget title;

  /// Optional subtitle text below the title.
  final Widget? subtitle;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Called when the tile is tapped.
  final VoidCallback? onPressed;

  /// When true, the tile is disabled (reduced opacity and callbacks disabled).
  final bool disabled;

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Gradient background of the tile when enabled.
  final Gradient? backgroundGradient;

  /// Gradient background of the tile when disabled.
  final Gradient? disabledBackgroundGradient;

  /// Border color of the tile.
  final Color? borderColor;

  /// Color of the leading icon.
  final Color? iconColor;

  /// Color of the shadow when elevation is set.
  final Color? shadowColor;

  /// Scale factor for the leading icon size.
  final double leadingSizeFactor;

  /// Elevation (shadow depth) of the tile.
  final double? elevation;

  /// Radius of the tile corners.
  final double borderRadius;

  /// Outer margin around the tile.
  final EdgeInsetsGeometry? margin;

  /// Inner padding of the tile container.
  final EdgeInsetsGeometry? padding;

  /// Padding around the title and subtitle.
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding around the leading icon.
  final EdgeInsetsGeometry? leadingPadding;

  /// Padding around the trailing widget.
  final EdgeInsetsGeometry? trailingPadding;

  /// Alignment of the title and subtitle within the text column.
  final Alignment contentAlignment;

  /// Minimum height of the tile.
  final double minHeight;

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
    this.minHeight = 60.0,
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
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      leadingSizeFactor: leadingSizeFactor,
      body: title,
      subtitle: subtitle,
      trailing: trailing,
      contentAlignment: contentAlignment,
      minHeight: minHeight,
    );
  }
}

/// A container with rounded corners, optional border, and elevation with custom shadow color.
/// Supports both solid background colors and gradient backgrounds.
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
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradient = backgroundGradient != null;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        elevation: elevation ?? 0,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(borderRadius),
        color: useGradient
            ? Colors.transparent
            : (backgroundColor ?? Theme.of(context).cardColor),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: backgroundGradient,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null,
          ),
          child: child,
        ),
      ),
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
            : [
                firstButton,
                SizedBox(width: space ?? 8),
                secondButton,
              ],
      ),
    );
  }
}
