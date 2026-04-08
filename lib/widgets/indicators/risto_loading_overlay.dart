import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

// ===========================================================================
// LOADER UTILITY
// ===========================================================================

/// Different loader configurations.
enum _LoaderStyle { basic, fitted, centered }

/// A versatile loading indicator with factory constructors for different styles.
class Loader extends StatelessWidget {
  final _LoaderStyle _style;
  final EdgeInsetsGeometry? _padding;
  final Alignment _alignment;
  final Color? _color;

  const Loader._({
    super.key,
    required _LoaderStyle style,
    EdgeInsetsGeometry? padding,
    Alignment alignment = Alignment.center,
    Color? color,
  }) : _style = style,
       _padding = padding,
       _alignment = alignment,
       _color = color;

  /// Basic adaptive circular progress indicator.
  factory Loader.basic({Key? key, Color? color}) {
    return Loader._(key: key, style: _LoaderStyle.basic, color: color);
  }

  /// Loader scaled down via FittedBox with optional padding/alignment.
  factory Loader.fitted({
    Key? key,
    EdgeInsetsGeometry? padding,
    Alignment alignment = Alignment.center,
    Color? color,
  }) {
    return Loader._(
      key: key,
      style: _LoaderStyle.fitted,
      padding: padding,
      alignment: alignment,
      color: color,
    );
  }

  /// Loader centered within a Container with optional padding/alignment.
  factory Loader.centered({
    Key? key,
    EdgeInsetsGeometry? padding,
    Alignment alignment = Alignment.center,
    Color? color,
  }) {
    return Loader._(
      key: key,
      style: _LoaderStyle.centered,
      padding: padding,
      alignment: alignment,
      color: color,
    );
  }

  static Widget _basicIndicator(Color? color) {
    if (color != null) {
      return CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      );
    }
    return const CircularProgressIndicator.adaptive();
  }

  static Widget _fittedIndicator({
    EdgeInsetsGeometry? padding,
    Alignment alignment = Alignment.center,
    Color? color,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: _basicIndicator(color),
      ),
    );
  }

  static Widget _centeredIndicator({
    EdgeInsetsGeometry? padding,
    Alignment alignment = Alignment.center,
    Color? color,
  }) {
    return Container(
      padding: padding,
      alignment: alignment,
      child: _basicIndicator(color),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_style) {
      case _LoaderStyle.fitted:
        return _fittedIndicator(
          padding: _padding,
          alignment: _alignment,
          color: _color,
        );
      case _LoaderStyle.centered:
        return _centeredIndicator(
          padding: _padding,
          alignment: _alignment,
          color: _color,
        );
      case _LoaderStyle.basic:
        return _basicIndicator(_color);
    }
  }
}

// ===========================================================================
// LOADING OVERLAY
// ===========================================================================

/// The visual style of the loading indicator within the overlay.
enum RistoLoaderStyle { adaptive, pulsingDots }

/// A highly customizable Loading Overlay that can be used globally (via static methods)
/// or locally (by wrapping a specific widget).
class LoadingPanel extends StatelessWidget {
  /// The widget to display behind the overlay (used for local overlays).
  final Widget? child;

  /// Whether the loading overlay is currently visible.
  final bool isLoading;

  /// The message to display below the loader.
  final String? message;

  /// The progress value (0.0 to 1.0) to display a progress bar.
  final double? progress;

  /// The visual style of the loader.
  final RistoLoaderStyle loaderStyle;

  /// Custom background color for the overlay barrier.
  final Color? barrierColor;

  /// Custom color for the loader widget (spinner or dots).
  final Color? loaderColor;

  /// The blur amount for the background (X and Y). Defaults to 4.0.
  final double blurSigma;

  /// The internal padding of the loader panel. Defaults to horizontal 24, vertical 16.
  final EdgeInsetsGeometry? padding;

  /// The external margin of the loader panel.
  final EdgeInsetsGeometry? margin;

  const LoadingPanel({
    super.key,
    required this.isLoading,
    this.child,
    this.message,
    this.progress,
    this.loaderStyle = RistoLoaderStyle.adaptive,
    this.barrierColor,
    this.loaderColor,
    this.blurSigma = 4.0,
    this.padding,
    this.margin,
  });

  /// Creates a loading overlay with a dark, semi-transparent barrier.
  factory LoadingPanel.dark({
    Key? key,
    required bool isLoading,
    Widget? child,
    String? message,
    double? progress,
    RistoLoaderStyle loaderStyle = RistoLoaderStyle.pulsingDots,
    Color? loaderColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return LoadingPanel(
      key: key,
      isLoading: isLoading,
      message: message,
      progress: progress,
      loaderStyle: loaderStyle,
      barrierColor: Colors.black.withCustomOpacity(0.6),
      loaderColor: loaderColor,
      blurSigma: 2.0,
      padding: padding,
      margin: margin,
      child: child,
    );
  }

  /// Creates a loading overlay with a high-blur, glass-like barrier.
  factory LoadingPanel.glass({
    Key? key,
    required bool isLoading,
    Widget? child,
    String? message,
    double? progress,
    RistoLoaderStyle loaderStyle = RistoLoaderStyle.adaptive,
    Color? loaderColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return LoadingPanel(
      key: key,
      isLoading: isLoading,
      message: message,
      progress: progress,
      loaderStyle: loaderStyle,
      barrierColor: Colors.white.withCustomOpacity(0.1),
      loaderColor: loaderColor,
      blurSigma: 10.0,
      padding: padding,
      margin: margin,
      child: child,
    );
  }

  /// Creates a loading overlay with no blur and a fully transparent barrier.
  factory LoadingPanel.clear({
    Key? key,
    required bool isLoading,
    Widget? child,
    String? message,
    double? progress,
    RistoLoaderStyle loaderStyle = RistoLoaderStyle.adaptive,
    Color? loaderColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return LoadingPanel(
      key: key,
      isLoading: isLoading,
      message: message,
      progress: progress,
      loaderStyle: loaderStyle,
      barrierColor: Colors.transparent,
      loaderColor: loaderColor,
      blurSigma: 0.0,
      padding: padding,
      margin: margin,
      child: child,
    );
  }

  static bool _isShowing = false;

  /// Hides the currently visible global loading panel, if any.
  static void hide(BuildContext context) {
    if (_isShowing) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
      _isShowing = false;
    }
  }

  /// Shows the loading panel as a full-screen, modal dialog.
  /// Prevents user interaction while loading.
  static void show(
    BuildContext context, {
    String? message,
    double? progress,
    RistoLoaderStyle loaderStyle = RistoLoaderStyle.pulsingDots,
    double blurSigma = 6.0,
    Color? barrierColor,
    Color? loaderColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    if (_isShowing) return;
    _isShowing = true;

    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, _, _) => PopScope(
        canPop: false,
        child: LoadingPanel(
          isLoading: true,
          message: message,
          progress: progress,
          loaderStyle: loaderStyle,
          blurSigma: blurSigma,
          barrierColor: barrierColor ?? Colors.black.withCustomOpacity(0.25),
          loaderColor: loaderColor,
          padding: padding,
          margin: margin,
        ),
      ),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: child,
      ),
    ).then((_) => _isShowing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loaderPanel = Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: margin,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          constraints: const BoxConstraints(minWidth: 160),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withCustomOpacity(0.12),
                blurRadius: 14,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loaderStyle == RistoLoaderStyle.pulsingDots)
                    _PulsingDots(color: loaderColor)
                  else
                    Loader.basic(color: loaderColor),
                  if (message != null) ...[
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: (loaderColor ?? theme.primaryColor)
                        .withCustomOpacity(0.2),
                    minHeight: 6,
                    color: loaderColor ?? theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(progress! * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    final barrierWidget = ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          color:
              barrierColor ?? theme.colorScheme.surface.withCustomOpacity(0.4),
          child: loaderPanel,
        ),
      ),
    );

    if (child == null) {
      return isLoading ? barrierWidget : const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        if (isLoading) Positioned.fill(child: barrierWidget),
      ],
    );
  }
}

/// The core three-dot pulsing animation widget.
class _PulsingDots extends StatefulWidget {
  final Color? color;

  const _PulsingDots({this.color});

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a1, _a2, _a3;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _a1 = CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.6));
    _a2 = CurvedAnimation(parent: _c, curve: const Interval(0.2, 0.8));
    _a3 = CurvedAnimation(parent: _c, curve: const Interval(0.4, 1.0));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> a) => ScaleTransition(
    scale: Tween(begin: 0.6, end: 1.0).animate(a),
    child: Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: widget.color ?? Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_dot(_a1), _dot(_a2), _dot(_a3)],
    );
  }
}
