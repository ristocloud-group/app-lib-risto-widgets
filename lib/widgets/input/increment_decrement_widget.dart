import 'dart:async';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/custom_action_button.dart';

/// A type definition for a callback function that updates the quantity value.
typedef ValueUpdate = dynamic Function(int updateValue);

/// A widget that provides increment and decrement functionality with customizable
/// buttons and display. It allows users to increase or decrease a numerical
/// value within optional bounds, making it suitable for quantity selectors in
/// shopping carts, forms, and other interactive UI components.
class IncrementDecrementWidget extends StatefulWidget {
  // Quantity properties
  final int quantity;
  final int? maxQuantity;
  final int? minValue;
  final ValueUpdate? onChanged;

  // Customization properties
  final Color? backgroundColor;
  final Color? iconColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? valuePadding;
  final TextStyle? quantityTextStyle;
  final double? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? buttonPadding;
  final EdgeInsetsGeometry? buttonMargin;
  final double? buttonWidth;
  final double? buttonHeight;

  // Specific Shapes & Middle Value Display bounds
  /// Custom shape for the left (decrement) button. Overrides [buttonShape].
  final OutlinedBorder? leftButtonShape;

  /// Custom shape for the right (increment) button. Overrides [buttonShape].
  final OutlinedBorder? rightButtonShape;

  /// Decoration for the container wrapping the quantity value.
  final BoxDecoration? valueDecoration;

  /// Fixed width for the middle quantity value section.
  final double? valueWidth;

  /// Fixed height for the middle quantity value section.
  final double? valueHeight;

  /// Optional builder to inject a custom widget (like a TextField) for the value display.
  /// The `updateValue` callback allows the custom widget to push manual updates
  /// (which will be automatically clamped to min/max bounds by the widget).
  /// If `null` is passed (e.g., empty field), it defaults to `minValue` or 0.
  final Widget Function(
    BuildContext context,
    int value,
    void Function(int?) updateValue,
  )?
  valueBuilder;

  // CustomActionButton parameters
  final Color? splashColor;
  final Color? borderColor;
  final double borderWidth;
  final InteractiveInkFeatureFactory? splashFactory;

  // Factory-specific properties
  final Widget? incrementIcon;
  final Widget? decrementIcon;
  final OutlinedBorder? buttonShape;
  final Duration longPressInterval;
  final MainAxisAlignment? alignment;

  const IncrementDecrementWidget({
    super.key,
    required this.quantity,
    this.maxQuantity,
    this.minValue,
    this.onChanged,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
    this.margin,
    this.valuePadding,
    this.quantityTextStyle,
    this.borderRadius,
    this.width,
    this.height,
    this.buttonPadding,
    this.buttonMargin,
    this.buttonWidth,
    this.buttonHeight,
    this.leftButtonShape,
    this.rightButtonShape,
    this.valueDecoration,
    this.valueWidth,
    this.valueHeight,
    this.valueBuilder,
    this.splashColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.splashFactory,
    this.incrementIcon,
    this.decrementIcon,
    this.buttonShape,
    this.longPressInterval = const Duration(milliseconds: 100),
    this.alignment,
  });

  /// Factory constructor for a flat design.
  factory IncrementDecrementWidget.flat({
    required int quantity,
    int? maxQuantity,
    int? minValue,
    ValueUpdate? onChanged,
    Color? backgroundColor,
    Color? iconColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? valuePadding,
    EdgeInsetsGeometry? buttonMargin,
    EdgeInsetsGeometry? buttonPadding,
    TextStyle? quantityTextStyle,
    double? borderRadius,
    double? width,
    double? height,
    double? buttonWidth,
    double? buttonHeight,
    Color? splashColor,
    Color? borderColor,
    double borderWidth = 1.0,
    InteractiveInkFeatureFactory? splashFactory,
    Widget? incrementIcon,
    Widget? decrementIcon,
    Duration longPressInterval = const Duration(milliseconds: 100),
    MainAxisAlignment? alignment,
  }) {
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: maxQuantity,
      minValue: minValue,
      onChanged: onChanged,
      backgroundColor: backgroundColor ?? Colors.transparent,
      iconColor: iconColor,
      elevation: 0.0,
      margin: margin,
      valuePadding: valuePadding,
      buttonMargin: buttonMargin,
      buttonPadding: buttonPadding,
      quantityTextStyle: quantityTextStyle,
      borderRadius: borderRadius ?? 10.0,
      width: width,
      height: height,
      buttonWidth: buttonWidth,
      buttonHeight: buttonHeight,
      splashColor: splashColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      splashFactory: splashFactory,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment,
    );
  }

  /// Factory constructor for a raised design.
  factory IncrementDecrementWidget.raised({
    required int quantity,
    int? maxQuantity,
    int? minValue,
    ValueUpdate? onChanged,
    Color? backgroundColor,
    Color? iconColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? valuePadding,
    EdgeInsetsGeometry? buttonMargin,
    EdgeInsetsGeometry? buttonPadding,
    TextStyle? quantityTextStyle,
    double? borderRadius,
    double? width,
    double? height,
    double? buttonWidth,
    double? buttonHeight,
    Color? borderColor,
    double borderWidth = 1.0,
    Widget? incrementIcon,
    Widget? decrementIcon,
    Duration longPressInterval = const Duration(milliseconds: 100),
    MainAxisAlignment? alignment,
  }) {
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: maxQuantity,
      minValue: minValue,
      onChanged: onChanged,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      elevation: elevation ?? 6.0,
      margin: margin,
      valuePadding: valuePadding,
      buttonMargin: buttonMargin,
      buttonPadding: buttonPadding,
      quantityTextStyle: quantityTextStyle,
      borderRadius: borderRadius ?? 10.0,
      width: width,
      height: height,
      buttonWidth: buttonWidth,
      buttonHeight: buttonHeight,
      borderColor: borderColor,
      borderWidth: borderWidth,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment,
    );
  }

  /// Factory constructor for a minimalistic design.
  factory IncrementDecrementWidget.minimal({
    required int quantity,
    int? maxQuantity,
    int? minValue,
    ValueUpdate? onChanged,
    Color? iconColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? valuePadding,
    EdgeInsetsGeometry? buttonMargin,
    EdgeInsetsGeometry? buttonPadding,
    TextStyle? quantityTextStyle,
    double? width,
    double? height,
    double? buttonWidth,
    double? buttonHeight,
    Widget? incrementIcon,
    Widget? decrementIcon,
    Duration longPressInterval = const Duration(milliseconds: 100),
    MainAxisAlignment? alignment,
  }) {
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: maxQuantity,
      minValue: minValue,
      onChanged: onChanged,
      backgroundColor: Colors.transparent,
      iconColor: iconColor,
      elevation: 0.0,
      margin: margin,
      valuePadding: valuePadding,
      buttonMargin: buttonMargin,
      buttonPadding: buttonPadding,
      quantityTextStyle: quantityTextStyle,
      width: width,
      height: height,
      buttonWidth: buttonWidth,
      buttonHeight: buttonHeight,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment,
    );
  }

  /// Factory constructor for squared buttons with equal width and height.
  factory IncrementDecrementWidget.squared({
    required int quantity,
    int? maxQuantity,
    int? minValue,
    ValueUpdate? onChanged,
    Color? backgroundColor,
    Color? iconColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? valuePadding,
    EdgeInsetsGeometry? buttonMargin,
    EdgeInsetsGeometry? buttonPadding,
    TextStyle? quantityTextStyle,
    double? width,
    double? height,
    double? buttonSize,
    double? borderRadius,
    Color? borderColor,
    double borderWidth = 1.0,
    Widget? incrementIcon,
    Widget? decrementIcon,
    Duration longPressInterval = const Duration(milliseconds: 100),
    MainAxisAlignment? alignment,
  }) {
    final double size = buttonSize ?? 50.0;
    final double effectiveBorderRadius = borderRadius ?? 10.0;
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: maxQuantity,
      minValue: minValue,
      onChanged: onChanged,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      elevation: elevation ?? 0.0,
      margin: margin,
      valuePadding: valuePadding,
      buttonMargin: buttonMargin,
      buttonPadding: buttonPadding ?? EdgeInsets.zero,
      quantityTextStyle: quantityTextStyle,
      width: width,
      height: height,
      buttonWidth: size,
      buttonHeight: size,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: effectiveBorderRadius,
      splashColor: Colors.grey.withCustomOpacity(0.2),
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      buttonShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      longPressInterval: longPressInterval,
      alignment: alignment ?? MainAxisAlignment.center,
    );
  }

  /// Factory constructor for a perfectly connected "pill" layout.
  factory IncrementDecrementWidget.connected({
    required int quantity,
    int? maxQuantity,
    int? minValue,
    ValueUpdate? onChanged,
    Color? buttonsBackgroundColor,
    Color? iconColor,
    Color? middleBackgroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 7.0,
    double buttonSize = 50.0,
    double? valueWidth = 60.0,
    EdgeInsetsGeometry? valuePadding,
    TextStyle? quantityTextStyle,
    Widget Function(
      BuildContext context,
      int value,
      void Function(int?) updateValue,
    )?
    valueBuilder,
    Widget? incrementIcon,
    Widget? decrementIcon,
    Duration longPressInterval = const Duration(milliseconds: 100),
    MainAxisAlignment? alignment,
  }) {
    final borderStyle = BorderSide(
      color: borderColor ?? buttonsBackgroundColor ?? Colors.grey,
      width: borderWidth,
    );

    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: maxQuantity,
      minValue: minValue,
      onChanged: onChanged,
      backgroundColor: buttonsBackgroundColor,
      iconColor: iconColor,
      elevation: 0.0,
      margin: EdgeInsets.zero,
      buttonMargin: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      valuePadding: valuePadding ?? EdgeInsets.zero,
      quantityTextStyle: quantityTextStyle,
      buttonWidth: buttonSize,
      buttonHeight: buttonSize,
      valueWidth: valueWidth,
      valueHeight: buttonSize,
      valueBuilder: valueBuilder,
      valueDecoration: BoxDecoration(
        color: middleBackgroundColor ?? Colors.transparent,
        border: Border.symmetric(horizontal: borderStyle),
      ),
      leftButtonShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(borderRadius),
        ),
        side: BorderSide.none,
      ),
      rightButtonShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(borderRadius),
        ),
        side: BorderSide.none,
      ),
      splashColor: Colors.black12,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment ?? MainAxisAlignment.center,
    );
  }

  @override
  State<IncrementDecrementWidget> createState() =>
      _IncrementDecrementWidgetState();
}

class _IncrementDecrementWidgetState extends State<IncrementDecrementWidget> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
  }

  @override
  void didUpdateWidget(IncrementDecrementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quantity != oldWidget.quantity) {
      _currentQuantity = widget.quantity;
    }
  }

  Future<void> _updateFromExternal(int? val) async {
    // Fallback to minValue (or 0) if the value is null (e.g., empty field)
    int clamped = val ?? widget.minValue ?? 0;

    if (widget.minValue != null && clamped < widget.minValue!) {
      clamped = widget.minValue!;
    }
    if (widget.maxQuantity != null && clamped > widget.maxQuantity!) {
      clamped = widget.maxQuantity!;
    }

    int newQuantity = clamped;
    if (widget.onChanged != null) {
      var result = widget.onChanged!(clamped);
      if (result is Future<int?>) {
        newQuantity = await result ?? clamped;
      } else if (result is int?) {
        newQuantity = result ?? clamped;
      }
    }

    if (mounted && _currentQuantity != newQuantity) {
      setState(() {
        _currentQuantity = newQuantity;
      });
    }
  }

  Future<void> _increment() async {
    if (widget.maxQuantity == null || _currentQuantity < widget.maxQuantity!) {
      await _updateFromExternal(_currentQuantity + 1);
    }
  }

  Future<void> _decrement() async {
    if (widget.minValue == null || _currentQuantity > widget.minValue!) {
      await _updateFromExternal(_currentQuantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        widget.backgroundColor ?? Theme.of(context).cardColor;
    final EdgeInsetsGeometry valuePadding =
        widget.valuePadding ?? const EdgeInsets.symmetric(horizontal: 10);
    final EdgeInsetsGeometry buttonMargin =
        widget.buttonMargin ?? EdgeInsets.zero;
    final double? effectiveWidth = widget.width;
    final MainAxisAlignment effectiveAlignment =
        widget.alignment ?? MainAxisAlignment.spaceBetween;

    return TapRegion(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SizedBox(
        width: effectiveWidth,
        child: Row(
          mainAxisAlignment: effectiveAlignment,
          children: <Widget>[
            _buildActionButton(
              context,
              widget.decrementIcon ?? const Icon(Icons.remove),
              onPressed:
                  (widget.minValue == null ||
                      _currentQuantity > widget.minValue!)
                  ? _decrement
                  : null,
              isEnabled:
                  widget.minValue == null ||
                  _currentQuantity > widget.minValue!,
              onLongPress: _decrement,
              effectiveBackgroundColor: effectiveBackgroundColor,
              effectiveMargin: buttonMargin,
              effectiveWidth: widget.buttonWidth,
              effectiveHeight: widget.buttonHeight,
              specificShape: widget.leftButtonShape,
            ),
            _buildQuantityDisplay(context, valuePadding),
            _buildActionButton(
              context,
              widget.incrementIcon ?? const Icon(Icons.add),
              onPressed:
                  (widget.maxQuantity == null ||
                      _currentQuantity < widget.maxQuantity!)
                  ? _increment
                  : null,
              isEnabled:
                  widget.maxQuantity == null ||
                  _currentQuantity < widget.maxQuantity!,
              onLongPress: _increment,
              effectiveBackgroundColor: effectiveBackgroundColor,
              effectiveMargin: buttonMargin,
              effectiveWidth: widget.buttonWidth,
              effectiveHeight: widget.buttonHeight,
              specificShape: widget.rightButtonShape,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    Widget icon, {
    required VoidCallback? onPressed,
    required bool isEnabled,
    required VoidCallback onLongPress,
    required Color effectiveBackgroundColor,
    required EdgeInsetsGeometry effectiveMargin,
    OutlinedBorder? specificShape,
    double? effectiveWidth,
    double? effectiveHeight,
  }) {
    final Color effectiveIconColor =
        _iconColor(context, isEnabled) ?? Theme.of(context).iconTheme.color!;

    final VoidCallback? effectiveOnLongPress = isEnabled ? onLongPress : null;

    Widget button = CustomActionButton.longPress(
      margin: effectiveMargin,
      width: effectiveWidth,
      height: effectiveHeight,
      minHeight: 0,
      backgroundColor: effectiveBackgroundColor,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      shape:
          specificShape ??
          widget.buttonShape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
          ),
      elevation: widget.elevation ?? 0,
      padding: widget.buttonPadding,
      onPressed: onPressed,
      onLongPress: effectiveOnLongPress,
      splashColor: widget.splashColor,
      splashFactory: widget.splashFactory,
      child: IconTheme(
        data: IconThemeData(color: effectiveIconColor),
        child: icon,
      ),
    );

    if (effectiveWidth == null || effectiveHeight == null) {
      return Expanded(child: button);
    } else {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: button,
      );
    }
  }

  Widget _buildQuantityDisplay(
    BuildContext context,
    EdgeInsetsGeometry padding,
  ) {
    Widget content = widget.valueBuilder != null
        ? widget.valueBuilder!(context, _currentQuantity, _updateFromExternal)
        : Text(
            _currentQuantity.toString(),
            style:
                widget.quantityTextStyle ??
                Theme.of(context).textTheme.titleLarge,
          );

    if (widget.valueDecoration != null ||
        widget.valueWidth != null ||
        widget.valueHeight != null) {
      return Container(
        width: widget.valueWidth,
        height: widget.valueHeight,
        padding: padding,
        decoration: widget.valueDecoration,
        alignment: Alignment.center,
        child: content,
      );
    } else {
      return Padding(padding: padding, child: content);
    }
  }

  Color? _iconColor(BuildContext context, bool isEnabled) {
    final Color defaultColor =
        widget.iconColor ?? Theme.of(context).iconTheme.color!;
    return isEnabled ? defaultColor : defaultColor.withCustomOpacity(0.2);
  }
}
