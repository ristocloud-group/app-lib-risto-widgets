import 'dart:async';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

/// Types of buttons available in [CustomActionButton].
enum ButtonType { elevated, flat, minimal, longPress, rounded }

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

  /// Background gradients for the button.
  ///
  /// - [backgroundGradient]: The active gradient when the button is enabled.
  ///   Overrides [backgroundColor] if provided.
  /// - [disabledBackgroundGradient]: The gradient when the button is disabled.
  ///   If null, a lighter/faded version of [backgroundGradient] is generated
  ///   automatically. If both are null, falls back to
  ///   [disabledBackgroundColor] or a lightened [backgroundColor].
  final Gradient? backgroundGradient;
  final Gradient? disabledBackgroundGradient;

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

  /// The minimum height of the button. Defaults to 60.0.
  /// If set to 0, the button will adapt to the minimum possible height
  /// required by its content.
  final double minHeight;

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
    this.minHeight = 60.0,
    this.shape,
    this.padding,
    this.margin,
    this.backgroundGradient,
    this.disabledBackgroundGradient,
    this.splashFactory,
  });

  /// Creates an elevated button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.elevated({
    Key? key,
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
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      key: key,
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
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      child: child,
    );
  }

  /// Creates a flat button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.flat({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
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
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.flat,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
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
      child: child,
    );
  }

  /// Creates a minimal button.
  ///
  /// The [onPressed] and [child] parameters are required.
  factory CustomActionButton.minimal({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    Color? borderColor,
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
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.minimal,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      width: width,
      height: height,
      minHeight: minHeight,
      shape: shape,
      padding: padding,
      margin: margin,
      disabledBackgroundGradient: disabledBackgroundGradient,
      child: child,
    );
  }

  /// Creates a long-press button.
  ///
  /// The [onPressed], [onLongPress], and [child] parameters are required.
  factory CustomActionButton.longPress({
    Key? key,
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
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      key: key,
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
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      child: child,
    );
  }

  /// Creates a fully rounded button.
  ///
  /// The [onPressed] e [child] sono obbligatori.
  factory CustomActionButton.rounded({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    double? width,
    double? height,
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double elevation = 2.0,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return CustomActionButton(
      key: key,
      buttonType: ButtonType.rounded,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      elevation: elevation,
      width: width,
      height: height,
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      splashFactory: splashFactory,
      child: child,
    );
  }

  /// Creates a button that displays only an [Icon].
  ///
  /// - [baseType] controls the style: elevated (default), flat, or minimal.
  /// - [size] sets a square dimension for width/height.
  /// - [iconColor] directly controls the icon's color, falling back to
  ///   [foregroundColor] if not provided.
  ///
  /// Example:
  /// ```dart
  /// CustomActionButton.icon(
  ///   onPressed: () {},
  ///   icon: Icons.add,
  ///   size: 48,
  ///   backgroundColor: Colors.blue,
  ///   iconColor: Colors.white,
  ///   baseType: ButtonType.rounded,
  /// );
  /// ```
  factory CustomActionButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required IconData icon,
    ButtonType baseType = ButtonType.elevated,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? iconColor,
    Color? shadowColor,
    Color? splashColor,
    Color? disabledBackgroundColor,
    Color? disabledBorderColor,
    Color? disabledForegroundColor,
    Color? borderColor,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    double? size,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 8.0,
    OutlinedBorder? shape,
    double? elevation,
    InteractiveInkFeatureFactory? splashFactory,
    double iconSize = 20.0,
  }) {
    final resolvedWidth = size;
    final resolvedHeight = size;
    final resolvedPadding = padding ?? (size != null ? EdgeInsets.zero : null);

    return CustomActionButton(
      key: key,
      buttonType: baseType,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      splashColor: splashColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledBorderColor: disabledBorderColor,
      disabledForegroundColor: disabledForegroundColor,
      borderColor: borderColor,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      width: resolvedWidth,
      height: resolvedHeight,
      minHeight: 0.0,
      padding: resolvedPadding,
      margin: margin,
      borderRadius: borderRadius,
      shape: shape,
      elevation: elevation,
      splashFactory: splashFactory,
      child: Icon(icon, size: iconSize, color: iconColor ?? foregroundColor),
    );
  }

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  Timer? _longPressTimer;

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

  Widget _decoratedShell({
    required BuildContext context,
    required OutlinedBorder shape,
    required Widget child,
    required Color? solidColor,
    required Gradient? gradient,
    required double? elevation,
    required Color? shadowColor,
    required EdgeInsetsGeometry? margin,
    required double? width,
    required double? height,
    Color? borderColor,
    double borderWidth = 1,
  }) {
    final baseShape = shape;
    final core = Material(
      shape: baseShape,
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 0,
      shadowColor: shadowColor,
      color: Colors.transparent,
      child: Ink(
        decoration: ShapeDecoration(
          shape: baseShape,
          color: gradient == null ? solidColor : null,
          gradient: gradient,
        ),
        child: child,
      ),
    );

    return Container(
      margin: margin,
      width: width,
      height: height,
      foregroundDecoration: borderColor != null
          ? ShapeDecoration(
              shape: _shapeWithSide(
                baseShape,
                BorderSide(color: borderColor, width: borderWidth),
              ),
            )
          : null,
      child: core,
    );
  }

  OutlinedBorder _shapeWithSide(OutlinedBorder shape, BorderSide side) {
    if (shape is StadiumBorder) {
      return StadiumBorder(side: side);
    } else if (shape is RoundedRectangleBorder) {
      return RoundedRectangleBorder(
        borderRadius: shape.borderRadius,
        side: side,
      );
    }
    return shape;
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
    return DefaultTextStyle(
      style: _effectiveTextStyle(context, disabled: disabled),
      child: widget.child,
    );
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
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

  Color? _effectiveBorderColorEnabled() => widget.borderColor;

  Color? _effectiveBorderColorDisabled(BuildContext context) {
    if (widget.disabledBorderColor != null) {
      return widget.disabledBorderColor;
    }
    if (widget.borderColor != null) {
      return widget.borderColor!.lighter(0.5);
    }
    return null;
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
        return _buildFlatButton(context);
      case ButtonType.rounded:
        return _buildRoundedButton(context);
      default:
        return _buildElevatedButton(context);
    }
  }

  Widget _buildDisabledButton(BuildContext context) {
    final shape = _resolveShapeFor(type: widget.buttonType, context: context);

    final disabledSolid = _disabledColor(
      widget.disabledBackgroundColor,
      widget.backgroundColor,
      widget.buttonType == ButtonType.minimal
          ? Colors.transparent
          : Theme.of(context).disabledColor,
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
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return _decoratedShell(
      context: context,
      shape: shape,
      child: AbsorbPointer(
        absorbing: true,
        child: ElevatedButton(
          style: _transparentifyBackground(style),
          onPressed: () {},
          child: _wrapChild(context, disabled: true),
        ),
      ),
      solidColor: disabledGrad == null ? disabledSolid : null,
      gradient: disabledGrad,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor ?? Colors.black,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorDisabled(context),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.elevated, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return _decoratedShell(
      context: context,
      shape: shape,
      child: ElevatedButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
      solidColor: solid,
      gradient: widget.backgroundGradient,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorEnabled(),
    );
  }

  Widget _buildFlatButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.flat, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      overlayColor: widget.splashColor ?? Colors.grey.withCustomOpacity(0.2),
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    return _decoratedShell(
      context: context,
      shape: shape,
      child: TextButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
      solidColor: solid,
      gradient: widget.backgroundGradient,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor ?? Colors.transparent,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorEnabled(),
    );
  }

  Widget _buildMinimalButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.minimal, context: context);

    final style =
        TextButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? Colors.black,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: shape,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: _getEffectiveMinimumSize(),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        );

    final solid = widget.backgroundColor ?? Colors.transparent;

    return _decoratedShell(
      context: context,
      shape: shape,
      child: TextButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
      solidColor: widget.backgroundGradient == null ? solid : null,
      gradient: widget.backgroundGradient,
      elevation: widget.elevation ?? 0,
      shadowColor: widget.shadowColor ?? Colors.transparent,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorEnabled(),
    );
  }

  Widget _buildLongPressButton(BuildContext context) {
    final shape = _resolveShapeFor(
      type: ButtonType.longPress,
      context: context,
    );
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style =
        ElevatedButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? Colors.white,
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: shape,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: _getEffectiveMinimumSize(),
        ).copyWith(
          overlayColor: widget.splashColor != null
              ? WidgetStateProperty.all(widget.splashColor)
              : null,
          splashFactory: widget.splashFactory,
        );

    final btn = GestureDetector(
      onTap: widget.onPressed,
      onLongPressStart: (_) => _handleLongPress(),
      onLongPressEnd: (_) => _cancelLongPress(),
      child: ElevatedButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
    );

    return _decoratedShell(
      context: context,
      shape: shape,
      child: btn,
      solidColor: solid,
      gradient: widget.backgroundGradient,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorEnabled(),
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.rounded, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: _getEffectiveMinimumSize(),
    );

    final buttonShell = _decoratedShell(
      context: context,
      shape: shape,
      child: ElevatedButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: false),
      ),
      solidColor: solid,
      gradient: widget.backgroundGradient,
      elevation: widget.elevation ?? 2.0,
      shadowColor: widget.shadowColor,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderColor: _effectiveBorderColorEnabled(),
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
