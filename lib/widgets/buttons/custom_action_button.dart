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
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomActionButton(
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
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
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
    double minHeight = 60.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Gradient? backgroundGradient,
    Gradient? disabledBackgroundGradient,
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
      minHeight: minHeight,
      padding: padding,
      margin: margin,
      splashFactory: splashFactory,
      backgroundGradient: backgroundGradient,
      disabledBackgroundGradient: disabledBackgroundGradient,
      child: child,
    );
  }

  /// Creates a fully rounded button (semicirconferenze sui lati).
  ///
  /// The [onPressed], [height] e [child] sono obbligatori.
  /// [height] viene usata per calcolare il raggio = height / 2.
  factory CustomActionButton.rounded({
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
    required VoidCallback? onPressed,
    required IconData icon,

    // Visual style
    ButtonType baseType = ButtonType.elevated,

    // Colors & gradients
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

    // Sizing & layout
    double? size, // square size convenience
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,

    // Shape & elevation
    double borderRadius = 8.0,
    OutlinedBorder? shape,
    double? elevation,
    InteractiveInkFeatureFactory? splashFactory,

    // Icon specifics
    double iconSize = 20.0,
  }) {
    final resolvedWidth = size;
    final resolvedHeight = size;
    final resolvedPadding = padding ?? (size != null ? EdgeInsets.zero : null);

    return CustomActionButton(
      buttonType: baseType,
      onPressed: onPressed,

      // Forward styling/customization
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

      // Layout
      width: resolvedWidth,
      height: resolvedHeight,
      minHeight: 0.0,
      // let size drive the dimensions
      padding: resolvedPadding,
      margin: margin,

      // Shape/elevation
      borderRadius: borderRadius,
      shape: shape,
      elevation: elevation,
      splashFactory: splashFactory,

      // Child is built here so the button body is the icon
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? foregroundColor,
      ),
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

  OutlinedBorder _resolveShapeFor({
    required ButtonType? type,
    required BuildContext context,
  }) {
    if (widget.shape != null) return widget.shape!;
    if (type == ButtonType.rounded) {
      return StadiumBorder(
        side: widget.borderColor != null
            ? BorderSide(color: widget.borderColor!, width: 1)
            : BorderSide.none,
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
      side: widget.borderColor != null
          ? BorderSide(color: widget.borderColor!, width: 1)
          : BorderSide.none,
    );
  }

  /// Wraps [child] with a Material that renders either a gradient or a solid color
  /// using the given [shape]. Elevation and shadows are applied here so the
  /// gradient can still cast a shadow.
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
  }) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: Material(
        shape: shape,
        clipBehavior: Clip.antiAlias,
        elevation: elevation ?? 0,
        shadowColor: shadowColor,
        child: Ink(
          decoration: ShapeDecoration(
            shape: shape,
            color: gradient == null ? solidColor : null,
            gradient: gradient,
          ),
          child: child,
        ),
      ),
    );
  }

  /// When a gradient is present we make the inner button background transparent
  /// and let the shell paint the visuals; otherwise we pass the solid color.
  ButtonStyle _transparentifyBackground(ButtonStyle style) {
    return style.copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0), // elevation handled by shell
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  /// Create a disabled version of a color if needed.
  Color _disabledColor(Color? disabled, Color? normal, Color fallback) {
    if (disabled != null) return disabled;
    if (normal != null) return _lighter(normal, 0.5);
    return fallback;
  }

  /// Returns a disabled gradient:
  /// - If [disabled] provided, use it.
  /// - Else if [normal] provided, lighten & add slight transparency to all stops,
  ///   preserving gradient type (linear/radial/sweep), begin/end/center/radius/stops/tileMode.
  /// - Else return null.
  Gradient? _disabledGradient(Gradient? disabled, Gradient? normal) {
    if (disabled != null) return disabled;
    if (normal == null) return null;

    List<Color> transform(List<Color> colors) =>
        colors.map((c) => _lighter(c, 0.5).withCustomOpacity(0.6)).toList();

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

  /// Determines the effective minimum size for the button.
  /// If [widget.height] is provided, it takes precedence.
  /// If [widget.minHeight] is 0, it returns null to allow intrinsic sizing.
  /// Otherwise, it uses [widget.minHeight].
  Size? _getEffectiveMinimumSize() {
    if (widget.height != null) {
      return Size(widget.width ?? 0, widget.height!);
    } else if (widget.minHeight == 0) {
      return null;
    } else {
      return Size(widget.width ?? 0, widget.minHeight);
    }
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

    // Solid fallback
    final disabledSolid = _disabledColor(
      widget.disabledBackgroundColor,
      widget.backgroundColor,
      widget.buttonType == ButtonType.minimal
          ? Colors.transparent
          : Theme.of(context).disabledColor,
    );

    // NEW: compute a disabled gradient if a base gradient exists
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
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
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
      // If we have a disabled gradient, paint it; else use solid fallback.
      solidColor: disabledGrad == null ? disabledSolid : null,
      gradient: disabledGrad,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor ?? Colors.black,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
    );
  }

  /// Builds the elevated button style.
  Widget _buildElevatedButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.elevated, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = ElevatedButton.styleFrom(
      // text/icon color (text is also wrapped)
      foregroundColor: widget.foregroundColor ?? Colors.white,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      overlayColor: widget.splashColor ?? Colors.transparent,
      splashFactory: widget.splashFactory,
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
    );
  }

  /// Builds the flat button style.
  Widget _buildFlatButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.flat, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      overlayColor: widget.splashColor ?? Colors.grey.withCustomOpacity(0.2),
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
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
    );
  }

  /// Builds the minimal button style.
  Widget _buildMinimalButton(BuildContext context) {
    final shape = _resolveShapeFor(type: ButtonType.minimal, context: context);

    final style = TextButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.black,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      minimumSize: _getEffectiveMinimumSize(),
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );

    // Default minimal is transparent; if a gradient is supplied, we paint it.
    final solid = widget.backgroundColor; // may be null => transparent shell

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
    );
  }

  /// Builds the long-press button style.
  Widget _buildLongPressButton(BuildContext context) {
    final shape =
        _resolveShapeFor(type: ButtonType.longPress, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
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
    );
  }

  Widget _buildRoundedButton(BuildContext context) {
    final disabled = widget.onPressed == null;
    final shape = _resolveShapeFor(type: ButtonType.rounded, context: context);
    final solid = widget.backgroundColor ?? Theme.of(context).primaryColor;

    final style = ElevatedButton.styleFrom(
      foregroundColor: widget.foregroundColor ?? Colors.white,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: shape,
      minimumSize: _getEffectiveMinimumSize(),
    ).copyWith(
      overlayColor: widget.splashColor != null
          ? WidgetStateProperty.all(widget.splashColor)
          : null,
      splashFactory: widget.splashFactory,
    );

    return _decoratedShell(
      context: context,
      shape: shape,
      child: ElevatedButton(
        style: _transparentifyBackground(style),
        onPressed: widget.onPressed,
        child: _wrapChild(context, disabled: disabled),
      ),
      solidColor: disabled
          ? _disabledColor(widget.disabledBackgroundColor, solid,
              Theme.of(context).disabledColor)
          : solid,
      gradient: disabled ? null : widget.backgroundGradient,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
    );
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }
}
