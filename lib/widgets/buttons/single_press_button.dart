import 'package:flutter/material.dart';

import 'custom_action_button.dart';

enum SinglePressButtonType { normal, rounded }

/// A smart wrapper around [CustomActionButton] that automatically handles
/// asynchronous operations, preventing double-taps and displaying a loading state.
class SinglePressButton extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Gradient? disabledBackgroundGradient;
  final Color? disabledBackgroundColor;
  final Color? foregroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final double? elevation;
  final Color? shadowColor;
  final OutlinedBorder? shape;
  final bool showLoadingIndicator;
  final Color? loadingIndicatorColor;
  final double? width;
  final double? height;
  final VoidCallback? onStartProcessing;
  final VoidCallback? onFinishProcessing;
  final void Function(Object error)? onError;
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
    double borderRadius = 8.0,
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
    // If a custom loader color is provided, we build a custom indicator,
    // otherwise CustomActionButton handles it adaptively.
    Widget? customLoader;
    if (widget.loadingIndicatorColor != null) {
      customLoader = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.loadingIndicatorColor!,
          ),
        ),
      );
    }

    final bool isDisabled = widget.onPressed == null;

    if (widget.type == SinglePressButtonType.rounded) {
      return CustomActionButton.rounded(
        onPressed: isDisabled ? null : _handlePress,
        disabled: isDisabled,
        isLoading: _isProcessing && widget.showLoadingIndicator,
        loadingIndicator: customLoader,
        margin: widget.margin,
        padding: widget.padding,
        backgroundColor: widget.backgroundColor,
        backgroundGradient: widget.backgroundGradient,
        disabledBackgroundGradient: widget.disabledBackgroundGradient,
        disabledBackgroundColor: widget.disabledBackgroundColor,
        foregroundColor: widget.foregroundColor,
        disabledForegroundColor: widget.disabledForegroundColor,
        borderColor: widget.borderColor,
        disabledBorderColor: widget.disabledBorderColor,
        elevation: widget.elevation ?? 2.0,
        shadowColor: widget.shadowColor,
        width: widget.width,
        height: widget.height,
        child: widget.child,
      );
    }

    return CustomActionButton.elevated(
      onPressed: isDisabled ? null : _handlePress,
      disabled: isDisabled,
      isLoading: _isProcessing && widget.showLoadingIndicator,
      loadingIndicator: customLoader,
      margin: widget.margin,
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
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      shape: widget.shape,
      width: widget.width,
      height: widget.height,
      child: widget.child,
    );
  }
}
