import 'package:flutter/material.dart';

/// A widget that displays an icon alongside text in a horizontal or vertical layout.
///
/// The [CustomIconText] widget is useful for creating UI elements that combine
/// an icon and text, such as buttons, labels, or informational displays. It
/// provides flexibility in styling, alignment, and orientation.
///
/// This widget will shrink-wrap its content based on the specified [axis].
class CustomIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? textStyle;
  final int? maxLines;
  final double? iconSize;
  final double spacing;

  /// Whether to invert the order of the icon and text.
  /// If false (default), the icon comes first.
  final bool invert;

  /// The axis along which to lay out the icon and text.
  /// Defaults to [Axis.horizontal].
  final Axis axis;

  const CustomIconText({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.textStyle,
    this.maxLines = 2,
    this.iconSize,
    this.spacing = 8.0,
    this.invert = false,
    this.axis = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyMedium?.color;

    final TextStyle effectiveTextStyle =
        textStyle ??
        theme.textTheme.bodyMedium!.copyWith(color: effectiveColor);

    final iconWidget = Icon(
      icon,
      size: iconSize ?? effectiveTextStyle.fontSize,
      color: effectiveColor,
    );

    final textWidget = Flexible(
      child: Text(
        text,
        style: effectiveTextStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: axis == Axis.vertical ? TextAlign.center : null,
      ),
    );

    final spacer = SizedBox(
      width: axis == Axis.horizontal ? spacing : null,
      height: axis == Axis.vertical ? spacing : null,
    );

    final children =
        invert
            ? [textWidget, spacer, iconWidget]
            : [iconWidget, spacer, textWidget];

    return Flex(
      direction: axis,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
