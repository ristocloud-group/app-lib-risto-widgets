import 'dart:async';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../layouts/risto_decorator.dart';

/// Types of buttons available in [CustomActionButton].
enum ButtonType { elevated, flat, minimal, longPress, rounded }

/// A highly customizable, unified button widget that leverages [RistoDecorator]
/// to provide perfectly consistent backgrounds, gradients, borders, and shadows.
class CustomActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final Widget? icon;
  final double iconSpacing;
  final ButtonType? buttonType;

  /// Explicitly disables the button, rendering it in a greyed-out state and blocking interactions.
  final bool disabled;

  /// Swaps the child for a loading indicator and blocks interactions,
  /// but maintains the active button styling.
  final bool isLoading;

  /// A custom loading indicator. Defaults to an adaptive [CircularProgressIndicator].
  final Widget? loadingIndicator;

  final Gradient? backgroundGradient;
  final Gradient? disabledBackgroundGradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final Color? splashColor;
  final Color? disabledBackgroundColor;
  final Color? disabledBorderColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? elevation;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double minHeight;
  final OutlinedBorder? shape;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final InteractiveInkFeatureFactory? splashFactory;
  final MaterialTapTargetSize? tapTargetSize;

  const CustomActionButton({
    super.key,
    required this.child,
    this.icon,
    this.iconSpacing = 8.0,
    this.buttonType,
    this.onPressed,
    this.onLongPress,
    this.disabled = false,
    this.isLoading = false,
    this.loadingIndicator,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.splashColor,
    this.disabledBackgroundColor,
    this.disabledBorderColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.elevation,
    this.borderRadius,
    this.width,
    this.height,
    this.minHeight = 60.0,
    this.shape,
    this.padding,
    this.margin,
    this.backgroundGradient,
    this.disabledBackgroundGradient,
    this.splashFactory,
    this.tapTargetSize,
  });

  factory CustomActionButton.elevated({
    Key? key,
    VoidCallback? onPressed,
    required Widget child,
    Widget? icon,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBorderColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double elevation = 2.0,
    double borderRadius = 8.0,
    OutlinedBorder? shape,
    double? width,
    double? height,
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.elevated,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      icon: icon,
      iconSpacing: iconSpacing,
      tapTargetSize: tapTargetSize,
      child: child,
    );
  }

  factory CustomActionButton.flat({
    Key? key,
    VoidCallback? onPressed,
    required Widget child,
    Widget? icon,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 8.0,
    OutlinedBorder? shape,
    double? width,
    double? height,
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.flat,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      icon: icon,
      iconSpacing: iconSpacing,
      tapTargetSize: tapTargetSize,
      child: child,
    );
  }

  factory CustomActionButton.minimal({
    Key? key,
    VoidCallback? onPressed,
    required Widget child,
    Widget? icon,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? borderColor,
    double borderWidth = 1.0,
    Color? foregroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? shadowColor,
    double? width,
    double? height,
    double minHeight = 60.0,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    Gradient? disabledBackgroundGradient,
    EdgeInsetsGeometry? margin,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.minimal,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      foregroundColor: foregroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadowColor: shadowColor,
      width: width,
      height: height,
      minHeight: minHeight,
      shape: shape,
      padding: padding,
      margin: margin,
      disabledBackgroundGradient: disabledBackgroundGradient,
      icon: icon,
      iconSpacing: iconSpacing,
      tapTargetSize: tapTargetSize,
      child: child,
    );
  }

  factory CustomActionButton.longPress({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    required Widget child,
    Widget? icon,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double elevation = 2.0,
    double borderRadius = 8.0,
    OutlinedBorder? shape,
    double? width,
    double? height,
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.longPress,
      onPressed: onPressed,
      onLongPress: onLongPress,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      borderRadius: borderRadius,
      shape: shape,
      width: width,
      height: height,
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      icon: icon,
      iconSpacing: iconSpacing,
      tapTargetSize: tapTargetSize,
      child: child,
    );
  }

  factory CustomActionButton.rounded({
    Key? key,
    VoidCallback? onPressed,
    required Widget child,
    Widget? icon,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double? width,
    double? height,
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 2.0,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.rounded,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      width: width,
      height: height,
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      splashFactory: splashFactory,
      icon: icon,
      iconSpacing: iconSpacing,
      tapTargetSize: tapTargetSize,
      child: child,
    );
  }

  factory CustomActionButton.icon({
    Key? key,
    VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    ButtonType baseType = ButtonType.elevated,
    double iconSpacing = 8.0,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double? elevation,
    double? borderRadius,
    double? width,
    double? height,
    double minHeight = 60.0,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: baseType,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      icon: icon,
      iconSpacing: iconSpacing,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      minHeight: minHeight,
      shape: shape,
      padding: padding,
      margin: margin,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      splashFactory: splashFactory,
      tapTargetSize: tapTargetSize,
      child: label,
    );
  }

  factory CustomActionButton.iconOnly({
    Key? key,
    VoidCallback? onPressed,
    required Widget icon,
    ButtonType baseType = ButtonType.elevated,
    bool disabled = false,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    double? size = 48.0,
    double? iconSize,
    EdgeInsetsGeometry? margin,
    OutlinedBorder? shape,
    double? elevation,
    InteractiveInkFeatureFactory? splashFactory,
    MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded,
  }) {
    final Widget themedIcon = IconTheme.merge(
      data: IconThemeData(color: foregroundColor, size: iconSize),
      child: icon,
    );

    return CustomActionButton(
      key: key,
      buttonType: baseType,
      onPressed: onPressed,
      disabled: disabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      width: size,
      height: size,
      minHeight: 0.0,
      padding: EdgeInsets.zero,
      margin: margin,
      shape: shape ?? const CircleBorder(),
      elevation: elevation,
      splashFactory: splashFactory,
      tapTargetSize: tapTargetSize,
      child: themedIcon,
    );
  }

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  Timer? _longPressTimer;

  bool get _isEffectivelyDisabled =>
      widget.disabled ||
      (widget.onPressed == null && widget.buttonType != ButtonType.longPress);

  OutlinedBorder _resolveShapeFor({
    required ButtonType? type,
    required BuildContext context,
  }) {
    if (widget.shape != null) return widget.shape!;
    if (type == ButtonType.rounded) {
      return const StadiumBorder();
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
    );
  }

  /// Extracts the radius correctly from specialized borders to ensure RistoDecorator
  /// draws shadows perfectly aligned with pills and circles.
  BorderRadiusGeometry? _extractBorderRadius(OutlinedBorder? shape) {
    if (shape is RoundedRectangleBorder) return shape.borderRadius;
    if (shape is StadiumBorder) return BorderRadius.circular(1000);
    if (shape is CircleBorder) return BorderRadius.circular(1000);
    return null;
  }

  ButtonStyle _transparentifyBackground(ButtonStyle style) {
    return style.copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  Color _disabledColor(Color? disabled, Color? normal, Color fallback) {
    if (disabled != null) return disabled;
    if (normal != null) return normal.lighter(0.5);
    return fallback;
  }

  Gradient? _disabledGradient(Gradient? disabled, Gradient? normal) {
    if (disabled != null) return disabled;
    if (normal == null) return null;

    List<Color> transform(List<Color> colors) =>
        colors.map((c) => c.lighter(0.5).withCustomOpacity(0.6)).toList();

    if (normal is LinearGradient) {
      return LinearGradient(
        begin: normal.begin,
        end: normal.end,
        colors: transform(normal.colors),
        stops: normal.stops,
        tileMode: normal.tileMode,
        transform: normal.transform,
      );
    } else if (normal is RadialGradient) {
      return RadialGradient(
        center: normal.center,
        radius: normal.radius,
        colors: transform(normal.colors),
        stops: normal.stops,
        tileMode: normal.tileMode,
        focal: normal.focal,
        focalRadius: normal.focalRadius,
        transform: normal.transform,
      );
    } else if (normal is SweepGradient) {
      return SweepGradient(
        center: normal.center,
        startAngle: normal.startAngle,
        endAngle: normal.endAngle,
        colors: transform(normal.colors),
        stops: normal.stops,
        tileMode: normal.tileMode,
        transform: normal.transform,
      );
    }
    return LinearGradient(colors: transform((normal as dynamic).colors));
  }

  TextStyle _effectiveTextStyle(
    BuildContext context, {
    required bool disabled,
  }) {
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
        color:
            widget.foregroundColor ??
            Theme.of(context).textTheme.labelLarge?.color ??
            Colors.white,
      );
    }
  }

  Widget _wrapChild(BuildContext context, {required bool disabled}) {
    final textStyle = _effectiveTextStyle(context, disabled: disabled);

    Widget content = widget.child;

    if (widget.icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.icon!,
          SizedBox(width: widget.iconSpacing),
          Flexible(child: widget.child),
        ],
      );
    }

    content = DefaultTextStyle(style: textStyle, child: content);

    // Seamless animated transition to the loading indicator
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: widget.isLoading
          ? (widget.loadingIndicator ??
                SizedBox(
                  key: const ValueKey('loader'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textStyle.color ?? Colors.white,
                    ),
                  ),
                ))
          : KeyedSubtree(key: const ValueKey('content'), child: content),
    );
  }

  void _handleLongPress() {
    if (widget.onLongPress != null && !widget.isLoading) {
      _longPressTimer = Timer.periodic(const Duration(milliseconds: 100), (
        timer,
      ) {
        widget.onLongPress?.call();
      });
    }
  }

  void _cancelLongPress() {
    _longPressTimer?.cancel();
  }

  Size? _getEffectiveMinimumSize() {
    if (widget.height != null) {
      return Size(widget.width ?? 0, widget.height!);
    } else if (widget.minHeight == 0) {
      return const Size(0, 0);
    } else {
      return Size(widget.width ?? 0, widget.minHeight);
    }
  }

  Color? _effectiveBorderColorDisabled(BuildContext context) {
    if (widget.disabledBorderColor != null) return widget.disabledBorderColor;
    if (widget.borderColor != null) return widget.borderColor!.lighter(0.5);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // If it's disabled, we render the greyed-out state.
    // If it's loading, we render the ACTIVE state, but absorb pointers.
    if (_isEffectivelyDisabled && !widget.isLoading) {
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
        return _buildFlatButton(context);
      case ButtonType.rounded:
        return _buildRoundedButton(context);
      default:
        return _buildElevatedButton(context);
    }
  }

  Widget _buildDisabledButton(BuildContext context) {
    final shape = _resolveShapeFor(type: widget.buttonType, context: context);
    final isMinimal = widget.buttonType == ButtonType.minimal;

    final disabledSolid = _disabledColor(
      widget.disabledBackgroundColor,
      widget.backgroundColor,
      isMinimal ? Colors.transparent : Theme.of(context).disabledColor,
    );

    final disabledGrad = _disabledGradient(
      widget.disabledBackgroundGradient,
      widget.backgroundGradient,
    );

    final style = ElevatedButton.styleFrom(
      overlayColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _disabledColor(
        widget.disabledForegroundColor,
        widget.foregroundColor,
        Theme.of(context).disabledColor,
      ),
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return RistoDecorator(
      margin: widget.margin,
      backgroundColor: disabledGrad == null ? disabledSolid : null,
      backgroundGradient: disabledGrad,
      borderColor: _effectiveBorderColorDisabled(context),
      borderWidth: widget.borderWidth,
      elevation: isMinimal ? 0 : (widget.elevation ?? 0),
      shadowColor: widget.shadowColor ?? Colors.black,
      shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _extractBorderRadius(shape),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AbsorbPointer(
          absorbing: true,
          child: ElevatedButton(
            style: _transparentifyBackground(style),
            onPressed: () {},
            child: _wrapChild(context, disabled: true),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    final theme = Theme.of(context);
    final shape = _resolveShapeFor(type: ButtonType.elevated, context: context);
    final solid = widget.backgroundColor ?? theme.primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.onPrimary,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return RistoDecorator(
      margin: widget.margin,
      backgroundColor: widget.backgroundGradient == null ? solid : null,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _extractBorderRadius(shape),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AbsorbPointer(
          absorbing: widget.isLoading,
          child: ElevatedButton(
            style: _transparentifyBackground(style),
            // Dummy function when loading so Flutter keeps it 'enabled' visually
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            child: _wrapChild(context, disabled: false),
          ),
        ),
      ),
    );
  }

  Widget _buildFlatButton(BuildContext context) {
    final theme = Theme.of(context);
    final shape = _resolveShapeFor(type: ButtonType.flat, context: context);
    final solid = widget.backgroundColor ?? theme.primaryColor;

    final style = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.onPrimary,
      overlayColor:
          widget.splashColor ?? theme.colorScheme.onSurface.withCustomOpacity(0.12),
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return RistoDecorator(
      margin: widget.margin,
      backgroundColor: widget.backgroundGradient == null ? solid : null,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      elevation: widget.elevation ?? 0.0,
      shadowColor: widget.shadowColor ?? Colors.transparent,
      shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _extractBorderRadius(shape),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AbsorbPointer(
          absorbing: widget.isLoading,
          child: TextButton(
            style: _transparentifyBackground(style),
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            child: _wrapChild(context, disabled: false),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalButton(BuildContext context) {
    final theme = Theme.of(context);
    final shape = _resolveShapeFor(type: ButtonType.minimal, context: context);
    final solid = widget.backgroundColor ?? Colors.transparent;

    final style = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.primary,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );

    return RistoDecorator(
      margin: widget.margin,
      backgroundColor: widget.backgroundGradient == null ? solid : null,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      elevation: widget.elevation ?? 0.0,
      shadowColor: widget.shadowColor ?? Colors.transparent,
      shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _extractBorderRadius(shape),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AbsorbPointer(
          absorbing: widget.isLoading,
          child: TextButton(
            style: _transparentifyBackground(style),
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            child: _wrapChild(context, disabled: false),
          ),
        ),
      ),
    );
  }

  Widget _buildLongPressButton(BuildContext context) {
    final theme = Theme.of(context);
    final shape = _resolveShapeFor(
      type: ButtonType.longPress,
      context: context,
    );
    final solid = widget.backgroundColor ?? theme.primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.onPrimary,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    ).copyWith(
      overlayColor: widget.splashColor != null
          ? WidgetStateProperty.all(widget.splashColor)
          : null,
      splashFactory: widget.splashFactory,
    );

    final btn = GestureDetector(
      onTap: widget.isLoading ? null : widget.onPressed,
      onLongPressStart: widget.isLoading ? null : (_) => _handleLongPress(),
      onLongPressEnd: widget.isLoading ? null : (_) => _cancelLongPress(),
      child: AbsorbPointer(
        absorbing: widget.isLoading,
        child: ElevatedButton(
          style: _transparentifyBackground(style),
          onPressed: widget.isLoading ? () {} : widget.onPressed,
          child: _wrapChild(context, disabled: false),
        ),
      ),
    );

    return RistoDecorator(
      margin: widget.margin,
      backgroundColor: widget.backgroundGradient == null ? solid : null,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _extractBorderRadius(shape),
      child: SizedBox(width: widget.width, height: widget.height, child: btn),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    final theme = Theme.of(context);
    final shape = _resolveShapeFor(type: ButtonType.rounded, context: context);
    final solid = widget.backgroundColor ?? theme.primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? theme.colorScheme.onPrimary,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
      tapTargetSize: widget.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    final buttonShell = RistoDecorator(
      margin: widget.margin,
      backgroundColor: widget.backgroundGradient == null ? solid : null,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AbsorbPointer(
          absorbing: widget.isLoading,
          child: ElevatedButton(
            style: _transparentifyBackground(style),
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            child: _wrapChild(context, disabled: false),
          ),
        ),
      ),
    );

    if (widget.width == null) {
      return Row(mainAxisSize: MainAxisSize.min, children: [buttonShell]);
    }
    return buttonShell;
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }
}
