import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// A class responsible for displaying a customized modal dialog
/// that acts as a container for a notice card.
class OpenCustomDialog {
  final WidgetBuilder _bodyBuilder;
  final Function(dynamic)? onClose;
  final bool barrierDismissible;
  final Color barrierColor;
  final bool useRootNavigator;
  final bool useSafeArea;

  const OpenCustomDialog._internal({
    required WidgetBuilder bodyBuilder,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x80000000),
    this.useRootNavigator = true,
    this.useSafeArea = true,
  }) : _bodyBuilder = bodyBuilder;

  /// Factory for a dialog with a completely custom body.
  factory OpenCustomDialog.custom(
    BuildContext context, {
    required Widget Function(
      BuildContext context,
      void Function(dynamic result) close,
    )
    builder,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) =>
          builder(ctx, (result) => Navigator.of(ctx).pop(result)),
      onClose: onClose,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
    );
  }

  /// Factory for a dialog that displays a pre-configured [RistoNoticeCard].
  factory OpenCustomDialog.notice(
    BuildContext context, {
    required RistoNoticeCard notice,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) => notice,
      onClose: onClose,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
    );
  }

  /// Displays a success dialog.
  factory OpenCustomDialog.success(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool showClose = true,
    MainAxisAlignment footerAlignment = MainAxisAlignment.center,
    bool expandButtons = false,
    Color? confirmButtonBackgroundColor,
    Color? confirmButtonForegroundColor,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    Color? accentColor,
    Color? backgroundColor,
    double? minHeight,
    double? maxWidth,
  }) {
    return OpenCustomDialog._internal(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      bodyBuilder: (ctx) {
        return RistoNoticeCard.success(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          onClose: () => Navigator.pop(ctx, null),
          noticeIcon: noticeIcon,
          crossAxisAlignment: crossAxisAlignment,
          compact: compact,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          maxWidth: maxWidth,
          footerBuilder:
              footerBuilder ??
              _buildSingleFooter(
                confirmText: confirmButtonText,
                onConfirm: onConfirm,
                alignment: footerAlignment,
                expand: expandButtons,
                bgColor: confirmButtonBackgroundColor ?? accentColor,
                fgColor: confirmButtonForegroundColor,
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays an error dialog.
  factory OpenCustomDialog.error(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool showClose = true,
    MainAxisAlignment footerAlignment = MainAxisAlignment.center,
    bool expandButtons = false,
    Color? confirmButtonBackgroundColor,
    Color? confirmButtonForegroundColor,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    Color? accentColor,
    Color? backgroundColor,
    double? minHeight,
    double? maxWidth,
  }) {
    return OpenCustomDialog._internal(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      bodyBuilder: (ctx) {
        return RistoNoticeCard.error(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          onClose: () => Navigator.pop(ctx, null),
          noticeIcon: noticeIcon,
          crossAxisAlignment: crossAxisAlignment,
          compact: compact,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          maxWidth: maxWidth,
          footerBuilder:
              footerBuilder ??
              _buildSingleFooter(
                confirmText: confirmButtonText,
                onConfirm: onConfirm,
                alignment: footerAlignment,
                expand: expandButtons,
                bgColor: confirmButtonBackgroundColor ?? accentColor,
                fgColor: confirmButtonForegroundColor,
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays an informational dialog.
  factory OpenCustomDialog.info(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool showClose = true,
    MainAxisAlignment footerAlignment = MainAxisAlignment.center,
    bool expandButtons = false,
    Color? confirmButtonBackgroundColor,
    Color? confirmButtonForegroundColor,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    Color? accentColor,
    Color? backgroundColor,
    double? minHeight,
    double? maxWidth,
  }) {
    return OpenCustomDialog._internal(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      bodyBuilder: (ctx) {
        return RistoNoticeCard.info(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          onClose: () => Navigator.pop(ctx, null),
          noticeIcon: noticeIcon,
          crossAxisAlignment: crossAxisAlignment,
          compact: compact,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          maxWidth: maxWidth,
          footerBuilder:
              footerBuilder ??
              _buildSingleFooter(
                confirmText: confirmButtonText,
                onConfirm: onConfirm,
                alignment: footerAlignment,
                expand: expandButtons,
                bgColor: confirmButtonBackgroundColor ?? accentColor,
                fgColor: confirmButtonForegroundColor,
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays a warning dialog with "Continue" and "Cancel" buttons.
  factory OpenCustomDialog.warning(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    String? cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool showClose = true,
    MainAxisAlignment footerAlignment = MainAxisAlignment.end,
    bool expandButtons = true,
    Color? confirmButtonBackgroundColor,
    Color? confirmButtonForegroundColor,
    Color? cancelButtonForegroundColor,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    Color? accentColor,
    Color? backgroundColor,
    double? minHeight,
    double? maxWidth,
  }) {
    return OpenCustomDialog._internal(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      bodyBuilder: (ctx) {
        return RistoNoticeCard.warning(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          onClose: () => Navigator.pop(ctx, null),
          noticeIcon: noticeIcon,
          crossAxisAlignment: crossAxisAlignment,
          compact: compact,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          maxWidth: maxWidth,
          footerBuilder:
              footerBuilder ??
              _buildDoubleFooter(
                confirmText: confirmButtonText ?? 'Continue',
                cancelText: cancelButtonText ?? 'Cancel',
                onConfirm: onConfirm,
                onCancel: onCancel,
                alignment: footerAlignment,
                expand: expandButtons,
                confirmBgColor: confirmButtonBackgroundColor ?? accentColor,
                confirmFgColor: confirmButtonForegroundColor,
                cancelFgColor: cancelButtonForegroundColor,
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays a confirmation dialog with "Confirm" and "Cancel" buttons.
  factory OpenCustomDialog.confirm(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    String? cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Function(dynamic)? onClose,
    bool barrierDismissible = false,
    Color barrierColor = const Color(0x80000000),
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool showClose = true,
    MainAxisAlignment footerAlignment = MainAxisAlignment.end,
    bool expandButtons = true,
    Color? confirmButtonBackgroundColor,
    Color? confirmButtonForegroundColor,
    Color? cancelButtonForegroundColor,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    Color? accentColor,
    Color? backgroundColor,
    double? minHeight,
    double? maxWidth,
  }) {
    return OpenCustomDialog._internal(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      bodyBuilder: (ctx) {
        return RistoNoticeCard.neutral(
          title: title,
          subtitle: subtitle,
          showClose: showClose,
          onClose: () => Navigator.pop(ctx, null),
          noticeIcon: noticeIcon,
          crossAxisAlignment: crossAxisAlignment,
          compact: compact,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          maxWidth: maxWidth,
          footerBuilder:
              footerBuilder ??
              _buildDoubleFooter(
                confirmText: confirmButtonText ?? 'Confirm',
                cancelText: cancelButtonText ?? 'Cancel',
                onConfirm: onConfirm,
                onCancel: onCancel,
                alignment: footerAlignment,
                expand: expandButtons,
                confirmBgColor:
                    confirmButtonBackgroundColor ?? Colors.green.shade600,
                confirmFgColor: confirmButtonForegroundColor,
                cancelFgColor: cancelButtonForegroundColor,
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays the configured dialog.
  void show(
    BuildContext context, {
    Duration transitionDuration = Durations.short3,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )?
    transitionBuilder,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      useRootNavigator: useRootNavigator,
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return SafeArea(
          top: useSafeArea,
          bottom: useSafeArea,
          child: AnimatedPadding(
            padding: EdgeInsets.only(bottom: bottomInset),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutQuad,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: _bodyBuilder(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder:
          transitionBuilder ??
          (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCirc),
                ),
                child: child,
              ),
            );
          },
    ).then((value) => onClose?.call(value));
  }

  // ===========================================================================
  // PRIVATE HELPER METHODS
  // ===========================================================================

  static Widget _buildButtonWrapper({
    required bool expand,
    required Widget child,
  }) {
    return expand ? Expanded(child: child) : child;
  }

  static RistoFooterBuilder? _buildSingleFooter({
    required String? confirmText,
    required MainAxisAlignment alignment,
    required bool expand,
    VoidCallback? onConfirm,
    Color? bgColor,
    Color? fgColor,
  }) {
    if (confirmText == null) return null;

    return (context, defaultAccent) => Row(
      mainAxisAlignment: alignment,
      children: [
        _buildButtonWrapper(
          expand: expand,
          child: CustomActionButton.rounded(
            minHeight: 0,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            backgroundColor: bgColor ?? defaultAccent,
            onPressed: onConfirm ?? () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: fgColor != null ? TextStyle(color: fgColor) : null,
            ),
          ),
        ),
      ],
    );
  }

  static RistoFooterBuilder _buildDoubleFooter({
    required String confirmText,
    required String cancelText,
    required MainAxisAlignment alignment,
    required bool expand,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmBgColor,
    Color? confirmFgColor,
    Color? cancelFgColor,
  }) {
    return (context, defaultAccent) => Row(
      mainAxisAlignment: alignment,
      children: [
        _buildButtonWrapper(
          expand: expand,
          child: CustomActionButton.minimal(
            minHeight: 0,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            onPressed: onCancel ?? () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: cancelFgColor != null
                  ? TextStyle(color: cancelFgColor)
                  : null,
            ),
          ),
        ),
        if (expand) const SizedBox(width: 12) else const SizedBox(width: 8),
        _buildButtonWrapper(
          expand: expand,
          child: CustomActionButton.rounded(
            minHeight: 0,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            backgroundColor: confirmBgColor ?? defaultAccent,
            onPressed: onConfirm ?? () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: confirmFgColor != null
                  ? TextStyle(color: confirmFgColor)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
