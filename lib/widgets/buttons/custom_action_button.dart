import 'dart:async';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

/// Types of buttons available in [CustomActionButton].
enum ButtonType { elevated, flat, minimal, longPress }

/// A customizable button widget that can be configured as elevated, flat,
/// minimal, or long-press button types. Provides a flexible API to adjust
/// styles, colors, shapes, and behaviors.
///
/// The [CustomActionButton] supports different visual styles through the
/// [ButtonType] enum and offers factory constructors for convenience.
///
/// Example usage:
/// ```dart
/// CustomActionButton.elevated(
///   onPressed: () {},
///   child: Text('Elevated Button'),
/// );
/// ```
class CustomActionButton extends StatefulWidget {
  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The callback that is called when the button is long-pressed.
  /// Only used when [buttonType] is [ButtonType.longPress].
  final VoidCallback? onLongPress;

  /// The child widget to display inside the button.
  final Widget child;

  /// The type of button to display.
  final ButtonType? buttonType;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The foreground color (text/icon color) of the button.
  final Color? foregroundColor;

  /// The shadow color of the button.
  final Color? shadowColor;

  /// The splash color of the button when tapped.
  final Color? splashColor;

  /// The background color of the button when it is disabled.
  final Color? disabledBackgroundColor;

  /// The border color of the button when it is disabled.
  final Color? disabledBorderColor;

  /// The text color of the button when it is disabled.
  final Color? disabledForegroundColor;

  /// The border color of the button.
  final Color? borderColor;

  /// The elevation of the button.
  final double? elevation;

  /// The border radius of the button.
  final double? borderRadius;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// The shape of the button's material.
  final OutlinedBorder? shape;

  /// The amount of space to surround the child inside the button.
  final EdgeInsetsGeometry? padding;

  /// The external margin around the button.
  final EdgeInsetsGeometry? margin;

  /// The splash factory to define interaction effects.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Creates a [CustomActionButton] with the given parameters.
  const CustomActionButton({
    super.key,
    required this.child,
    this.buttonType,
    this.onPressed,
    this.onLongPress,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.splashColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.width,
    this.height,
    this.shape,
    this.padding,
    this.margin,
    this.splashFactory,
  });

  /// Creates an elevated button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.elevated({
    required VoidCallback? onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBorderColor,
    Color? borderColor,
    double elevation = 2.0,
    double borderRadius = 8.0,
    BorderSide? side,
    OutlinedBorder? shape,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      buttonType: ButtonType.elevated,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      elevation: elevation,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      child: child,
    );
  }

  /// Creates a flat button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.flat({
    required VoidCallback? onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderRadius = 8.0,
    BorderSide? side,
    OutlinedBorder? shape,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      buttonType: ButtonType.flat,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      child: child,
    );
  }

  /// Creates a minimal button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.minimal({
    required VoidCallback? onPressed,
    required Widget child,
    Color? borderColor,
    Color? foregroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    double? width,
    double? height,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomActionButton(
      buttonType: ButtonType.minimal,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      width: width,
      height: height,
      shape: shape,
      padding: padding,
      margin: margin,
      child: child,
    );
  }

  /// Creates a long-press button.
  ///
  /// The [onPressed], [onLongPress], and [child] parameters are required.
  factory CustomActionButton.longPress({
    required VoidCallback? onPressed,
    required VoidCallback? onLongPress,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double elevation = 2.0,
    double borderRadius = 8.0,
    BorderSide? side,
    OutlinedBorder? shape,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      buttonType: ButtonType.longPress,
      onPressed: onPressed,
      onLongPress: onLongPress,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      elevation: elevation,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      child: child,
    );
  }

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  Timer? _longPressTimer;

  /// Returns a lighter version of the given [color] by interpolating towards white.
  Color _lighter(Color color, [double amount = 0.5]) {
    return Color.lerp(color, Colors.white, amount)!;
  }

  /// Returns the color to use when disabled.
  ///
  /// If [disabled] is provided, it is used; otherwise, if [normal] is provided,
  /// returns a lighter version of it; if neither is provided, returns [fallback].
  Color _disabledColor(Color? disabled, Color? normal, Color fallback) {
    if (disabled != null) return disabled;
    if (normal != null) return _lighter(normal, 0.5);
    return fallback;
  }

  /// Computes the effective text style based on the disabled state.
  TextStyle _effectiveTextStyle(BuildContext context,
      {required bool disabled}) {
    if (disabled) {
      return TextStyle(
        color: _disabledColor(
          widget.disabledForegroundColor,
          widget.foregroundColor,
          Theme.of(context).disabledColor,
        ),
      );
    } else {
      return TextStyle(
        color: widget.foregroundColor ??
            Theme.of(context).textTheme.labelLarge?.color ??
            Colors.white,
      );
    }
  }

  /// Wraps the child with a DefaultTextStyle using the effective text style.
  Widget _wrapChild(BuildContext context, {required bool disabled}) {
    return DefaultTextStyle(
      style: _effectiveTextStyle(context, disabled: disabled),
      child: widget.child,
    );
  }

  /// Handles long-press actions by periodically invoking [widget.onLongPress].
  void _handleLongPress() {
    if (widget.onLongPress != null) {
      _longPressTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          widget.onLongPress?.call();
        },
      );
    }
  }

  /// Cancels the ongoing long-press action.
  void _cancelLongPress() {
    _longPressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed == null && widget.buttonType != ButtonType.longPress) {
      return _buildDisabledButton(context);
    }

    switch (widget.buttonType) {
      case ButtonType.minimal:
        return _buildMinimalButton(context);
      case ButtonType.longPress:
        return _buildLongPressButton(context);
      case ButtonType.elevated:
        return _buildElevatedButton(context);
      case ButtonType.flat:
      default:
        return _buildFlatButton(context);
    }
  }

  /// Builds the disabled button.
  Widget _buildDisabledButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      overlayColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _disabledColor(widget.disabledForegroundColor,
          widget.foregroundColor, Theme.of(context).disabledColor),
      backgroundColor: _disabledColor(widget.disabledBackgroundColor,
          widget.backgroundColor, Theme.of(context).disabledColor),
      shadowColor: widget.shadowColor ?? Colors.black,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: widget.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
            // For the border, apply the disabled logic only if a base border color is provided.
            side: (widget.borderColor != null ||
                    widget.disabledBorderColor != null)
                ? BorderSide(
                    color: _disabledColor(widget.disabledBorderColor,
                        widget.borderColor, Theme.of(context).disabledColor),
                    width: 1,
                  )
                : BorderSide.none,
          ),
      elevation: widget.elevation,
    );

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: AbsorbPointer(
        absorbing: true,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {},
          child: _wrapChild(context, disabled: true),
        ),
      ),
    );
  }

  /// Builds the elevated button style.
  Widget _buildElevatedButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      // The foregroundColor is used for icons; text is wrapped with DefaultTextStyle.
      foregroundColor: widget.foregroundColor ?? Colors.white,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
      shadowColor: widget.shadowColor,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: widget.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
            side: widget.borderColor != null
                ? BorderSide(color: widget.borderColor!, width: 1)
                : BorderSide.none,
          ),
      elevation: widget.elevation ?? 2.0,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
    );

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
    );
  }

  /// Builds the flat button style.
  Widget _buildFlatButton(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
      overlayColor: widget.splashColor ?? Colors.grey.withCustomOpacity(0.2),
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: widget.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
            side: widget.borderColor != null
                ? BorderSide(color: widget.borderColor!, width: 1)
                : BorderSide.none,
          ),
      splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
    );

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: TextButton(
        style: buttonStyle,
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
    );
  }

  /// Builds the minimal button style.
  Widget _buildMinimalButton(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.black,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: widget.shape ?? const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      side: widget.borderColor != null
          ? BorderSide(color: widget.borderColor!, width: 1)
          : BorderSide.none,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: TextButton(
        style: buttonStyle,
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
    );
  }

  /// Builds the long-press button style.
  Widget _buildLongPressButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).primaryColor,
      shadowColor: widget.shadowColor,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: widget.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
            side: widget.borderColor != null
                ? BorderSide(color: widget.borderColor!, width: 1)
                : BorderSide.none,
          ),
      elevation: widget.elevation ?? 2.0,
    ).copyWith(
      overlayColor: widget.splashColor != null
          ? WidgetStateProperty.all(widget.splashColor)
          : null,
      splashFactory: widget.splashFactory,
    );

    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onTap: widget.onPressed,
        onLongPressStart: (_) => _handleLongPress(),
        onLongPressEnd: (_) => _cancelLongPress(),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: widget.onPressed,
          child: _wrapChild(context, disabled: false),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }
}
