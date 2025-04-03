import 'package:flutter/material.dart';

/// A widget that displays an icon alongside text in a horizontal row.
///
/// The [CustomIconText] widget is useful for creating UI elements that combine
/// an icon and text, such as buttons, labels, or informational displays. It
/// provides flexibility in styling and alignment, allowing for consistent
/// presentation across different parts of the application.
///
/// Example usage:
/// ```dart
/// CustomIconText(
///   icon: Icons.home,
///   text: 'Home',
///   color: Colors.blue,
///   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
///   iconSize: 24.0,
///   spacing: 12.0,
/// );
/// ```
class CustomIconText extends StatelessWidget {
  /// The icon to display.
  ///
  /// This icon appears to the left of the text. It is required and cannot be null.
  final IconData icon;

  /// The text to display alongside the icon.
  ///
  /// This text appears to the right of the icon. It is required and cannot be null.
  final String text;

  /// The color of the icon and text.
  ///
  /// If [color] is provided, it overrides the default colors from the current
  /// theme for both the icon and text. If not specified, the icon color defaults
  /// to the theme's [IconThemeData.color], and the text color defaults to the
  /// theme's [TextTheme.bodyMedium.color].
  final Color? color;

  /// The alignment of the icon and text within the row.
  ///
  /// Controls how the children are placed along the main axis (horizontal).
  /// Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// The text style to apply to the [text].
  ///
  /// If [textStyle] is provided, it overrides the default text style from the
  /// current theme. If not specified, it defaults to the theme's [TextTheme.bodyMedium].
  final TextStyle? textStyle;

  /// The size of the icon.
  ///
  /// If [iconSize] is provided, it overrides the default icon size. If not
  /// specified, the icon size defaults to the font size of the [textStyle].
  final double? iconSize;

  /// The horizontal spacing between the icon and the text.
  ///
  /// Defaults to 8.0 logical pixels.
  final double spacing;

  /// Creates a [CustomIconText] widget.
  ///
  /// The [icon] and [text] parameters are required and must not be null.
  /// The [mainAxisAlignment] defaults to [MainAxisAlignment.center].
  /// The [spacing] defaults to 8.0.
  const CustomIconText({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.textStyle,
    this.iconSize,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the effective text style by merging the provided [textStyle]
    // with the theme's default if [textStyle] is not provided.
    final TextStyle effectiveTextStyle = textStyle ??
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: color ?? Theme.of(context).textTheme.bodyMedium!.color,
            );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// The icon widget.
        ///
        /// Uses the [iconSize] if provided; otherwise, defaults to the font size
        /// of the [textStyle]. The color defaults to the theme's icon color
        /// unless [color] is specified.
        Icon(
          icon,
          size: iconSize ?? effectiveTextStyle.fontSize,
          color: color ?? Theme.of(context).iconTheme.color,
        ),

        /// Spacer between the icon and text.
        SizedBox(width: spacing),

        /// The text widget.
        ///
        /// Uses the [effectiveTextStyle] and ensures that long text is truncated
        /// with an ellipsis if it overflows.
        Flexible(
          child: Text(
            text,
            style: effectiveTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
