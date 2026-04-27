import 'dart:async';

import 'package:flutter/material.dart';

import '../layouts/risto_decorator.dart';

/// Semantic toast types.
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
    double radius = 12.0,
    double elevation = 2.0,
    Color? shadowColor,
    Color? borderColor,
    double borderWidth = 1.0,
    bool top = false,
    int maxLines = 4,
    TextOverflow overflow = TextOverflow.ellipsis,
  }) {
    if (_entry != null) {
      _removeInstantly();
    }

    _toastKey = GlobalKey<_ToastBubbleState>();

    _entry = OverlayEntry(
      builder: (ctx) {
        return Positioned(
          top: top ? margin.top : null,
          bottom: top ? null : margin.bottom,
          left: margin.left,
          right: margin.right,
          child: Material(
            type: MaterialType.transparency,
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
              top: top,
              maxLines: maxLines,
              overflow: overflow,
              onDismissed: () {
                _removeInstantly();
              },
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  /// Helper for an INFO toast.
  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    int maxLines = 4,
    double? iconSize,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final defaults = _defaultsForKind(context, ToastKind.info);
    show(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: backgroundColor ?? defaults.backgroundColor,
      textColor: textColor ?? defaults.textColor,
      duration: duration,
      top: top,
      maxLines: maxLines,
      iconSize: iconSize,
      textStyle: textStyle,
      shadowColor: shadowColor ?? defaults.shadowColor,
      elevation: 6.0,
    );
  }

  /// Helper for a SUCCESS toast.
  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    int maxLines = 4,
    double? iconSize,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final defaults = _defaultsForKind(context, ToastKind.success);
    show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: backgroundColor ?? defaults.backgroundColor,
      textColor: textColor ?? defaults.textColor,
      duration: duration,
      top: top,
      maxLines: maxLines,
      iconSize: iconSize,
      textStyle: textStyle,
      shadowColor: shadowColor ?? defaults.shadowColor,
      elevation: 6.0,
    );
  }

  /// Helper for a WARNING toast.
  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool top = false,
    int maxLines = 4,
    double? iconSize,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final defaults = _defaultsForKind(context, ToastKind.warning);
    show(
      context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: backgroundColor ?? defaults.backgroundColor,
      textColor: textColor ?? defaults.textColor,
      duration: duration,
      top: top,
      maxLines: maxLines,
      iconSize: iconSize,
      textStyle: textStyle,
      shadowColor: shadowColor ?? defaults.shadowColor,
      elevation: 6.0,
    );
  }

  /// Helper for an ERROR toast.
  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    bool top = false,
    int maxLines = 4,
    double? iconSize,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final defaults = _defaultsForKind(context, ToastKind.error);
    show(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: backgroundColor ?? defaults.backgroundColor,
      textColor: textColor ?? defaults.textColor,
      duration: duration,
      top: top,
      maxLines: maxLines,
      iconSize: iconSize,
      textStyle: textStyle,
      shadowColor: shadowColor ?? defaults.shadowColor,
      elevation: 6.0,
    );
  }

  static _ToastDefaults _defaultsForKind(BuildContext context, ToastKind kind) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    switch (kind) {
      case ToastKind.info:
        return _ToastDefaults(
          backgroundColor: cs.primaryContainer,
          textColor: cs.onPrimaryContainer,
          shadowColor: cs.shadow.withCustomOpacity(0.2),
        );
      case ToastKind.success:
        return _ToastDefaults(
          backgroundColor: Colors.green.shade600,
          textColor: Colors.white,
          shadowColor: Colors.green.shade900.withCustomOpacity(0.3),
        );
      case ToastKind.warning:
        return _ToastDefaults(
          backgroundColor: Colors.orange.shade700,
          textColor: Colors.white,
          shadowColor: Colors.orange.shade900.withCustomOpacity(0.3),
        );
      case ToastKind.error:
        return _ToastDefaults(
          backgroundColor: cs.error,
          textColor: cs.onError,
          shadowColor: cs.shadow.withCustomOpacity(0.2),
        );
    }
  }
}

class _ToastDefaults {
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;

  _ToastDefaults({
    required this.backgroundColor,
    required this.textColor,
    required this.shadowColor,
  });
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
  final bool top;
  final int maxLines;
  final TextOverflow overflow;
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
    required this.top,
    required this.maxLines,
    required this.overflow,
    required this.onDismissed,
  });

  @override
  State<_ToastBubble> createState() => _ToastBubbleState();
}

class _ToastBubbleState extends State<_ToastBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slide = Tween<Offset>(
      begin: Offset(0, widget.top ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    _animCtrl.forward();

    _timer = Timer(widget.duration, () {
      dismiss();
    });
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dismiss() {
    if (!mounted) return;
    cancelTimer();
    _animCtrl.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    cancelTimer();
    _animCtrl.dispose();
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
          // Using the new RistoDecorator!
          child: RistoDecorator(
            elevation: widget.elevation,
            shadowColor: widget.shadowColor,
            borderRadius: BorderRadius.circular(widget.radius),
            padding: widget.padding,
            backgroundColor: widget.backgroundColor,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            child: ConstrainedBox(
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
