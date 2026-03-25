import 'dart:async';

import 'package:flutter/material.dart';

/// Semantic toast types.
/// Use [RistoToast.toast] or convenience helpers:
/// [RistoToast.info], [RistoToast.success], [RistoToast.warning], [RistoToast.error].
enum ToastKind { info, success, warning, error }

/// Centralized toast/overlay notifier (never uses SnackBar).
/// Works anywhere (pages, dialogs, popup) because it uses Overlay.
class RistoToast {
  RistoToast._();

  static OverlayEntry? _entry;
  static GlobalKey<_ToastBubbleState>? _toastKey;

  /// Programmatically hide the current toast (if any) with an exit animation.
  static void hide() {
    _toastKey?.currentState?.dismiss();
  }

  /// Instantly removes the toast without animation. Used internally for overriding.
  static void _removeInstantly() {
    _toastKey?.currentState?.cancelTimer();
    _entry?.remove();
    _entry = null;
    _toastKey = null;
  }

  /// Base overlay toast.
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = const Color(0xE6000000),
    Color textColor = Colors.white,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
    bool top = false,
  }) {
    _removeInstantly();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _toastKey = GlobalKey<_ToastBubbleState>();

    _entry = OverlayEntry(
      builder: (ctx) {
        final alignment = top ? Alignment.topCenter : Alignment.bottomCenter;
        return SafeArea(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: margin,
              child: _ToastBubble(
                key: _toastKey,
                message: message,
                backgroundColor: backgroundColor,
                textColor: textColor,
                textStyle: textStyle,
                icon: icon,
                iconSize: iconSize,
                duration: duration,
                padding: padding,
                radius: radius,
                elevation: elevation,
                shadowColor: shadowColor,
                borderColor: borderColor,
                borderWidth: borderWidth,
                maxLines: maxLines,
                overflow: overflow,
                top: top,
                onDismissed: _removeInstantly,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_entry!);
  }

  /// Typed toast with sensible defaults per [ToastKind].
  static void toast(
    BuildContext context, {
    required String message,
    ToastKind kind = ToastKind.info,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  }) {
    final d = _defaultsForKind(context, kind);

    show(
      context,
      message: message,
      duration: duration,
      top: top,
      backgroundColor: backgroundColor ?? d.bg,
      textColor: textColor ?? d.fg,
      textStyle: textStyle,
      icon: icon ?? d.icon,
      iconSize: iconSize,
      margin: margin,
      padding: padding,
      radius: radius,
      elevation: elevation,
      shadowColor: shadowColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Convenience wrappers
  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  }) => toast(
    context,
    message: message,
    kind: ToastKind.info,
    duration: duration,
    top: top,
    backgroundColor: backgroundColor,
    textColor: textColor,
    textStyle: textStyle,
    icon: icon,
    iconSize: iconSize,
    margin: margin,
    padding: padding,
    radius: radius,
    elevation: elevation,
    shadowColor: shadowColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    maxLines: maxLines,
    overflow: overflow,
  );

  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  }) => toast(
    context,
    message: message,
    kind: ToastKind.success,
    duration: duration,
    top: top,
    backgroundColor: backgroundColor,
    textColor: textColor,
    textStyle: textStyle,
    icon: icon,
    iconSize: iconSize,
    margin: margin,
    padding: padding,
    radius: radius,
    elevation: elevation,
    shadowColor: shadowColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    maxLines: maxLines,
    overflow: overflow,
  );

  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  }) => toast(
    context,
    message: message,
    kind: ToastKind.warning,
    duration: duration,
    top: top,
    backgroundColor: backgroundColor,
    textColor: textColor,
    textStyle: textStyle,
    icon: icon,
    iconSize: iconSize,
    margin: margin,
    padding: padding,
    radius: radius,
    elevation: elevation,
    shadowColor: shadowColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    maxLines: maxLines,
    overflow: overflow,
  );

  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 64,
    ),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    double radius = 12,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  }) => toast(
    context,
    message: message,
    kind: ToastKind.error,
    duration: duration,
    top: top,
    backgroundColor: backgroundColor,
    textColor: textColor,
    textStyle: textStyle,
    icon: icon,
    iconSize: iconSize,
    margin: margin,
    padding: padding,
    radius: radius,
    elevation: elevation,
    shadowColor: shadowColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    maxLines: maxLines,
    overflow: overflow,
  );

  static _Defaults _defaultsForKind(BuildContext context, ToastKind kind) {
    final theme = Theme.of(context);
    switch (kind) {
      case ToastKind.success:
        return _Defaults(
          Colors.green.shade700,
          Colors.white,
          Icons.check_circle_outline,
        );
      case ToastKind.warning:
        return _Defaults(
          Colors.orange.shade700,
          Colors.white,
          Icons.warning_amber_rounded,
        );
      case ToastKind.error:
        return _Defaults(
          theme.colorScheme.error,
          theme.colorScheme.onError,
          Icons.error_outline,
        );
      case ToastKind.info:
        return const _Defaults(
          Color(0xDD000000),
          Colors.white,
          Icons.info_outline,
        );
    }
  }
}

class _Defaults {
  final Color bg;
  final Color fg;
  final IconData icon;

  const _Defaults(this.bg, this.fg, this.icon);
}

class _ToastBubble extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final double? iconSize;
  final Duration duration;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double elevation;
  final Color? shadowColor;
  final Color? borderColor;
  final double borderWidth;
  final int? maxLines;
  final TextOverflow overflow;
  final bool top;
  final VoidCallback onDismissed;

  const _ToastBubble({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.textStyle,
    this.icon,
    this.iconSize,
    required this.duration,
    required this.padding,
    required this.radius,
    required this.elevation,
    this.shadowColor,
    this.borderColor,
    required this.borderWidth,
    this.maxLines,
    required this.overflow,
    required this.top,
    required this.onDismissed,
  });

  @override
  State<_ToastBubble> createState() => _ToastBubbleState();
}

class _ToastBubbleState extends State<_ToastBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.top ? const Offset(0, -0.5) : const Offset(0, 0.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  Timer? _timer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _c.forward();
    _timer = Timer(widget.duration, dismiss);
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dismiss() {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    cancelTimer();
    _c.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    cancelTimer();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: widget.textColor,
    );

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: GestureDetector(
          onTap: dismiss,
          behavior: HitTestBehavior.opaque,
          child: Material(
            color: Colors.transparent,
            elevation: widget.elevation,
            shadowColor: widget.shadowColor ?? theme.colorScheme.shadow,
            borderRadius: BorderRadius.circular(widget.radius),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.radius),
                border: widget.borderColor != null
                    ? Border.all(
                        color: widget.borderColor!,
                        width: widget.borderWidth,
                      )
                    : null,
              ),
              constraints: const BoxConstraints(maxWidth: 520),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: widget.iconSize ?? 20,
                      color: widget.textColor,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      widget.message,
                      style: defaultTextStyle?.merge(widget.textStyle),
                      textAlign: TextAlign.center,
                      maxLines: widget.maxLines,
                      overflow: widget.overflow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
