import 'dart:async';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extentions.dart';

import '../buttons/custom_action_button.dart';

/// A type definition for a callback function that updates the quantity value.
///
/// The [ValueUpdate] function takes an integer parameter [updateValue] representing
/// the new quantity and returns a dynamic value. This allows flexibility in handling
/// the updated value, whether it's immediately applied or processed asynchronously.
typedef ValueUpdate = dynamic Function(int updateValue);

/// A widget that provides increment and decrement functionality with customizable
/// buttons and display. It allows users to increase or decrease a numerical
/// value within optional bounds, making it suitable for quantity selectors in
/// shopping carts, forms, and other interactive UI components.
///
/// The [IncrementDecrementWidget] offers multiple factory constructors to cater
/// to different design requirements, such as flat, raised, minimal, and squared
/// styles. It also supports long-press actions for continuous incrementing or
/// decrementing.
class IncrementDecrementWidget extends StatefulWidget {
  // Quantity properties

  /// The initial quantity to display.
  ///
  /// Must be a non-negative integer. Represents the current value of the widget.
  final int quantity;

  /// The maximum allowed quantity.
  ///
  /// If provided, the quantity cannot exceed this value. If `null`, there is no upper bound.
  final int? maxQuantity;

  /// The minimum allowed quantity.
  ///
  /// If provided, the quantity cannot go below this value. If `null`, there is no lower bound.
  final int? minValue;

  // Callback functions

  /// A callback function that is invoked whenever the quantity changes.
  ///
  /// It receives the updated quantity as an integer. This callback can return
  /// a new integer value to override the incremented or decremented value.
  /// It supports both synchronous and asynchronous operations.
  final ValueUpdate? onChanged;

  // Customization properties

  /// The background color of the widget.
  ///
  /// Applies to the area surrounding the buttons and the quantity display.
  final Color? backgroundColor;

  /// The color of the widget's icons.
  ///
  /// Applies to both increment and decrement icons. If not specified, defaults to the theme's icon color.
  final Color? iconColor;

  /// The elevation (shadow depth) of the widget.
  ///
  /// A higher value increases the shadow's prominence. Defaults vary based on the factory constructor used.
  final double? elevation;

  /// The external margin around the widget.
  ///
  /// Adds space outside the widget's boundaries.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the quantity display.
  ///
  /// Controls the space between the quantity text and its container.
  final EdgeInsetsGeometry? valuePadding;

  /// The text style for displaying the quantity.
  ///
  /// If not provided, defaults to the theme's `titleLarge` text style.
  final TextStyle? quantityTextStyle;

  /// The border radius of the widget's buttons.
  ///
  /// Controls the roundness of the buttons' corners. Defaults vary based on the factory constructor used.
  final double? borderRadius;

  /// The width of the entire widget.
  ///
  /// If not specified, the widget adapts to its parent constraints.
  final double? width;

  /// The height of the entire widget.
  ///
  /// If not specified, the widget adapts to its content.
  final double? height;

  /// The padding inside the increment and decrement buttons.
  ///
  /// Controls the space between the button's icon and its boundaries.
  final EdgeInsetsGeometry? buttonPadding;

  /// The external margin around each increment and decrement button.
  ///
  /// Adds space outside the buttons' boundaries.
  final EdgeInsetsGeometry? buttonMargin;

  /// The width of the increment and decrement buttons.
  ///
  /// If not specified, buttons adapt to their content.
  final double? buttonWidth;

  /// The height of the increment and decrement buttons.
  ///
  /// If not specified, buttons adapt to their content.
  final double? buttonHeight;

  // CustomActionButton parameters

  /// The splash color of the buttons when tapped.
  ///
  /// Defines the color of the ripple effect upon interaction.
  final Color? splashColor;

  /// The border color of the buttons.
  ///
  /// If specified, buttons will have a border with this color.
  final Color? borderColor;

  /// The splash factory to define interaction effects.
  ///
  /// Allows customization of the splash effect (e.g., ripple type).
  final InteractiveInkFeatureFactory? splashFactory;

  // Factory-specific properties

  /// The icon widget for the increment button.
  ///
  /// If not provided, defaults to a plus icon.
  final Widget? incrementIcon;

  /// The icon widget for the decrement button.
  ///
  /// If not provided, defaults to a minus icon.
  final Widget? decrementIcon;

  // Button shape

  /// The shape of the increment and decrement buttons.
  ///
  /// Allows for customizing the buttons' outline and borders.
  final OutlinedBorder? buttonShape;

  // Long-press settings

  /// The interval between repeated increment/decrement actions during a long press.
  ///
  /// Determines how quickly the quantity changes when the button is held down.
  final Duration longPressInterval;

  // Alignment

  /// The alignment of the buttons and quantity display within the widget.
  ///
  /// Controls how the child widgets are placed along the main axis (horizontal).
  final MainAxisAlignment? alignment;

  /// Creates an [IncrementDecrementWidget] with the specified properties.
  ///
  /// The [quantity] parameter is required and sets the initial value.
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
    this.splashColor,
    this.borderColor,
    this.splashFactory,
    this.incrementIcon,
    this.decrementIcon,
    this.buttonShape,
    this.longPressInterval = const Duration(milliseconds: 100),
    this.alignment,
  });

  /// Factory constructor for a flat design.
  ///
  /// The flat design has no elevation and transparent background by default.
  ///
  /// Example usage:
  /// ```dart
  /// IncrementDecrementWidget.flat(
  ///   quantity: 1,
  ///   maxQuantity: 10,
  ///   onChanged: (newValue) {
  ///     // Handle value change
  ///   },
  /// );
  /// ```
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
      splashFactory: splashFactory,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment,
    );
  }

  /// Factory constructor for a raised design.
  ///
  /// The raised design has elevation and an optional background color.
  ///
  /// Example usage:
  /// ```dart
  /// IncrementDecrementWidget.raised(
  ///   quantity: 2,
  ///   maxQuantity: 5,
  ///   onChanged: (newValue) {
  ///     // Handle value change
  ///   },
  /// );
  /// ```
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
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      longPressInterval: longPressInterval,
      alignment: alignment,
    );
  }

  /// Factory constructor for a minimalistic design.
  ///
  /// The minimal design has no elevation and transparent background by default,
  /// focusing on simplicity and compactness.
  ///
  /// Example usage:
  /// ```dart
  /// IncrementDecrementWidget.minimal(
  ///   quantity: 3,
  ///   minValue: 1,
  ///   onChanged: (newValue) {
  ///     // Handle value change
  ///   },
  /// );
  /// ```
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

  /// Factory constructor for squared buttons with equal width and height
  /// and customizable border radius.
  ///
  /// The squared design ensures that the increment and decrement buttons are
  /// square-shaped, with equal width and height, suitable for compact layouts.
  ///
  /// Example usage:
  /// ```dart
  /// IncrementDecrementWidget.squared(
  ///   quantity: 4,
  ///   maxQuantity: 8,
  ///   onChanged: (newValue) {
  ///     // Handle value change
  ///   },
  /// );
  /// ```
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
    double? borderRadius, // Allow specifying border radius
    Color? borderColor,
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
      buttonPadding: buttonPadding,
      quantityTextStyle: quantityTextStyle,
      width: width,
      height: height,
      buttonWidth: size,
      buttonHeight: size,
      borderColor: borderColor,
      borderRadius: effectiveBorderRadius,
      // Set the border radius
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

  @override
  State<IncrementDecrementWidget> createState() =>
      _IncrementDecrementWidgetState();
}

class _IncrementDecrementWidgetState extends State<IncrementDecrementWidget> {
  /// The current quantity value displayed by the widget.
  ///
  /// Initialized with the [widget.quantity] value.
  late int _currentQuantity;

  /// Initializes the state and sets the initial quantity.
  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
  }

  /// Increments the quantity by one, respecting the [maxQuantity] if set.
  ///
  /// Invokes the [onChanged] callback with the updated value, allowing for
  /// custom handling or validation. Updates the UI with the new quantity.
  Future<void> _increment() async {
    if (widget.maxQuantity == null || _currentQuantity < widget.maxQuantity!) {
      int updatedQuantity = _currentQuantity + 1;
      int newQuantity = updatedQuantity;

      if (widget.onChanged != null) {
        var result = widget.onChanged!(updatedQuantity);

        if (result is Future<int?>) {
          newQuantity = await result ?? updatedQuantity;
        } else if (result is int?) {
          newQuantity = result ?? updatedQuantity;
        }
        // If result is void (null), use updatedQuantity
      }

      setState(() {
        _currentQuantity = newQuantity;
      });
    }
  }

  /// Decrements the quantity by one, respecting the [minValue] if set.
  ///
  /// Invokes the [onChanged] callback with the updated value, allowing for
  /// custom handling or validation. Updates the UI with the new quantity.
  Future<void> _decrement() async {
    if (widget.minValue == null || _currentQuantity > widget.minValue!) {
      int updatedQuantity = _currentQuantity - 1;
      int newQuantity = updatedQuantity;

      if (widget.onChanged != null) {
        var result = widget.onChanged!(updatedQuantity);

        if (result is Future<int?>) {
          newQuantity = await result ?? updatedQuantity;
        } else if (result is int?) {
          newQuantity = result ?? updatedQuantity;
        }
        // If result is void (null), use updatedQuantity
      }

      setState(() {
        _currentQuantity = newQuantity;
      });
    }
  }

  /// Builds the increment and decrement buttons along with the quantity display.
  ///
  /// Utilizes [CustomActionButton.longPress] to handle both tap and long-press
  /// interactions for continuous incrementing or decrementing.
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

    return SizedBox(
      width: effectiveWidth,
      child: Row(
        mainAxisAlignment: effectiveAlignment,
        children: <Widget>[
          _buildActionButton(
            context,
            widget.decrementIcon ?? const Icon(Icons.remove),
            onPressed:
                (widget.minValue == null || _currentQuantity > widget.minValue!)
                    ? _decrement
                    : null,
            isEnabled:
                widget.minValue == null || _currentQuantity > widget.minValue!,
            onLongPress: _decrement,
            effectiveBackgroundColor: effectiveBackgroundColor,
            effectiveMargin: buttonMargin,
            effectiveWidth: widget.buttonWidth,
            effectiveHeight: widget.buttonHeight,
          ),
          _buildQuantityDisplay(context, valuePadding),
          _buildActionButton(
            context,
            widget.incrementIcon ?? const Icon(Icons.add),
            onPressed: (widget.maxQuantity == null ||
                    _currentQuantity < widget.maxQuantity!)
                ? _increment
                : null,
            isEnabled: widget.maxQuantity == null ||
                _currentQuantity < widget.maxQuantity!,
            onLongPress: _increment,
            effectiveBackgroundColor: effectiveBackgroundColor,
            effectiveMargin: buttonMargin,
            effectiveWidth: widget.buttonWidth,
            effectiveHeight: widget.buttonHeight,
          ),
        ],
      ),
    );
  }

  /// Builds an individual action button (increment or decrement).
  ///
  /// Configures the button's appearance and behavior based on its enabled state.
  ///
  /// - [icon]: The icon to display on the button.
  /// - [onPressed]: The callback to invoke when the button is tapped.
  /// - [isEnabled]: Determines if the button is active.
  /// - [onLongPress]: The callback to invoke on a long press.
  /// - [effectiveBackgroundColor]: The background color of the button.
  /// - [effectiveMargin]: The external margin around the button.
  /// - [effectiveWidth]: The width of the button.
  /// - [effectiveHeight]: The height of the button.
  Widget _buildActionButton(
    BuildContext context,
    Widget icon, {
    required VoidCallback? onPressed,
    required bool isEnabled,
    required VoidCallback onLongPress,
    required Color effectiveBackgroundColor,
    required EdgeInsetsGeometry effectiveMargin,
    double? effectiveWidth,
    double? effectiveHeight,
  }) {
    final Color effectiveIconColor =
        _iconColor(context, isEnabled) ?? Theme.of(context).iconTheme.color!;

    // **KEY MODIFICATION:**
    // When the button is disabled, set onLongPress to null to prevent the timer from running.
    final VoidCallback? effectiveOnLongPress = isEnabled ? onLongPress : null;

    Widget button = CustomActionButton.longPress(
      margin: effectiveMargin,
      width: effectiveWidth,
      height: effectiveHeight,
      backgroundColor: effectiveBackgroundColor,
      shape: widget.buttonShape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
          ),
      elevation: widget.elevation ?? 0,
      padding: widget.buttonPadding,
      onPressed: onPressed,
      onLongPress: effectiveOnLongPress,
      // Pass null if disabled
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

  /// Builds the quantity display widget.
  ///
  /// Displays the current quantity in the center between the increment and decrement buttons.
  ///
  /// - [context]: The build context.
  /// - [padding]: The padding around the quantity text.
  Widget _buildQuantityDisplay(
    BuildContext context,
    EdgeInsetsGeometry padding,
  ) {
    return Expanded(
      flex: 0,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        child: Text(
          _currentQuantity.toString(),
          style: widget.quantityTextStyle ??
              Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  /// Determines the icon color based on the button's enabled state.
  ///
  /// - [context]: The build context.
  /// - [isEnabled]: Whether the button is active.
  ///
  /// Returns a color with reduced opacity if the button is disabled.
  Color? _iconColor(BuildContext context, bool isEnabled) {
    final Color defaultColor =
        widget.iconColor ?? Theme.of(context).iconTheme.color!;
    return isEnabled ? defaultColor : defaultColor.withCustomOpacity(0.2);
  }
}
