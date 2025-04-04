import 'package:flutter/material.dart';

import 'custom_action_button.dart';

/// A customizable button that ensures the [onPressed] callback is invoked
/// only once per press. It prevents multiple invocations during a single press,
/// making it ideal for handling actions that shouldn't be executed multiple times
/// concurrently, such as network requests.
///
/// The [SinglePressButton] provides options to display a loading indicator,
/// customize its appearance, and handle processing states with callbacks.
///
/// Example usage:
/// ```dart
/// SinglePressButton(
///   onPressed: () async {
///     await performNetworkRequest();
///   },
///   child: Text('Submit'),
///   showLoadingIndicator: true,
///   backgroundColor: Colors.blue,
///   disabledColor: Colors.blueAccent,
///   foregroundColor: Colors.white, // Sets the text color
///   borderColor: Colors.red,
///   disableTextColor: Colors.grey,
///   borderRadius: 12.0,
///   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
///   width: 200,
///   height: 50,
///   onStartProcessing: () {
///     // Optional: Actions to perform when processing starts.
///   },
///   onFinishProcessing: () {
///     // Optional: Actions to perform when processing finishes.
///   },
///   onError: (error) {
///     // Optional: Handle errors during processing.
///   },
/// );
/// ```
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

  /// The background color of the button when disabled.
  ///
  /// This color is displayed when the button is in a processing state.
  /// If not specified, it defaults to the theme's disabled color.
  final Color? disabledBackgroundColor;

  /// The border radius of the button.
  ///
  /// Controls the roundness of the button's corners.
  /// Defaults to 8.0.
  final double borderRadius;

  /// The foreground color (text/icon color) of the button.
  ///
  /// If not specified, the button's text color will be derived from the theme.
  final Color? foregroundColor;

  /// The text style for the button's label.
  ///
  /// If not specified, it inherits the theme's text style.
  final TextStyle? textStyle;

  /// The elevation of the button.
  ///
  /// Controls the shadow depth of the button.
  /// If not specified, it defaults to the theme's elevated button elevation.
  final double? elevation;

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

  /// The border color of the button.
  ///
  /// If provided, it overrides the default border color for the button.
  final Color? borderColor;

  /// The text color of the button when it is disabled.
  ///
  /// This color is displayed when the button is not interactive, for example,
  /// when [onPressed] is null.
  final Color? disabledForegroundColor;

  /// The border color of the button when it is disabled.
  ///
  /// This color is displayed when the button is not interactive, for example,
  /// when [onPressed] is null.
  final Color? disabledBorderColor;

  /// Creates a [SinglePressButton].
  ///
  /// The [child] parameter is required.
  /// The [borderRadius] defaults to 8.0, and [showLoadingIndicator] defaults to `false`.
  const SinglePressButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.disabledBorderColor,
    this.borderRadius = 8.0,
    this.textStyle,
    this.elevation,
    this.shape,
    this.showLoadingIndicator = false,
    this.loadingIndicatorColor,
    this.width,
    this.height,
    this.onStartProcessing,
    this.onFinishProcessing,
    this.onError,
  });

  @override
  State<SinglePressButton> createState() => _SinglePressButtonState();
}

class _SinglePressButtonState extends State<SinglePressButton> {
  /// Indicates whether the button is currently processing an action.
  ///
  /// When `true`, the button is disabled, and a loading indicator is shown if enabled.
  bool _isProcessing = false;

  /// Handles the button press by invoking [widget.onPressed].
  ///
  /// Ensures that the callback is invoked only once per press.
  /// Manages the processing state and handles optional callbacks for processing events.
  Future<void> _handlePress() async {
    if (_isProcessing || widget.onPressed == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Invoke onStartProcessing callback if provided.
    widget.onStartProcessing?.call();

    try {
      await widget.onPressed!();
    } catch (error) {
      if (widget.onError != null) {
        widget.onError!(error);
      } else {
        rethrow;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        widget.onFinishProcessing?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = _isProcessing || widget.onPressed == null;

    return Container(
      margin: widget.margin,
      child: CustomActionButton(
        onPressed: isDisabled ? null : _handlePress,
        padding: widget.padding,
        backgroundColor: widget.backgroundColor,
        disabledBackgroundColor: widget.disabledBackgroundColor,
        foregroundColor: widget.foregroundColor,
        disabledForegroundColor: widget.disabledForegroundColor,
        borderColor: widget.borderColor,
        disabledBorderColor: widget.disabledBorderColor,
        borderRadius: widget.borderRadius,
        elevation: widget.elevation,
        shape: widget.shape,
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.child,
            if (_isProcessing && widget.showLoadingIndicator)
              // Use Positioned.fill so that the loader is constrained to the original button size.
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
        ),
      ),
    );
  }
}
