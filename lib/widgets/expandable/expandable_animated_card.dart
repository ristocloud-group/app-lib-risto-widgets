import 'dart:ui';

import 'package:flutter/material.dart';

import '../layouts/risto_decorator.dart';
import '../layouts/size_reporting_widget.dart';

enum HeaderMode { overlay, none }

enum CardType { normal, fullscreen, sheet, menu }

/// Optional controller for programmatic opening/closing.
class ExpandableAnimatedCardController extends ChangeNotifier {
  VoidCallback? _open;
  VoidCallback? _close;

  bool get canOpen => _open != null;

  bool get canClose => _close != null;

  void _bind({required VoidCallback open, required VoidCallback close}) {
    _open = open;
    _close = close;
  }

  void _unbind() {
    _open = null;
    _close = null;
  }

  void open() => _open?.call();

  void close() => _close?.call();
}

class ExpandableAnimatedCard extends StatefulWidget {
  final WidgetBuilder collapsedBuilder;
  final WidgetBuilder expandedBuilder;

  final Duration animationDuration;
  final Curve animationCurve;
  final Interval fadeInterval;

  final EdgeInsetsGeometry expandedMargin;
  final EdgeInsetsGeometry expandedPadding;
  final double? maxWidth;
  final bool useSafeArea;

  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final double elevation;
  final Color? shadowColor;

  final HeaderMode headerMode;
  final double headerHeight;
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  final Color overlayBackgroundColor;
  final double blurSigma;
  final Widget Function(BuildContext, Animation<double>)? scrimBuilder;

  final Color barrierColor;
  final bool barrierDismissible;
  final bool enableDragToDismiss;
  final double dragDismissThreshold;

  final VoidCallback? onClose;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final ValueChanged<bool>? onStateChanged;

  final double? _sheetMaxHeight;
  final double? _sheetMaxHeightFraction;
  final double? _sheetDragDismissThresholdFraction;

  final double menuOffset;
  final Alignment menuAlignment;

  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final String? barrierLabel;

  final Clip clipBehavior;
  final ExpandableAnimatedCardController? controller;
  final bool autoOpenOnTap;

  final CardType _type;

  // ===========================================================================
  // CONSTRUCTORS
  // ===========================================================================

  /// Default constructor — allows full customization.
  const ExpandableAnimatedCard({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCubic,
    this.fadeInterval = const Interval(
      0.35,
      1.0,
      curve: Cubic(0.5, 0.0, 0.3, 1.0),
    ),
    this.expandedMargin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.expandedPadding = const EdgeInsets.all(0),
    this.maxWidth,
    this.useSafeArea = true,
    this.backgroundColor = const Color(0xFF5D5D5D),
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.elevation = 4.0,
    this.shadowColor,
    this.headerMode = HeaderMode.overlay,
    this.headerHeight = 40.0,
    this.overlayBackgroundColor = Colors.black54,
    this.blurSigma = 0.0,
    this.scrimBuilder,
    this.headerBuilder,
    this.barrierColor = Colors.transparent,
    this.barrierDismissible = true,
    this.enableDragToDismiss = false,
    this.dragDismissThreshold = 120.0,
    this.onClose,
    this.onOpened,
    this.onClosed,
    this.onStateChanged,
    this.useRootNavigator = false,
    this.routeSettings,
    this.barrierLabel,
    this.clipBehavior = Clip.antiAlias,
    this.controller,
    this.autoOpenOnTap = true,
  }) : _type = CardType.normal,
       menuOffset = 0.0,
       menuAlignment = Alignment.topCenter,
       _sheetMaxHeight = null,
       _sheetMaxHeightFraction = null,
       _sheetDragDismissThresholdFraction = null;

  /// Factory: fullscreen
  const ExpandableAnimatedCard.fullscreen({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCubic,
    this.overlayBackgroundColor = Colors.black54,
    this.blurSigma = 0.0,
    this.barrierColor = Colors.transparent,
    this.barrierDismissible = true,
    this.useRootNavigator = false,
    this.routeSettings,
    this.barrierLabel,
    this.onClose,
    this.onOpened,
    this.onClosed,
    this.onStateChanged,
    this.controller,
    this.autoOpenOnTap = true,
  }) : _type = CardType.fullscreen,
       fadeInterval = const Interval(
         0.35,
         1.0,
         curve: Cubic(0.5, 0.0, 0.3, 1.0),
       ),
       expandedMargin = EdgeInsets.zero,
       expandedPadding = EdgeInsets.zero,
       maxWidth = null,
       useSafeArea = false,
       backgroundColor = Colors.transparent,
       backgroundGradient = null,
       borderColor = null,
       borderWidth = 0.0,
       borderRadius = BorderRadius.zero,
       elevation = 0.0,
       shadowColor = null,
       headerMode = HeaderMode.none,
       headerHeight = 0.0,
       headerBuilder = null,
       scrimBuilder = null,
       enableDragToDismiss = false,
       dragDismissThreshold = 9999.0,
       clipBehavior = Clip.none,
       menuOffset = 0.0,
       menuAlignment = Alignment.topCenter,
       _sheetMaxHeight = null,
       _sheetMaxHeightFraction = null,
       _sheetDragDismissThresholdFraction = null;

  /// Factory: sheet
  const ExpandableAnimatedCard.sheet({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16,
    ), // Retro-compatibility
    this.backgroundColor = const Color(0xFF5D5D5D),
    this.elevation = 8.0,
    this.shadowColor,
    double? maxHeight,
    double? maxHeightFraction,
    double? dragDismissThresholdFraction,
    this.overlayBackgroundColor = Colors.black54,
    this.blurSigma = 0.0,
    this.barrierColor = Colors.transparent,
    bool dragToClose = true, // Retro-compatibility
    this.dragDismissThreshold = 120.0,
    this.barrierDismissible = true,
    this.useRootNavigator = false,
    this.routeSettings,
    this.barrierLabel,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCubic,
    this.onClose,
    this.onOpened,
    this.onClosed,
    this.onStateChanged,
    this.controller,
    this.autoOpenOnTap = true,
  }) : _type = CardType.sheet,
       expandedMargin = margin,
       // Mapped
       enableDragToDismiss = dragToClose,
       // Mapped
       fadeInterval = const Interval(
         0.35,
         1.0,
         curve: Cubic(0.5, 0.0, 0.3, 1.0),
       ),
       expandedPadding = EdgeInsets.zero,
       maxWidth = null,
       useSafeArea = false,
       backgroundGradient = null,
       borderColor = null,
       borderWidth = 0.0,
       headerMode = HeaderMode.none,
       headerHeight = 0.0,
       headerBuilder = null,
       scrimBuilder = null,
       clipBehavior = Clip.antiAlias,
       menuOffset = 0.0,
       menuAlignment = Alignment.topCenter,
       _sheetMaxHeight = maxHeight,
       _sheetMaxHeightFraction = maxHeightFraction,
       _sheetDragDismissThresholdFraction = dragDismissThresholdFraction;

  /// Factory: menu
  const ExpandableAnimatedCard.menu({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.backgroundColor = Colors.white,
    this.elevation = 8.0,
    this.shadowColor,
    double menuWidth = 250.0,
    double menuHeight = 300.0,
    this.menuOffset = 8.0,
    this.menuAlignment = Alignment.topCenter,
    this.overlayBackgroundColor = Colors.black12,
    this.blurSigma = 0.0,
    this.barrierDismissible = true,
    this.useRootNavigator = false,
    this.routeSettings,
    this.barrierLabel,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.onClose,
    this.onOpened,
    this.onClosed,
    this.onStateChanged,
    this.controller,
    this.autoOpenOnTap = true,
  }) : _type = CardType.menu,
       fadeInterval = const Interval(0.2, 1.0, curve: Curves.easeOut),
       expandedMargin = const EdgeInsets.all(16),
       expandedPadding = EdgeInsets.zero,
       maxWidth = menuWidth,
       useSafeArea = true,
       backgroundGradient = null,
       borderColor = null,
       borderWidth = 0.0,
       headerMode = HeaderMode.none,
       headerHeight = 0.0,
       headerBuilder = null,
       scrimBuilder = null,
       barrierColor = Colors.transparent,
       enableDragToDismiss = false,
       dragDismissThreshold = 9999.0,
       clipBehavior = Clip.antiAlias,
       _sheetMaxHeight = menuHeight,
       _sheetMaxHeightFraction = null,
       _sheetDragDismissThresholdFraction = null;

  @override
  State<ExpandableAnimatedCard> createState() => _ExpandableAnimatedCardState();
}

class _ExpandableAnimatedCardState extends State<ExpandableAnimatedCard> {
  Size? _widgetSize;
  final GlobalKey _widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller?._bind(open: _showOverlay, close: _closeOverlayIfAny);
  }

  @override
  void didUpdateWidget(covariant ExpandableAnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._unbind();
      widget.controller?._bind(open: _showOverlay, close: _closeOverlayIfAny);
    }
  }

  @override
  void dispose() {
    widget.controller?._unbind();
    super.dispose();
  }

  void _closeOverlayIfAny() {
    if (!mounted) return;
    final navigator = widget.useRootNavigator
        ? Navigator.of(context, rootNavigator: true)
        : Navigator.of(context);
    navigator.maybePop();
  }

  void _showOverlay() {
    final currentContext = _widgetKey.currentContext;
    if (_widgetSize == null ||
        currentContext == null ||
        !currentContext.mounted) {
      return;
    }

    final navigator = widget.useRootNavigator
        ? Navigator.of(currentContext, rootNavigator: true)
        : Navigator.of(currentContext);
    final RenderBox? box = currentContext.findRenderObject() as RenderBox?;
    final RenderObject? navRO = navigator.context.findRenderObject();
    if (box == null || navRO == null) return;

    final Offset position = box.localToGlobal(Offset.zero, ancestor: navRO);
    final Rect initialRect = Rect.fromLTWH(
      position.dx,
      position.dy,
      _widgetSize!.width,
      _widgetSize!.height,
    );

    final overlayWidget = _ExpandableAnimatedOverlay(
      initialRect: initialRect,
      widget: widget,
    );

    final route = PageRouteBuilder(
      settings: widget.routeSettings,
      opaque: false,
      barrierDismissible: widget.barrierDismissible,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel,
      transitionDuration: widget.animationDuration,
      reverseTransitionDuration: widget.animationDuration,
      pageBuilder: (_, _, _) => overlayWidget,
    );

    navigator.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _widgetKey,
      onTap: widget.autoOpenOnTap ? _showOverlay : null,
      child: SizeReportingWidget(
        onSizeChange: (size) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _widgetSize != size) {
              setState(() => _widgetSize = size);
            }
          });
        },
        child: widget.collapsedBuilder(context),
      ),
    );
  }
}

class _ExpandableAnimatedOverlay extends StatefulWidget {
  final Rect initialRect;
  final ExpandableAnimatedCard widget;

  const _ExpandableAnimatedOverlay({
    required this.initialRect,
    required this.widget,
  });

  @override
  State<_ExpandableAnimatedOverlay> createState() =>
      _ExpandableAnimatedOverlayState();
}

class _ExpandableAnimatedOverlayState
    extends State<_ExpandableAnimatedOverlay> {
  double _dragDy = 0.0;
  Animation<double>? _routeAnim;

  void _close() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.widget.onOpened?.call();
      widget.widget.onStateChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.widget.onClosed?.call();
      widget.widget.onClose?.call();
      widget.widget.onStateChanged?.call(false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final anim = route?.animation;
    if (_routeAnim != anim) {
      _routeAnim?.removeStatusListener(_onStatus);
      _routeAnim = anim;
      _routeAnim?.addStatusListener(_onStatus);
    }
  }

  @override
  void dispose() {
    _routeAnim?.removeStatusListener(_onStatus);
    super.dispose();
  }

  Widget _buildDefaultHeader(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: widget.widget.headerHeight,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: _close,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> routeAnim = ModalRoute.of(context)!.animation!;
    final Size screen = MediaQuery.sizeOf(context);
    final TextDirection dir = Directionality.of(context);
    final EdgeInsets viewPadding = MediaQuery.viewPaddingOf(context);

    final EdgeInsets baseOuter = widget.widget.expandedMargin.resolve(dir);
    final EdgeInsets innerPad = widget.widget.expandedPadding.resolve(dir);

    double left = baseOuter.left;
    double top =
        baseOuter.top +
        (widget.widget.headerMode == HeaderMode.overlay
            ? widget.widget.headerHeight
            : 0);
    double width = screen.width - baseOuter.left - baseOuter.right;
    double height = screen.height - top - baseOuter.bottom;

    if (widget.widget.useSafeArea) {
      left += viewPadding.left;
      top += viewPadding.top;
      width -= (viewPadding.left + viewPadding.right);
      height -= viewPadding.bottom;
    }

    final Rect initialRect = widget.initialRect;
    Alignment overflowAlignment = Alignment.topCenter;

    if (widget.widget._type == CardType.menu) {
      width = widget.widget.maxWidth ?? 250.0;
      height = widget.widget._sheetMaxHeight ?? 300.0;

      if (widget.widget.menuAlignment.x == 0) {
        left = initialRect.center.dx - (width / 2);
      } else if (widget.widget.menuAlignment.x > 0) {
        left = initialRect.right - width;
      } else {
        left = initialRect.left;
      }

      if (left < baseOuter.left) left = baseOuter.left;
      if (left + width > screen.width - baseOuter.right) {
        left = screen.width - baseOuter.right - width;
      }

      bool placeAbove = widget.widget.menuAlignment.y < 0;

      if (placeAbove) {
        top = initialRect.top - height - widget.widget.menuOffset;
        if (top < viewPadding.top + baseOuter.top) {
          top = initialRect.bottom + widget.widget.menuOffset;
          placeAbove = false;
        }
      } else {
        top = initialRect.bottom + widget.widget.menuOffset;
        if (top + height >
            screen.height - viewPadding.bottom - baseOuter.bottom) {
          top = initialRect.top - height - widget.widget.menuOffset;
          placeAbove = true;
        }
      }

      overflowAlignment = Alignment(
        widget.widget.menuAlignment.x,
        placeAbove ? 1.0 : -1.0,
      );
    } else {
      if (widget.widget.maxWidth != null && width > widget.widget.maxWidth!) {
        double xInset = (width - widget.widget.maxWidth!) / 2;
        left += xInset;
        width = widget.widget.maxWidth!;
      }

      double clampedHeight = height;
      if (widget.widget._sheetMaxHeightFraction != null) {
        clampedHeight = clampedHeight.clamp(
          0.0,
          screen.height * widget.widget._sheetMaxHeightFraction!,
        );
      }
      if (widget.widget._sheetMaxHeight != null) {
        clampedHeight = clampedHeight.clamp(
          0.0,
          widget.widget._sheetMaxHeight!,
        );
      }

      if (clampedHeight < height) {
        top =
            screen.height -
            baseOuter.bottom -
            (widget.widget.useSafeArea ? viewPadding.bottom : 0) -
            clampedHeight;
        height = clampedHeight;
      }
    }

    final Rect finalRect = Rect.fromLTWH(left, top, width, height);
    final Size finalSize = Size(width, height);

    double effectiveDismissThreshold = widget.widget.dragDismissThreshold;
    if (widget.widget._sheetDragDismissThresholdFraction != null) {
      effectiveDismissThreshold =
          height * widget.widget._sheetDragDismissThresholdFraction!;
    }

    final Animation<double> fadeAnim = routeAnim.drive(
      CurveTween(curve: widget.widget.fadeInterval),
    );
    final Animation<double> contentFade = routeAnim.drive(
      CurveTween(curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)),
    );
    final Animation<double> contentScale = routeAnim.drive(
      Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
    );

    Widget scrim =
        widget.widget.scrimBuilder?.call(context, fadeAnim) ??
        FadeTransition(
          opacity: fadeAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.widget.barrierDismissible ? _close : null,
            child: Container(color: widget.widget.overlayBackgroundColor),
          ),
        );

    if (widget.widget.blurSigma > 0) {
      scrim = AnimatedBuilder(
        animation: fadeAnim,
        builder: (context, child) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.widget.blurSigma * fadeAnim.value,
            sigmaY: widget.widget.blurSigma * fadeAnim.value,
          ),
          child: child,
        ),
        child: scrim,
      );
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(child: scrim),
          AnimatedBuilder(
            animation: routeAnim,
            builder: (context, child) {
              final t = widget.widget.animationCurve.transform(routeAnim.value);
              final Rect rect = Rect.lerp(initialRect, finalRect, t)!;
              final double dragOffset = _dragDy > 0 ? _dragDy : 0;

              return Positioned(
                left: rect.left,
                top: rect.top + dragOffset,
                width: rect.width,
                height: rect.height,
                child: RistoDecorator(
                  backgroundColor: widget.widget.backgroundColor,
                  backgroundGradient: widget.widget.backgroundGradient,
                  borderColor: widget.widget.borderColor,
                  borderWidth: widget.widget.borderWidth,
                  borderRadius: widget.widget.borderRadius,
                  elevation: widget.widget.elevation,
                  shadowColor: widget.widget.shadowColor,
                  clipBehavior: widget.widget.clipBehavior,
                  child: GestureDetector(
                    onVerticalDragUpdate: widget.widget.enableDragToDismiss
                        ? (details) => setState(() {
                            _dragDy += details.delta.dy;
                            if (_dragDy < 0) _dragDy = 0;
                          })
                        : null,
                    onVerticalDragEnd: widget.widget.enableDragToDismiss
                        ? (_) {
                            if (_dragDy >= effectiveDismissThreshold) {
                              _close();
                            } else {
                              setState(() => _dragDy = 0);
                            }
                          }
                        : null,
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: overflowAlignment,
                        minWidth: finalSize.width,
                        maxWidth: finalSize.width,
                        minHeight: finalSize.height,
                        maxHeight: finalSize.height,
                        child: FadeTransition(
                          opacity: contentFade,
                          child: ScaleTransition(
                            scale: contentScale,
                            alignment: overflowAlignment,
                            child: Padding(
                              padding: innerPad,
                              child: widget.widget.expandedBuilder(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.widget.headerMode == HeaderMode.overlay &&
              widget.widget._type != CardType.menu)
            Positioned(
              left: left,
              right: screen.width - left - width,
              top: widget.widget.useSafeArea ? viewPadding.top : 0,
              height: widget.widget.headerHeight,
              child: FadeTransition(
                opacity: fadeAnim,
                child: (widget.widget.headerBuilder != null)
                    ? widget.widget.headerBuilder!(context, _close)
                    : _buildDefaultHeader(context),
              ),
            ),
        ],
      ),
    );
  }
}
