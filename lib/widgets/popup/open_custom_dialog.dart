import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// A class responsible for displaying a customized modal dialog
/// that acts as a container for a notice card.
class OpenCustomDialog {
  final WidgetBuilder _bodyBuilder;
  final Function(dynamic)? onClose;
  final bool barrierDismissible;

  const OpenCustomDialog._internal({
    required WidgetBuilder bodyBuilder,
    this.onClose,
    this.barrierDismissible = true,
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
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) =>
          builder(ctx, (result) => Navigator.of(ctx).pop(result)),
      onClose: onClose,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Factory for a dialog that displays a pre-configured [RistoNoticeCard].
  factory OpenCustomDialog.notice(
    BuildContext context, {
    required RistoNoticeCard notice,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) => notice,
      onClose: onClose,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Displays a success dialog.
  /// Does not have a footer button by default. Provide [confirmButtonText] to add one.
  factory OpenCustomDialog.success(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText, // Nullable to allow no button
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    // --- RistoNoticeCard Pass-through Properties ---
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
      bodyBuilder: (ctx) {
        return RistoNoticeCard.success(
          title: title,
          subtitle: subtitle,
          showClose: true,
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
              (confirmButtonText != null
                  ? (context, accentColor) => CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: accentColor,
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(confirmButtonText),
                    )
                  : null),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays an error dialog.
  /// Does not have a footer button by default. Provide [confirmButtonText] to add one.
  factory OpenCustomDialog.error(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText, // Nullable to allow no button
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    // --- RistoNoticeCard Pass-through Properties ---
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
      bodyBuilder: (ctx) {
        return RistoNoticeCard.error(
          title: title,
          subtitle: subtitle,
          showClose: true,
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
              (confirmButtonText != null
                  ? (context, accentColor) => CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: accentColor,
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(confirmButtonText),
                    )
                  : null),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays an informational dialog.
  /// Does not have a footer button by default. Provide [confirmButtonText] to add one.
  factory OpenCustomDialog.info(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    // --- RistoNoticeCard Pass-through Properties ---
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
      bodyBuilder: (ctx) {
        return RistoNoticeCard.info(
          title: title,
          subtitle: subtitle,
          showClose: true,
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
              (confirmButtonText != null
                  ? (context, accentColor) => CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: accentColor,
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(confirmButtonText),
                    )
                  : null),
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
    Function(dynamic)? onClose,
    bool barrierDismissible = true,
    // --- RistoNoticeCard Pass-through Properties ---
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
      bodyBuilder: (ctx) {
        return RistoNoticeCard.warning(
          title: title,
          subtitle: subtitle,
          showClose: true,
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
              (context, accentColor) => Row(
                children: [
                  Expanded(
                    child: CustomActionButton.minimal(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(cancelButtonText ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: accentColor,
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(confirmButtonText ?? 'Continue'),
                    ),
                  ),
                ],
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
    Function(dynamic)? onClose,
    bool barrierDismissible = false,
    // --- RistoNoticeCard Pass-through Properties ---
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
      bodyBuilder: (ctx) {
        return RistoNoticeCard.neutral(
          title: title,
          subtitle: subtitle,
          showClose: true,
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
              (context, accentColor) => Row(
                children: [
                  Expanded(
                    child: CustomActionButton.minimal(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(cancelButtonText ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      backgroundColor: Colors.green.shade600,
                      // Specific color for confirm
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(confirmButtonText ?? 'Confirm'),
                    ),
                  ),
                ],
              ),
        );
      },
      onClose: onClose,
    );
  }

  /// Displays the configured dialog.
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: const Color(0x80000000),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          content: _bodyBuilder(context),
        );
      },
    ).then((value) => onClose?.call(value));
  }
}
