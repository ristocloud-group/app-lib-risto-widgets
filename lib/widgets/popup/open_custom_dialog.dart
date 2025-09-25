import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// A class responsible for displaying a customized modal dialog
/// that acts as a container for a notice card.
class OpenCustomDialog {
  final WidgetBuilder _bodyBuilder;
  final Function(dynamic)? onClose;

  const OpenCustomDialog._internal({
    required WidgetBuilder bodyBuilder,
    this.onClose,
  }) : _bodyBuilder = bodyBuilder;

  /// Factory for a dialog with a completely custom body.
  factory OpenCustomDialog.custom(
    BuildContext context, {
    required Widget Function(
            BuildContext context, void Function(dynamic result) close)
        builder,
    Function(dynamic)? onClose,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) =>
          builder(ctx, (result) => Navigator.of(ctx).pop(result)),
      onClose: onClose,
    );
  }

  /// The base factory for a standard notice dialog.
  factory OpenCustomDialog.notice(
    BuildContext context, {
    required RistoNoticeKind kind,
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: kind,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          borderRadius: borderRadius,
          borderOpacity: borderOpacity ?? 0.5,
          backgroundColor: backgroundColor,
          elevation: elevation,
          titleMaxLines: titleMaxLines ?? 1,
          subtitleMaxLines: subtitleMaxLines ?? 2,
          footerBuilder: (context, accentColor) {
            return CustomActionButton.rounded(
              height: 44,
              backgroundColor: accentColor,
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(confirmButtonText ?? 'OK'),
            );
          },
        );
      },
      onClose: onClose,
    );
  }

  /// Displays a success dialog.
  factory OpenCustomDialog.success(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Great!',
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      backgroundColor: backgroundColor,
      elevation: elevation,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
    );
  }

  /// Displays an error dialog.
  factory OpenCustomDialog.error(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Close',
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      backgroundColor: backgroundColor,
      elevation: elevation,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
    );
  }

  /// Displays an informational dialog.
  factory OpenCustomDialog.info(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Got it',
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      backgroundColor: backgroundColor,
      elevation: elevation,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
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

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: RistoNoticeKind.warning,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          borderRadius: borderRadius,
          borderOpacity: borderOpacity ?? 0.5,
          backgroundColor: backgroundColor,
          elevation: elevation,
          titleMaxLines: titleMaxLines ?? 1,
          subtitleMaxLines: subtitleMaxLines ?? 2,
          footerBuilder: (context, accentColor) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomActionButton.rounded(
                  height: 44,
                  backgroundColor: Colors.transparent,
                  borderColor: accentColor,
                  foregroundColor: accentColor,
                  elevation: 0,
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(cancelButtonText ?? 'Cancel'),
                ),
                const SizedBox(width: 8),
                CustomActionButton.rounded(
                  height: 44,
                  backgroundColor: accentColor,
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(confirmButtonText ?? 'Continue'),
                ),
              ],
            );
          },
        );
      },
      onClose: onClose,
    );
  }

  /// Factory for a confirmation dialog.
  factory OpenCustomDialog.confirm(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    String? cancelButtonText,
    Function(dynamic)? onClose,

    /// Card Customization
    BorderRadius? borderRadius,
    double? borderOpacity,
    Color? backgroundColor,
    double? elevation,
    int? titleMaxLines,
    int? subtitleMaxLines,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: RistoNoticeKind.neutral,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          borderRadius: borderRadius,
          borderOpacity: borderOpacity ?? 0.5,
          backgroundColor: backgroundColor,
          elevation: elevation,
          titleMaxLines: titleMaxLines ?? 1,
          subtitleMaxLines: subtitleMaxLines ?? 2,
          footerBuilder: (context, accentColor) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomActionButton.rounded(
                  height: 44,
                  backgroundColor: Colors.transparent,
                  borderColor: Theme.of(context).disabledColor,
                  foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                  elevation: 0,
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(cancelButtonText ?? 'Cancel'),
                ),
                const SizedBox(width: 8),
                CustomActionButton.rounded(
                  height: 44,
                  backgroundColor: Colors.green,
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(confirmButtonText ?? 'Confirm'),
                ),
              ],
            );
          },
        );
      },
      onClose: onClose,
    );
  }

  /// Displays the configured dialog.
  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color(0x80000000),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          content: _bodyBuilder(context),
        );
      },
    ).then((value) => onClose?.call(value));
  }
}
