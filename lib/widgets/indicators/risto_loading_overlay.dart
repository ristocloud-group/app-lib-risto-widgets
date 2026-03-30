import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

/// The visual style of the loading indicator.
enum RistoLoaderStyle { adaptive, pulsingDots }

/// A highly customizable Loading Overlay that can be used globally (via static methods)
/// or locally (by wrapping a specific widget).
class RistoLoadingOverlay extends StatelessWidget {
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

  /// Custom background color for the overlay.
  final Color? barrierColor;

  /// The blur amount for the background (X and Y). Defaults to 4.0.
  final double blurSigma;

  const RistoLoadingOverlay({
    super.key,
    required this.isLoading,
    this.child,
    this.message,
    this.progress,
    this.loaderStyle = RistoLoaderStyle.adaptive,
    this.barrierColor,
    this.blurSigma = 4.0,
  });

  // ===========================================================================
  // GLOBAL STATE MANAGEMENT (MODAL OVERLAY)
  // ===========================================================================

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
        child: RistoLoadingOverlay(
          isLoading: true,
          message: message,
          progress: progress,
          loaderStyle: loaderStyle,
          blurSigma: blurSigma,
          barrierColor: Colors.black.withCustomOpacity(0.25),
        ),
      ),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: child,
      ),
    ).then((_) => _isShowing = false);
  }

  // ===========================================================================
  // BUILDER
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loaderPanel = Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    const _PulsingDots()
                  else
                    const CircularProgressIndicator.adaptive(),

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
                    backgroundColor: theme.primaryColor.withCustomOpacity(0.2),
                    minHeight: 6,
                    color: theme.primaryColor,
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

    final overlay = Positioned.fill(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            color:
                barrierColor ??
                theme.colorScheme.surface.withCustomOpacity(0.4),
            child: loaderPanel,
          ),
        ),
      ),
    );

    if (child == null) {
      return isLoading ? loaderPanel : const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [child!, if (isLoading) overlay],
    );
  }
}

/// The core three-dot pulsing animation widget.
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

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
        color: Theme.of(context).primaryColor,
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
