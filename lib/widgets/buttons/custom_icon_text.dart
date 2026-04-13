import 'package:flutter/material.dart';

/// A widget that displays an icon alongside text in a horizontal row.
///
/// The [CustomIconText] widget is useful for creating UI elements that combine
/// an icon and text, such as buttons, labels, or informational displays. It
/// provides flexibility in styling and alignment, allowing for consistent
/// presentation across different parts of the application.
///
/// This widget will shrink-wrap its content horizontally.
class CustomIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? textStyle;
  final int? maxLines;
  final double? iconSize;
  final double spacing;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.textTheme.bodyMedium?.color;

    final TextStyle effectiveTextStyle =
        textStyle ??
        theme.textTheme.bodyMedium!.copyWith(color: effectiveColor);

    return Row(
      mainAxisSize: MainAxisSize.min, // Crucial for button layouts
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize ?? effectiveTextStyle.fontSize,
          color: effectiveColor,
        ),
        SizedBox(width: spacing),
        Flexible(
          child: Text(
            text,
            style: effectiveTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
