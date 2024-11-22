import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/custom_action_button.dart';
import '../buttons/list_tile_button.dart';

class OpenCustomSheet extends StatelessWidget {
  final bool barrierDismissible;
  final String? barrierLabel;
  final Color? barrierColor;
  final Function(dynamic)? onClose;
  final Widget Function({ScrollController? scrollController}) body;

  final bool scrollable;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  final Color? backgroundColor;
  final Color? handleColor;
  final ShapeBorder? sheetShape;
  final EdgeInsetsGeometry? sheetPadding;

  const OpenCustomSheet({
    super.key,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    this.onClose,
    required this.body,
    this.expand = true,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.scrollable = false,
    this.backgroundColor,
    this.handleColor,
    this.sheetShape,
    this.sheetPadding,
  });

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
      sheetShape: sheetShape,
      sheetPadding: sheetPadding,
      body: ({scrollController}) => body(scrollController: scrollController),
    );
  }

  static Widget _buildScrollableSheetContent(
    BuildContext context, {
    required Widget body,
    Color? backgroundColor,
    Color? handleColor,
    ShapeBorder? sheetShape,
    EdgeInsetsGeometry? sheetPadding,
  }) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Container(
        decoration: ShapeDecoration(
          shape: sheetShape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
          color: backgroundColor ?? Theme.of(context).cardColor,
        ),
        padding: sheetPadding ?? const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (handleColor != Colors.transparent) _buildHandle(handleColor),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  factory OpenCustomSheet.openConfirmSheet(
    BuildContext context, {
    required Widget body,
    Function(dynamic)? onClose,
    bool expand = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    bool scrollable = false,
    Color? backgroundColor,
    Color? handleColor,
    bool barrierDismissible = true,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    EdgeInsetsGeometry? padding,
    double? buttonSpacing,
  }) {
    return OpenCustomSheet(
      scrollable: scrollable,
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      onClose: onClose,
      backgroundColor: backgroundColor,
      barrierDismissible: barrierDismissible,
      body: ({scrollController}) => _buildSheetContent(
        context,
        body: body,
        backgroundColor: backgroundColor,
        handleColor: handleColor,
        firstButtonColor: firstButtonColor,
        secondButtonColor: secondButtonColor,
        firstButtonTextColor: firstButtonTextColor,
        secondButtonTextColor: secondButtonTextColor,
        padding: padding,
        buttonSpacing: buttonSpacing,
      ),
    );
  }

  static Widget _buildSheetContent(
    BuildContext context, {
    required Widget body,
    Color? backgroundColor,
    Color? handleColor,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    EdgeInsetsGeometry? padding,
    double? buttonSpacing,
  }) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          color: backgroundColor ?? Theme.of(context).cardColor,
        ),
        padding: padding ?? const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(handleColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: body,
            ),
            _buildButtons(
              context,
              firstButtonColor,
              secondButtonColor,
              firstButtonTextColor,
              secondButtonTextColor,
              buttonSpacing,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildButtons(
    BuildContext context,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    double? buttonSpacing,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DoubleListTileButtons(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        space: buttonSpacing ?? 8,
        firstButton: CustomActionButton.flat(
          margin: EdgeInsets.zero,
          width: double.infinity,
          onPressed: () => Navigator.pop(context, false),
          backgroundColor: firstButtonColor ?? Colors.red,
          child: Text(
            'Close',
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
            'Confirm',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: secondButtonTextColor ?? Colors.white,
                ),
          ),
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      isScrollControlled: scrollable,
      useSafeArea: true,
      context: context,
      builder: (context) {
        if (scrollable) {
          return DraggableScrollableSheet(
            expand: expand,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) {
              return GestureDetector(
                onVerticalDragUpdate: (details) {},
                child: _buildScrollableSheetContent(
                  context,
                  body: body(scrollController: scrollController),
                  backgroundColor: backgroundColor,
                  handleColor: handleColor,
                  sheetShape: sheetShape,
                  sheetPadding: sheetPadding,
                ),
              );
            },
          );
        } else {
          return MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: SafeArea(child: body()),
          );
        }
      },
    ).then((value) {
      if (onClose != null) {
        onClose!(value);
      }
    });
  }
}
