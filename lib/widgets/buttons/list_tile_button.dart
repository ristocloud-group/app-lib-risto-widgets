import 'package:flutter/material.dart';

/// A customizable list tile button that wraps content in a rounded container
/// and provides tap and long-press callbacks. Ideal for creating interactive
/// list items with consistent styling. Now supports a disabled state.
///
/// Example usage:
/// ```dart
/// ListTileButton(
///   onPressed: () {},
///   leading: Icon(Icons.star),
///   body: Text('List Tile Button'),
///   disabled: false,
/// );
/// ```
class ListTileButton extends StatelessWidget {
  // Behavior

  /// Callback when the tile is tapped. Ignored if [disabled] is true.
  final VoidCallback? onPressed;

  /// Callback when the tile is long-pressed. Ignored if [disabled] is true.
  final VoidCallback? onLongPress;

  /// Whether the button is interactive. Defaults to false.
  /// If true, onPressed/onLongPress are ignored and the button is dimmed.
  final bool disabled;

  // Layout

  /// External margin around the tile.
  final EdgeInsetsGeometry? margin;

  /// Internal padding within the tile.
  final EdgeInsetsGeometry? padding;

  /// Padding for the [body] within the [ListTile].
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding around the [leading] widget.
  final EdgeInsetsGeometry? leadingPadding;

  /// Padding around the [trailing] widget.
  final EdgeInsetsGeometry? trailingPadding;

  // Content

  /// Widget to display at the start of the tile.
  final Widget? leading;

  /// Factor to scale the size of the leading widget.
  final double leadingSizeFactor;

  /// The primary content of the tile.
  final Widget? body;

  /// Additional content displayed below the [body].
  final Widget? subtitle;

  /// Widget to display at the end of the tile.
  final Widget? trailing;

  // Style

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Border color of the tile.
  final Color? borderColor;

  /// Border radius of the tile's rounded corners.
  final double borderRadius;

  /// Elevation of the tile's shadow.
  final double? elevation;

  // Visual Aspects

  /// Visual density of the tile to control compactness.
  final VisualDensity? visualDensity;

  /// Alignment of the [body] within the tile.
  final ListTileTitleAlignment? bodyAlignment;

  // Constraints

  /// Minimum height of the tile.
  final double? minHeight;

  /// Creates a [ListTileButton] with customizable content and styling.
  const ListTileButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.disabled = false,
    this.margin,
    this.padding,
    this.bodyPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.leading,
    this.leadingSizeFactor = 1.0,
    required this.body,
    this.subtitle,
    this.trailing,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 10,
    this.elevation,
    this.visualDensity,
    this.bodyAlignment,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = Padding(
        padding: leadingPadding ?? EdgeInsets.zero,
        child: Center(
          child: SizedBox(
            key: const Key('leading_wrapper'),
            // Use IconTheme size as base for scaling if available, else default 24.0
            width: (IconTheme.of(context).size ?? 24.0) * leadingSizeFactor,
            height: (IconTheme.of(context).size ?? 24.0) * leadingSizeFactor,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: leading, // The actual leading widget (e.g., Icon)
            ),
          ),
        ),
      );
    }

    Widget? trailingWidget;
    if (trailing != null) {
      trailingWidget = Padding(
        padding: trailingPadding ?? const EdgeInsets.only(right: 12),
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: trailing,
        ),
      );
    }

    // Wrap in Opacity for disabled state
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: RoundedContainer(
        margin: margin,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        elevation: elevation,
        borderRadius: borderRadius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            // Disable callbacks if disabled
            onTap: disabled ? null : onPressed,
            onLongPress: disabled ? null : onLongPress,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minHeight ?? 50.0,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      if (leadingWidget != null) leadingWidget,
                      Expanded(
                        child: ListTile(
                          titleAlignment: bodyAlignment,
                          visualDensity: visualDensity ?? VisualDensity.compact,
                          contentPadding:
                              bodyPadding ?? const EdgeInsets.only(left: 8),
                          minVerticalPadding: 0,
                          minLeadingWidth: 0,
                          title: body,
                          subtitle: subtitle,
                          enabled: !disabled,
                        ),
                      ),
                      if (trailingWidget != null) trailingWidget,
                    ],
                  ),
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
/// Now supports a disabled state.
///
/// Example usage:
/// ```dart
/// IconListTileButton(
///   icon: Icons.settings,
///   title: Text('Settings'),
///   onPressed: () {},
///   disabled: true,
/// );
/// ```
class IconListTileButton extends StatelessWidget {
  // Behavior

  /// Callback when the tile is tapped. Ignored if [disabled] is true.
  final VoidCallback? onPressed;

  /// Whether the button is interactive. Defaults to false.
  final bool disabled;

  // Layout

  /// External margin around the tile.
  final EdgeInsetsGeometry? margin;

  /// Internal padding within the tile.
  final EdgeInsetsGeometry? padding;

  /// Padding for the [body] within the [ListTile].
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding around the [leading] widget.
  /// Defaults to [EdgeInsets.symmetric(horizontal: 5)].
  final EdgeInsetsGeometry? leadingPadding;

  /// Padding around the [trailing] widget.
  final EdgeInsetsGeometry? trailingPadding;

  // Content

  /// Icon to display at the start of the tile.
  final IconData icon;

  /// The primary content of the tile.
  final Widget title;

  /// Additional content displayed below the [title].
  final Widget? subtitle;

  /// Widget to display at the end of the tile.
  final Widget? trailing;

  // Style

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Border color of the tile.
  final Color? borderColor;

  /// Color of the icon.
  final Color? iconColor;

  /// Factor to scale the size of the leading icon.
  final double leadingSizeFactor;

  /// Elevation of the tile's shadow.
  final double? elevation;

  /// Border radius of the tile's rounded corners.
  final double borderRadius;

  /// Creates an [IconListTileButton] with an icon and customizable content.
  const IconListTileButton({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onPressed,
    this.disabled = false,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.leadingSizeFactor = 1.0,
    this.margin,
    this.padding,
    this.bodyPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.elevation,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    // Pass all parameters, including disabled, down to ListTileButton
    return ListTileButton(
      margin: margin,
      padding: padding,
      bodyPadding: bodyPadding,
      leadingPadding: leadingPadding ?? EdgeInsets.symmetric(horizontal: 5),
      trailingPadding: trailingPadding,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      elevation: elevation,
      borderRadius: borderRadius,
      body: title,
      subtitle: subtitle,
      trailing: trailing,
      onPressed: onPressed,
      disabled: disabled,
      // Pass the Icon widget directly; ListTileButton will handle scaling via FittedBox
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      leadingSizeFactor: leadingSizeFactor, // Pass the factor for scaling logic
    );
  }
}

// --- Unchanged Widgets Below ---

/// A container with rounded corners and optional border and elevation.
class RoundedContainer extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double? elevation;

  const RoundedContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 10,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        elevation: elevation ?? 0,
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor ?? Theme.of(context).cardColor,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
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
