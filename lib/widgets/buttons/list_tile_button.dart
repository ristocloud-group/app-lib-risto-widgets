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
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool disabled;

  // Layout
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? bodyPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;

  // Content
  final Widget? leading;
  final double leadingSizeFactor;
  final Widget? body;
  final Widget? subtitle;
  final Widget? trailing;

  // Style
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double? elevation;

  // Visual Aspects
  final VisualDensity? visualDensity;
  final Alignment blockAlignment;

  // Constraints
  final double minHeight;

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
    this.blockAlignment = Alignment.centerLeft,
    this.minHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    // Leading icon or widget
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = Padding(
        padding: leadingPadding ?? EdgeInsets.zero,
        child: SizedBox(
          width: (IconTheme.of(context).size ?? 24) * leadingSizeFactor,
          height: (IconTheme.of(context).size ?? 24) * leadingSizeFactor,
          child: FittedBox(child: leading!),
        ),
      );
    }

    // Title and subtitle stacked vertically
    Widget textBlock = Padding(
      padding: bodyPadding ?? const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (body != null)
            DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: disabled ? Colors.grey : null),
              child: body!,
            ),
          if (subtitle != null)
            DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: disabled ? Colors.grey : null),
              child: subtitle!,
            ),
        ],
      ),
    );

    // Combine leading + text
    Widget block = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingWidget != null) leadingWidget,
        Flexible(child: textBlock),
      ],
    );

    // Trailing widget
    Widget? trailingWidget;
    if (trailing != null) {
      trailingWidget = Padding(
        padding: trailingPadding ?? const EdgeInsets.only(left: 12),
        child: trailing,
      );
    }

    // Determine the effective minHeight for the Container
    BoxConstraints constraints = BoxConstraints(
      minHeight: minHeight,
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: RoundedContainer(
        margin: margin,
        padding: padding,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderRadius: borderRadius,
        elevation: elevation,
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: disabled ? null : onPressed,
            onLongPress: disabled ? null : onLongPress,
            child: Container(
              padding: padding ?? const EdgeInsets.all(8),
              constraints: constraints, // Apply the dynamic constraints
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: blockAlignment,
                      child: block,
                    ),
                  ),
                  if (trailingWidget != null) ...[
                    const SizedBox(width: 8),
                    trailingWidget,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A convenience widget that combines an icon with a [ListTileButton].
/// Now supports a disabled state and minHeight constraint.
///
/// Example usage:
/// ```dart
/// IconListTileButton(
///   icon: Icons.settings,
///   title: Text('Settings'),
///   onPressed: () {},
///   disabled: true,
///   minHeight: 70,
/// );
/// ```
class IconListTileButton extends StatelessWidget {
  // Behavior
  final VoidCallback? onPressed;
  final bool disabled;

  // Layout
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? bodyPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;

  // Content
  final IconData icon;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  // Style
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double leadingSizeFactor;
  final double? elevation;
  final double borderRadius;

  // Visual Aspects
  final VisualDensity? visualDensity;
  final Alignment blockAlignment;

  // Constraints
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
    this.visualDensity,
    this.blockAlignment = Alignment.centerLeft,
    this.minHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileButton(
      margin: margin,
      padding: padding,
      bodyPadding: bodyPadding,
      leadingPadding:
          leadingPadding ?? const EdgeInsets.symmetric(horizontal: 5),
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
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      leadingSizeFactor: leadingSizeFactor,
      visualDensity: visualDensity,
      blockAlignment: blockAlignment,
      minHeight: minHeight,
    );
  }
}

/// A container with rounded corners and optional border and elevation.
class RoundedContainer extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final double? elevation;

  const RoundedContainer({
    super.key,
    this.margin,
    this.padding,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 10,
    this.borderWidth = 1,
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
