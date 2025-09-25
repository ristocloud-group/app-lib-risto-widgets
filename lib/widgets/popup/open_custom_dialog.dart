import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// A class responsible for displaying a customized modal dialog
/// that acts as a container for a notice card.
///
/// This refactored class uses a `bodyBuilder` pattern. The factories
/// construct a complete `RistoNoticeCard`, including its footer buttons,
/// which is then displayed inside a basic dialog shell.
class OpenCustomDialog {
  final WidgetBuilder _bodyBuilder;
  final Function(dynamic)? onClose;

  /// PRIVATE constructor used by all factories.
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
  /// Prefer using the semantic factories: `.success`, `.error`, `.info`.
  factory OpenCustomDialog.notice(
    BuildContext context, {
    required RistoNoticeKind kind,
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    int subtitleMaxLines = 2,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: kind,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          // Pass down customizations
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          elevation: elevation,
          margin: margin,
          subtitleMaxLines: subtitleMaxLines,
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

  // --- SEMANTIC FACTORIES ---

  factory OpenCustomDialog.success(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Great!',
      onClose: onClose,
      // Pass down customizations
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  factory OpenCustomDialog.error(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Close',
      onClose: onClose,
      // Pass down customizations
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  factory OpenCustomDialog.info(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
  }) {
    return OpenCustomDialog.notice(
      context,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText ?? 'Got it',
      onClose: onClose,
      // Pass down customizations
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  factory OpenCustomDialog.warning(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    String? cancelButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: RistoNoticeKind.warning,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          // Pass down customizations
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          elevation: elevation,
          footerBuilder: (context, accentColor) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Secondary outlined button
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
                // Primary solid button
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

  factory OpenCustomDialog.confirm(
    BuildContext context, {
    required String title,
    String? subtitle,
    String? confirmButtonText,
    String? cancelButtonText,
    Function(dynamic)? onClose,
    // Card Customization
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? elevation,
  }) {
    return OpenCustomDialog._internal(
      bodyBuilder: (ctx) {
        return RistoNoticeCard(
          kind: RistoNoticeKind.neutral,
          title: title,
          subtitle: subtitle,
          showClose: true,
          onClose: () => Navigator.pop(ctx, null),
          // Pass down customizations
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          elevation: elevation,
          footerBuilder: (context, accentColor) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Secondary outlined button
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
                // Primary solid button
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
