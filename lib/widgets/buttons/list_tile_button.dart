import 'package:flutter/material.dart';

/// A customizable list tile button that wraps content in a rounded container
/// and provides tap and long-press callbacks. Ideal for creating interactive
/// list items with consistent styling.
///
/// Example usage:
/// ```dart
/// ListTileButton(
///   onPressed: () {},
///   leading: Icon(Icons.star),
///   body: Text('List Tile Button'),
/// );
/// ```
class ListTileButton extends StatelessWidget {
  // Behavior

  /// Callback when the tile is tapped.
  final VoidCallback? onPressed;

  /// Callback when the tile is long-pressed.
  final VoidCallback? onLongPress;

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
            // Added Key for testing
            width: 24.0 * leadingSizeFactor,
            height: 24.0 * leadingSizeFactor,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: leading,
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

    return RoundedContainer(
      margin: margin,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          onLongPress: onLongPress,
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
    );
  }
}

/// A convenience widget that combines an icon with a [ListTileButton].
///
/// Example usage:
/// ```dart
/// IconListTileButton(
///   icon: Icons.settings,
///   title: Text('Settings'),
///   onPressed: () {},
/// );
/// ```
class IconListTileButton extends StatelessWidget {
  // Behavior

  /// Callback when the tile is tapped.
  final VoidCallback? onPressed;

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
    return ListTileButton(
      margin: margin,
      padding: padding,
      bodyPadding: bodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,

      backgroundColor: backgroundColor,
      borderColor: borderColor,
      elevation: elevation,
      borderRadius: borderRadius,
      body: title,
      subtitle: subtitle,
      trailing: trailing,
      onPressed: onPressed,
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: 24.0,
      ),
      leadingSizeFactor: leadingSizeFactor,
      bodyAlignment: ListTileTitleAlignment.threeLine,
    );
  }
}

/// A container with rounded corners and optional border and elevation.
///
/// Used internally by [ListTileButton] to wrap content with consistent styling.
///
/// Example usage:
/// ```dart
/// RoundedContainer(
///   child: Text('Content'),
///   backgroundColor: Colors.white,
///   borderColor: Colors.grey,
/// );
/// ```
class RoundedContainer extends StatelessWidget {
  // Layout

  /// External margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Internal padding within the container.
  final EdgeInsetsGeometry? padding;

  // Content

  /// The widget below this widget in the tree.
  final Widget child;

  // Style

  /// Background color of the container.
  final Color? backgroundColor;

  /// Border color of the container.
  final Color? borderColor;

  /// Border radius of the container's rounded corners.
  final double borderRadius;

  /// Elevation of the container's shadow.
  final double? elevation;

  /// Creates a [RoundedContainer] with customizable styling.
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

/// A widget that displays two buttons side by side, typically used at the bottom
/// of a sheet or dialog for actions like "Confirm" and "Cancel".
///
/// Example usage:
/// ```dart
/// DoubleListTileButtons(
///   firstButton: ElevatedButton(
///     onPressed: () {},
///     child: Text('Cancel'),
///   ),
///   secondButton: ElevatedButton(
///     onPressed: () {},
///     child: Text('Confirm'),
///   ),
/// );
/// ```
class DoubleListTileButtons extends StatelessWidget {
  /// The first button to display.
  final Widget firstButton;

  /// The second button to display.
  final Widget secondButton;

  /// Padding around the buttons.
  final EdgeInsetsGeometry padding;

  /// Whether the buttons should expand to fill the available width.
  final bool expanded;

  /// Space between the two buttons.
  final double? space;

  /// Creates a [DoubleListTileButtons] widget.
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
