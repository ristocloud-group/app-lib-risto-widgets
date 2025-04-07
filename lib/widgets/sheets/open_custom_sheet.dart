import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/custom_action_button.dart';
import '../buttons/list_tile_button.dart';

/// A class responsible for displaying customized modal bottom sheets.
///
/// The [OpenCustomSheet] class provides a flexible and reusable way to present
/// modal bottom sheets with various customization options, such as padding,
/// colors, shapes, and default action buttons. It supports both scrollable and
/// non-scrollable sheets, and includes factory constructors for common sheet
/// configurations like confirmation dialogs and scrollable content areas.
class OpenCustomSheet {
  /// Determines whether the sheet can be dismissed by tapping outside of it.
  ///
  /// Defaults to `true`.
  final bool barrierDismissible;

  /// The semantic label for the barrier.
  ///
  /// Useful for accessibility purposes. If not provided, defaults to null.
  final String? barrierLabel;

  /// The color of the modal barrier that darkens everything below the sheet.
  ///
  /// If not specified, it defaults to `Colors.black54`.
  final Color? barrierColor;

  /// Callback invoked when the sheet is closed.
  ///
  /// Receives the result passed to `Navigator.pop`.
  final Function(dynamic)? onClose;

  /// The main content of the sheet.
  ///
  /// A function that returns a widget. It can optionally receive a [ScrollController]
  /// if the sheet is scrollable.
  final Widget Function({ScrollController? scrollController}) body;

  /// Determines if the sheet is scrollable.
  ///
  /// If `true`, the sheet uses a [DraggableScrollableSheet] to allow scrolling.
  /// Defaults to `false`.
  final bool scrollable;

  /// Whether the sheet should expand to fill the available space.
  ///
  /// Defaults to `true`.
  final bool expand;

  /// The initial size of the sheet as a fraction of the screen height.
  ///
  /// Only applicable if [scrollable] is `true`. Defaults to `0.5`.
  final double initialChildSize;

  /// The minimum size the sheet can be dragged down to, as a fraction of the screen height.
  ///
  /// Only applicable if [scrollable] is `true`. Defaults to `0.25`.
  final double minChildSize;

  /// The maximum size the sheet can be dragged up to, as a fraction of the screen height.
  ///
  /// Only applicable if [scrollable] is `true`. Defaults to `1.0`.
  final double maxChildSize;

  /// The background color of the sheet.
  ///
  /// If not specified, it defaults to the theme's card color.
  final Color? backgroundColor;

  /// The color of the handle (the small bar at the top of the sheet) used for dragging.
  ///
  /// If not specified, it defaults to `CupertinoColors.inactiveGray`.
  final Color? handleColor;

  /// The shape of the sheet's border.
  ///
  /// Allows for customizing the sheet's outline and corners. If not specified,
  /// a default rounded rectangle is used.
  final ShapeBorder? sheetShape;

  /// The padding inside the sheet.
  ///
  /// Applies padding around the entire content of the sheet. If not specified,
  /// it defaults to `EdgeInsets.only(bottom: 16.0)`.
  final EdgeInsetsGeometry? sheetPadding;

  /// The background color of the first action button.
  ///
  /// Typically used for the cancellation or negative action. If not specified,
  /// it defaults to `Colors.red`.
  final Color? firstButtonColor;

  /// The background color of the second action button.
  ///
  /// Typically used for the confirmation or positive action. If not specified,
  /// it defaults to `Colors.green`.
  final Color? secondButtonColor;

  /// The text color of the first action button.
  ///
  /// If not specified, it defaults to `Colors.white`.
  final Color? firstButtonTextColor;

  /// The text color of the second action button.
  ///
  /// If not specified, it defaults to `Colors.white`.
  final Color? secondButtonTextColor;

  /// The text label for the confirmation button.
  ///
  /// If not specified, it defaults to `'Confirm'`.
  final String? confirmButtonText;

  /// The text label for the cancellation button.
  ///
  /// If not specified, it defaults to `'Close'`.
  final String? cancelButtonText;

  /// The padding around the action buttons.
  ///
  /// If not specified, it defaults to `EdgeInsets.symmetric(vertical: 10, horizontal: 8)`.
  final EdgeInsetsGeometry? padding;

  /// The spacing between the action buttons.
  ///
  /// If not specified, it defaults to `8.0`.
  final double? buttonSpacing;

  /// Determines whether to show default action buttons (Confirm and Cancel).
  ///
  /// If set to `true`, the sheet will include these buttons at the bottom.
  /// Defaults to `false`.
  final bool showDefaultButtons;

  /// Creates an instance of [OpenCustomSheet] with the specified properties.
  ///
  /// The [body] parameter is required and must not be null. Other parameters are optional
  /// and have default values if not specified.
  const OpenCustomSheet({
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.onClose,
    required this.body,
    this.scrollable = false,
    this.expand = true,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.backgroundColor,
    this.handleColor,
    this.sheetShape,
    this.sheetPadding,
    this.firstButtonColor,
    this.secondButtonColor,
    this.firstButtonTextColor,
    this.secondButtonTextColor,
    this.confirmButtonText,
    this.cancelButtonText,
    this.padding,
    this.buttonSpacing,
    this.showDefaultButtons = false, // Changed default to false
  });

  /// Factory constructor to create a confirmation sheet with default action buttons.
  ///
  /// The confirmation sheet includes Confirm and Cancel buttons at the bottom.
  ///
  /// **Example usage:**
  /// ```dart
  /// OpenCustomSheet.openConfirmSheet(
  ///   context,
  ///   body: ({scrollController}) => Text('Are you sure you want to proceed?'),
  ///   onClose: (result) {
  ///     if (result == true) {
  ///       // Handle confirmation
  ///     } else {
  ///       // Handle cancellation
  ///     }
  ///   },
  /// );
  /// ```
  factory OpenCustomSheet.openConfirmSheet(
    BuildContext context, {
    required Widget body,
    Function(dynamic)? onClose,
    Color? backgroundColor,
    Color? handleColor,
    bool barrierDismissible = true,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    String? confirmButtonText,
    String? cancelButtonText,
    EdgeInsetsGeometry? padding,
    double? buttonSpacing,
  }) {
    return OpenCustomSheet(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withCustomOpacity(0.5),
      onClose: onClose,
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      padding: padding,
      buttonSpacing: buttonSpacing,
      firstButtonColor: firstButtonColor,
      secondButtonColor: secondButtonColor,
      firstButtonTextColor: firstButtonTextColor,
      secondButtonTextColor: secondButtonTextColor,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      showDefaultButtons: true,
      // Enable default buttons for confirm sheet
      body: ({scrollController}) => body,
    );
  }

  /// Factory constructor to create a scrollable sheet without default action buttons.
  ///
  /// This is useful for displaying large amounts of content that require scrolling.
  ///
  /// **Example usage:**
  /// ```dart
  /// OpenCustomSheet.scrollableSheet(
  ///   context,
  ///   body: ({scrollController}) => ListView.builder(
  ///     controller: scrollController,
  ///     itemCount: 50,
  ///     itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  ///   ),
  /// );
  /// ```
  factory OpenCustomSheet.scrollableSheet(
    BuildContext context, {
    required Widget Function({ScrollController? scrollController}) body,
    Function(dynamic)? onClose,
    bool expand = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    Color? barrierColor,
    Color? backgroundColor,
    Color? handleColor,
    bool barrierDismissible = true,
    ShapeBorder? sheetShape,
    EdgeInsetsGeometry? sheetPadding,
  }) {
    return OpenCustomSheet(
      scrollable: true,
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      onClose: onClose,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      sheetShape: sheetShape,
      sheetPadding: sheetPadding,
      // Disable default buttons for scrollable sheet
      showDefaultButtons: false,
      body: body,
    );
  }

  /// Displays the custom sheet using [showModalBottomSheet].
  ///
  /// This method configures the sheet based on the properties provided during
  /// instantiation, such as scrollability, padding, colors, and action buttons.
  ///
  /// After the sheet is closed, the [onClose] callback is invoked with the result.
  void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final maxHeight = mediaQuery.size.height * 0.9;
        if (scrollable) {
          return DraggableScrollableSheet(
            expand: expand,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  color: backgroundColor ?? Theme.of(context).cardColor,
                ),
                padding: sheetPadding ?? const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    if (handleColor != Colors.transparent)
                      _buildHandle(handleColor),
                    Expanded(
                      child: body(scrollController: scrollController),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // For non-scrollable sheet, enable scrolling only if necessary
          return SafeArea(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                color: backgroundColor ?? Theme.of(context).cardColor,
              ),
              padding: sheetPadding ?? const EdgeInsets.only(bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (handleColor != Colors.transparent)
                    _buildHandle(handleColor),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: body(scrollController: null),
                      ),
                    ),
                  ),
                  if (showDefaultButtons)
                    _buildButtons(
                      context,
                      firstButtonColor,
                      secondButtonColor,
                      firstButtonTextColor,
                      secondButtonTextColor,
                      buttonSpacing,
                      confirmButtonText,
                      cancelButtonText,
                    ),
                ],
              ),
            ),
          );
        }
      },
    ).then((value) {
      if (onClose != null) {
        onClose!(value);
      }
    });
  }

  /// Builds the confirmation and cancellation buttons for the sheet.
  ///
  /// These buttons are displayed at the bottom of the sheet and handle user actions
  /// like confirming or cancelling an operation.
  ///
  /// - [context]: The build context.
  /// - [firstButtonColor]: The background color for the first button (e.g., Cancel).
  /// - [secondButtonColor]: The background color for the second button (e.g., Confirm).
  /// - [firstButtonTextColor]: The text color for the first button.
  /// - [secondButtonTextColor]: The text color for the second button.
  /// - [buttonSpacing]: The spacing between the buttons.
  /// - [confirmButtonText]: The label for the confirmation button.
  /// - [cancelButtonText]: The label for the cancellation button.
  ///
  /// **Example usage:**
  /// ```dart
  /// _buildButtons(
  ///   context,
  ///   Colors.red,
  ///   Colors.green,
  ///   Colors.white,
  ///   Colors.white,
  ///   10.0,
  ///   'Yes',
  ///   'No',
  /// );
  /// ```
  static Widget _buildButtons(
    BuildContext context,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    double? buttonSpacing,
    String? confirmButtonText,
    String? cancelButtonText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DoubleListTileButtons(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        space: buttonSpacing ?? 8,
        firstButton: CustomActionButton.flat(
          margin: EdgeInsets.zero,
          width: double.infinity,
          onPressed: () => Navigator.pop(context, false),
          backgroundColor: firstButtonColor ?? Colors.red,
          child: Text(
            cancelButtonText ?? 'Close',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: firstButtonTextColor ?? Colors.white,
                ),
          ),
        ),
        secondButton: CustomActionButton.flat(
          onPressed: () => Navigator.pop(context, true),
          margin: EdgeInsets.zero,
          width: double.infinity,
          backgroundColor: secondButtonColor ?? Colors.green,
          child: Text(
            confirmButtonText ?? 'Confirm',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: secondButtonTextColor ?? Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  /// Builds the drag handle for the sheet.
  ///
  /// The handle provides a visual indicator that the sheet can be dragged.
  ///
  /// - [handleColor]: The color of the handle. If not specified, it defaults to
  ///   `CupertinoColors.inactiveGray`.
  ///
  /// **Example usage:**
  /// ```dart
  /// _buildHandle(Colors.blue);
  /// ```
  static Widget _buildHandle(Color? handleColor) {
    return Center(
      child: Container(
        width: 150,
        height: 5,
        decoration: BoxDecoration(
          color: handleColor ?? CupertinoColors.inactiveGray,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}
