import 'package:flutter/material.dart';

import 'custom_action_button.dart';

enum SinglePressButtonType { normal, rounded }

class SinglePressButton extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// Typically, this is the content of the button, such as text or an icon.
  final Widget child;

  /// The callback that is called when the button is tapped.
  ///
  /// This callback can be asynchronous and is invoked only once per press.
  /// It is responsible for handling the primary action of the button.
  /// If null, the button is disabled.
  final Future<void> Function()? onPressed;

  /// The amount of space to surround the child inside the button.
  ///
  /// If not specified, default padding is applied.
  final EdgeInsetsGeometry? padding;

  /// The external margin around the button.
  ///
  /// This margin wraps the button, providing space between it and other widgets.
  final EdgeInsetsGeometry? margin;

  /// The background color of the button when enabled.
  ///
  /// If not specified, the button uses the theme's primary color.
  final Color? backgroundColor;

  /// The gradient used for the button background.
  ///
  /// Overrides [backgroundColor] when provided.
  final Gradient? backgroundGradient;

  /// The gradient used for the button background when disabled.
  ///
  /// If not specified, a faded/lightened version of [backgroundGradient]
  /// is generated automatically. Falls back to a solid
  /// [disabledBackgroundColor] if no gradient is available.
  final Gradient? disabledBackgroundGradient;

  /// The background color of the button when disabled.
  ///
  /// This color is displayed when the button is in a processing or disabled state.
  /// If not specified, it defaults to the theme's disabled color.
  final Color? disabledBackgroundColor;

  /// The foreground color (text/icon color) of the button.
  ///
  /// If not specified, the button's text color will be derived from the theme.
  final Color? foregroundColor;

  /// The foreground color of the button when disabled.
  ///
  /// If not specified, a lighter version of [foregroundColor] or
  /// the theme's disabled color will be used.
  final Color? disabledForegroundColor;

  /// The border color of the button when enabled.
  final Color? borderColor;

  /// The border color of the button when disabled.
  final Color? disabledBorderColor;

  /// The border radius of the button.
  ///
  /// Controls the roundness of the button's corners.
  /// Defaults to 8.0.
  final double borderRadius;

  /// The text style for the button's label.
  ///
  /// If not specified, it inherits the theme's text style.
  final TextStyle? textStyle;

  /// The elevation of the button.
  ///
  /// Controls the shadow depth of the button.
  /// If not specified, it defaults to the theme's elevated button elevation.
  final double? elevation;

  /// The shadow color of the button when elevation is applied.
  ///
  /// If not specified, it defaults to the theme's shadow color.
  final Color? shadowColor;

  /// The shape of the button's material.
  ///
  /// Allows for customizing the button's outline and borders.
  /// If not specified, a rounded rectangle is used.
  final OutlinedBorder? shape;

  /// Whether to show a loading indicator while processing.
  ///
  /// If set to `true`, a [CircularProgressIndicator] is displayed on top of the button's child.
  /// Defaults to `false`.
  final bool showLoadingIndicator;

  /// The color of the loading indicator.
  ///
  /// If not specified, it defaults to the theme's [ColorScheme.onPrimary].
  final Color? loadingIndicatorColor;

  /// The width of the button.
  ///
  /// If not specified, the button will size itself based on its child's size constraints.
  final double? width;

  /// The height of the button.
  ///
  /// If not specified, the button will size itself based on its child's size constraints.
  final double? height;

  /// Callback invoked when the button starts processing.
  ///
  /// Useful for triggering actions like disabling other UI elements.
  final VoidCallback? onStartProcessing;

  /// Callback invoked when the button finishes processing.
  ///
  /// Useful for resetting states or triggering subsequent actions.
  final VoidCallback? onFinishProcessing;

  /// Callback invoked when an error occurs during processing.
  ///
  /// Provides a way to handle exceptions thrown by the [onPressed] callback.
  final void Function(Object error)? onError;

  /// Determines the visual style of the button.
  ///
  /// - [SinglePressButtonType.normal]: Standard rectangular button.
  /// - [SinglePressButtonType.rounded]: Fully rounded "pill" style button.
  final SinglePressButtonType? type;

  const SinglePressButton({
    super.key,
    required this.child,
    this.type = SinglePressButtonType.normal,
    this.onPressed,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.backgroundGradient,
    this.disabledBackgroundGradient,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.disabledBorderColor,
    this.borderRadius = 8.0,
    this.textStyle,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.showLoadingIndicator = false,
    this.loadingIndicatorColor,
    this.width,
    this.height,
    this.onStartProcessing,
    this.onFinishProcessing,
    this.onError,
  });

  /// Factory for the rounded version (uses `CustomActionButton.rounded`)
  factory SinglePressButton.rounded({
    Key? key,
    required Widget child,
    Future<void> Function()? onPressed,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    Color? disabledBackgroundColor,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    Color? disabledBorderColor,
    double borderRadius = 8.0, // don’t override, let user pick
    TextStyle? textStyle,
    double? elevation,
    Color? shadowColor,
    OutlinedBorder? shape,
    bool showLoadingIndicator = false,
    Color? loadingIndicatorColor,
    double? width,
    double? height,
    VoidCallback? onStartProcessing,
    VoidCallback? onFinishProcessing,
    void Function(Object error)? onError,
  }) {
    return SinglePressButton(
      key: key,
      type: SinglePressButtonType.rounded,
      onPressed: onPressed,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      disabledBackgroundColor: disabledBackgroundColor,
      foregroundColor: foregroundColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      disabledBorderColor: disabledBorderColor,
      borderRadius: borderRadius,
      textStyle: textStyle,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      showLoadingIndicator: showLoadingIndicator,
      loadingIndicatorColor: loadingIndicatorColor,
      width: width,
      height: height,
      onStartProcessing: onStartProcessing,
      onFinishProcessing: onFinishProcessing,
      onError: onError,
      child: child,
    );
  }

  @override
  State<SinglePressButton> createState() => _SinglePressButtonState();
}

class _SinglePressButtonState extends State<SinglePressButton> {
  bool _isProcessing = false;

  Future<void> _handlePress() async {
    if (_isProcessing || widget.onPressed == null) return;
    setState(() => _isProcessing = true);
    widget.onStartProcessing?.call();
    try {
      await widget.onPressed!();
    } catch (error) {
      widget.onError?.call(error);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        widget.onFinishProcessing?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = _isProcessing || widget.onPressed == null;
    final child = _buildChild(context);

    final button = switch (widget.type) {
      SinglePressButtonType.rounded => CustomActionButton.rounded(
          onPressed: isDisabled ? null : _handlePress,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          backgroundGradient: widget.backgroundGradient,
          disabledBackgroundGradient: widget.disabledBackgroundGradient,
          disabledBackgroundColor: widget.disabledBackgroundColor,
          foregroundColor: widget.foregroundColor,
          disabledForegroundColor: widget.disabledForegroundColor,
          borderColor: widget.borderColor,
          disabledBorderColor: widget.disabledBorderColor,
          elevation: widget.elevation ?? 0,
          shadowColor: widget.shadowColor,
          width: widget.width,
          height: widget.height,
          child: child,
        ),
      _ => CustomActionButton(
          onPressed: isDisabled ? null : _handlePress,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          backgroundGradient: widget.backgroundGradient,
          disabledBackgroundGradient: widget.disabledBackgroundGradient,
          disabledBackgroundColor: widget.disabledBackgroundColor,
          foregroundColor: widget.foregroundColor,
          disabledForegroundColor: widget.disabledForegroundColor,
          borderColor: widget.borderColor,
          disabledBorderColor: widget.disabledBorderColor,
          borderRadius: widget.borderRadius,
          elevation: widget.elevation,
          shadowColor: widget.shadowColor,
          shape: widget.shape,
          width: widget.width,
          height: widget.height,
          child: child,
        ),
    };

    return Container(
      margin: widget.margin,
      child: button,
    );
  }

  Widget _buildChild(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (_isProcessing && widget.showLoadingIndicator)
          Positioned.fill(
            child: Center(
              child: FittedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.loadingIndicatorColor ??
                        Theme.of(context).colorScheme.onPrimary,
                  ),
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
