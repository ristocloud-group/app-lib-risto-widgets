import 'dart:async';

import 'package:flutter/material.dart';

/// Semantic toast types.
/// Use [RistoToast.toast] or convenience helpers:
/// [RistoToast.info], [RistoToast.success], [RistoToast.warning], [RistoToast.error].
enum ToastKind { info, success, warning, error }

/// Centralized toast/overlay notifier (never uses SnackBar).
/// Works anywhere (pages, dialogs, sheets) because it uses Overlay.
class RistoToast {
  RistoToast._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  /// Programmatically hide the current toast (if any).
  static void hide() => _remove();

  /// Base overlay toast.
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = const Color(0xE6000000),
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    EdgeInsets margin =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
    double radius = 12,
    bool top = false, // false => bottom
  }) {
    _timer?.cancel();
    _remove();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (ctx) {
        final alignment = top ? Alignment.topCenter : Alignment.bottomCenter;
        return IgnorePointer(
          ignoring: true,
          child: SafeArea(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: margin,
                child: _ToastBubble(
                  key: const ValueKey('risto_toast_bubble'),
                  message: message,
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                  icon: icon,
                  radius: radius,
                  top: top,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_entry!);
    _timer = Timer(duration, _remove);
  }

  /// Typed toast with sensible defaults per [ToastKind].
  static void toast(
    BuildContext context, {
    required String message,
    ToastKind kind = ToastKind.info,
    Duration duration = const Duration(seconds: 2),
    bool top = false,

    // Optional overrides:
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    EdgeInsets margin =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
    double radius = 12,
  }) {
    final d = _defaultsForKind(context, kind);

    show(
      context,
      message: message,
      duration: duration,
      top: top,
      backgroundColor: backgroundColor ?? d.bg,
      textColor: textColor ?? d.fg,
      icon: icon ?? d.icon,
      margin: margin,
      radius: radius,
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
    IconData? icon,
  }) =>
      toast(
        context,
        message: message,
        kind: ToastKind.info,
        duration: duration,
        top: top,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
      );

  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) =>
      toast(
        context,
        message: message,
        kind: ToastKind.success,
        duration: duration,
        top: top,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
      );

  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) =>
      toast(
        context,
        message: message,
        kind: ToastKind.warning,
        duration: duration,
        top: top,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
      );

  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
  }) =>
      toast(
        context,
        message: message,
        kind: ToastKind.error,
        duration: duration,
        top: top,
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
      );

  // ---- internals -----------------------------------------------------------

  static void _remove() {
    _entry?.remove();
    _entry = null;
  }

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
        // Uses theme error color by default (can be overridden in params).
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
  const _ToastBubble({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.radius = 12,
    this.top = false,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double radius;
  final bool top;

  @override
  State<_ToastBubble> createState() => _ToastBubbleState();
}

class _ToastBubbleState extends State<_ToastBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.top ? const Offset(0, -0.1) : const Offset(0, 0.1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            constraints: const BoxConstraints(maxWidth: 520),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: widget.textColor),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.message,
                    style: TextStyle(color: widget.textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
