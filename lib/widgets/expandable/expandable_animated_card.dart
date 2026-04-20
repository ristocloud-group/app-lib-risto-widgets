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
  // Content
  final WidgetBuilder collapsedBuilder;
  final WidgetBuilder expandedBuilder;

  // Animation
  final Duration animationDuration;
  final Curve animationCurve;
  final Interval fadeInterval;

  // Layout & sizing
  final EdgeInsetsGeometry expandedMargin;
  final EdgeInsetsGeometry expandedPadding;
  final double? maxWidth;
  final bool useSafeArea;

  // RistoDecorator Styling
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final double elevation;
  final Color? shadowColor;

  // Header
  final HeaderMode headerMode;
  final double headerHeight;
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  // Background scrim & Blur
  final Color overlayBackgroundColor;
  final double blurSigma;
  final Widget Function(BuildContext, Animation<double>)? scrimBuilder;

  // Route barrier
  final Color barrierColor;

  // UX toggles
  final bool barrierDismissible;
  final bool enableDragToDismiss;
  final double dragDismissThreshold;

  // Hooks
  final VoidCallback? onClose;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final ValueChanged<bool>? onStateChanged;

  // Sheet/Menu-only limits
  final double? _sheetMaxHeight;
  final double? _sheetMaxHeightFraction;
  final double? _sheetDragDismissThresholdFraction;
  final double menuOffset;

  // Navigation
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final String? barrierLabel;

  // Visual
  final Clip clipBehavior;

  // Control
  final ExpandableAnimatedCardController? controller;
  final bool autoOpenOnTap;

  final CardType _type;

  /// Public constructor — allows full customization.
  factory ExpandableAnimatedCard({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Curve animationCurve = Curves.easeInOutCubic,
    Interval fadeInterval = const Interval(
      0.35,
      1.0,
      curve: Cubic(0.5, 0.0, 0.3, 1.0),
    ),
    EdgeInsetsGeometry expandedMargin = const EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16,
    ),
    EdgeInsetsGeometry expandedPadding = const EdgeInsets.all(0),
    double? maxWidth,
    bool useSafeArea = true,
    Color? backgroundColor = const Color(0xFF5D5D5D),
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    BorderRadiusGeometry? borderRadius = const BorderRadius.all(
      Radius.circular(20),
    ),
    double elevation = 4.0,
    Color? shadowColor,
    HeaderMode headerMode = HeaderMode.overlay,
    double headerHeight = 40.0,
    Color overlayBackgroundColor = Colors.black54,
    double blurSigma = 0.0,
    Widget Function(BuildContext, Animation<double>)? scrimBuilder,
    Widget Function(BuildContext, VoidCallback)? headerBuilder,
    Color barrierColor = Colors.transparent,
    bool barrierDismissible = true,
    bool enableDragToDismiss = false,
    double dragDismissThreshold = 120.0,
    VoidCallback? onClose,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    ValueChanged<bool>? onStateChanged,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
    Clip clipBehavior = Clip.antiAlias,
    ExpandableAnimatedCardController? controller,
    bool autoOpenOnTap = true,
  }) {
    assert(
      headerMode != HeaderMode.none || headerBuilder == null,
      'headerBuilder is ignored when headerMode == HeaderMode.none',
    );
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      fadeInterval: fadeInterval,
      expandedMargin: expandedMargin,
      expandedPadding: expandedPadding,
      maxWidth: maxWidth,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      headerMode: headerMode,
      headerHeight: headerHeight,
      overlayBackgroundColor: overlayBackgroundColor,
      blurSigma: blurSigma,
      scrimBuilder: scrimBuilder,
      headerBuilder: headerBuilder,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: enableDragToDismiss,
      dragDismissThreshold: dragDismissThreshold,
      onClose: onClose,
      onOpened: onOpened,
      onClosed: onClosed,
      onStateChanged: onStateChanged,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: clipBehavior,
      controller: controller,
      autoOpenOnTap: autoOpenOnTap,
      type: CardType.normal,
    );
  }

  /// Factory: fullscreen
  factory ExpandableAnimatedCard.fullscreen({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Curve animationCurve = Curves.easeInOutCubic,
    Color overlayBackgroundColor = Colors.black54,
    double blurSigma = 0.0,
    Color barrierColor = Colors.transparent,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
  }) {
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      fadeInterval: const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
      expandedMargin: EdgeInsets.zero,
      expandedPadding: EdgeInsets.zero,
      maxWidth: null,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      borderRadius: BorderRadius.zero,
      headerMode: HeaderMode.none,
      headerHeight: 0,
      overlayBackgroundColor: overlayBackgroundColor,
      blurSigma: blurSigma,
      scrimBuilder: null,
      headerBuilder: null,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: false,
      dragDismissThreshold: 9999,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: Clip.none,
      type: CardType.fullscreen,
    );
  }

  /// Factory: sheet
  factory ExpandableAnimatedCard.sheet({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    double corner = 20,
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    Color backgroundColor = const Color(0xFF5D5D5D),
    double elevation = 8.0,
    Color? shadowColor,
    double? maxHeight,
    double? maxHeightFraction,
    double? dragDismissThresholdFraction,
    Color overlayBackgroundColor = Colors.black54,
    double blurSigma = 0.0,
    Color barrierColor = Colors.transparent,
    bool dragToClose = true,
    double dragDismissThreshold = 120.0,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
  }) {
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      expandedMargin: margin,
      expandedPadding: EdgeInsets.zero,
      maxWidth: null,
      useSafeArea: false,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      borderRadius: BorderRadius.circular(corner),
      headerMode: HeaderMode.none,
      headerHeight: 0,
      headerBuilder: null,
      overlayBackgroundColor: overlayBackgroundColor,
      blurSigma: blurSigma,
      scrimBuilder: null,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: dragToClose,
      dragDismissThreshold: dragDismissThreshold,
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeInOutCubic,
      fadeInterval: const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: Clip.antiAlias,
      type: CardType.sheet,
    )._withLimits(
      maxHeight: maxHeight,
      maxHeightFraction: maxHeightFraction,
      dragDismissThresholdFraction: dragDismissThresholdFraction,
    );
  }

  /// Factory: menu (Anchors above or below the caller)
  factory ExpandableAnimatedCard.menu({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    double corner = 16,
    Color backgroundColor = Colors.white,
    double elevation = 8.0,
    Color? shadowColor,
    double menuWidth = 250.0,
    double menuHeight = 300.0,
    double menuOffset = 16.0,
    Color overlayBackgroundColor = Colors.black12,
    double blurSigma = 0.0,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
  }) {
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      expandedMargin: const EdgeInsets.all(16),
      expandedPadding: EdgeInsets.zero,
      maxWidth: menuWidth,
      useSafeArea: true,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      borderRadius: BorderRadius.circular(corner),
      headerMode: HeaderMode.none,
      headerHeight: 0,
      headerBuilder: null,
      overlayBackgroundColor: overlayBackgroundColor,
      blurSigma: blurSigma,
      scrimBuilder: null,
      barrierColor: Colors.transparent,
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: false,
      dragDismissThreshold: 9999,
      animationDuration: const Duration(milliseconds: 350),
      animationCurve: Curves.easeOutCubic,
      fadeInterval: const Interval(0.0, 1.0, curve: Curves.easeOut),
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: Clip.antiAlias,
      type: CardType.menu,
      menuOffset: menuOffset,
    )._withLimits(maxHeight: menuHeight);
  }

  const ExpandableAnimatedCard._internal({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
    this.fadeInterval = const Interval(
      0.35,
      1.0,
      curve: Cubic(0.5, 0.0, 0.3, 1.0),
    ),
    this.expandedMargin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.expandedPadding = const EdgeInsets.all(0),
    this.maxWidth,
    this.useSafeArea = true,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.elevation = 0.0,
    this.shadowColor,
    this.headerMode = HeaderMode.overlay,
    this.headerHeight = 40.0,
    this.overlayBackgroundColor = Colors.black54,
    this.blurSigma = 0.0,
    this.scrimBuilder,
    this.barrierColor = Colors.transparent,
    this.headerBuilder,
    this.barrierDismissible = true,
    this.enableDragToDismiss = true,
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
    required CardType type,
    this.menuOffset = 16.0,
    double? sheetMaxHeight,
    double? sheetMaxHeightFraction,
    double? sheetDragDismissThresholdFraction,
  }) : _type = type,
       _sheetMaxHeight = sheetMaxHeight,
       _sheetMaxHeightFraction = sheetMaxHeightFraction,
       _sheetDragDismissThresholdFraction = sheetDragDismissThresholdFraction;

  ExpandableAnimatedCard _withLimits({
    double? maxHeight,
    double? maxHeightFraction,
    double? dragDismissThresholdFraction,
  }) {
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      fadeInterval: fadeInterval,
      expandedMargin: expandedMargin,
      expandedPadding: expandedPadding,
      maxWidth: maxWidth,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      headerMode: headerMode,
      headerHeight: headerHeight,
      overlayBackgroundColor: overlayBackgroundColor,
      blurSigma: blurSigma,
      scrimBuilder: scrimBuilder,
      barrierColor: barrierColor,
      headerBuilder: headerBuilder,
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: enableDragToDismiss,
      dragDismissThreshold: dragDismissThreshold,
      onClose: onClose,
      onOpened: onOpened,
      onClosed: onClosed,
      onStateChanged: onStateChanged,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: clipBehavior,
      controller: controller,
      autoOpenOnTap: autoOpenOnTap,
      type: _type,
      menuOffset: menuOffset,
      sheetMaxHeight: maxHeight,
      sheetMaxHeightFraction: maxHeightFraction,
      sheetDragDismissThresholdFraction: dragDismissThresholdFraction,
    );
  }

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
    final bool canDrag =
        widget._type == CardType.sheet && widget.enableDragToDismiss;

    final overlayWidget = _ExpandableAnimatedOverlay(
      initialRect: initialRect,
      expandedBuilder: widget.expandedBuilder,
      animationCurve: widget.animationCurve,
      fadeInterval: widget.fadeInterval,
      expandedMargin: widget.expandedMargin,
      expandedPadding: widget.expandedPadding,
      backgroundColor: widget.backgroundColor,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      borderRadius: widget.borderRadius,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      maxWidth: widget.maxWidth,
      useSafeArea: widget.useSafeArea,
      headerMode: widget.headerMode,
      headerHeight: widget.headerHeight,
      headerBuilder: widget.headerBuilder,
      overlayBackgroundColor: widget.overlayBackgroundColor,
      blurSigma: widget.blurSigma,
      scrimBuilder: widget.scrimBuilder,
      barrierDismissible: widget.barrierDismissible,
      enableDragToDismiss: canDrag,
      dragDismissThreshold: widget.dragDismissThreshold,
      onClose: widget.onClose,
      onOpened: widget.onOpened,
      onClosed: widget.onClosed,
      onStateChanged: widget.onStateChanged,
      clipBehavior: widget.clipBehavior,
      type: widget._type,
      menuOffset: widget.menuOffset,
      sheetMaxHeight: widget._sheetMaxHeight,
      sheetMaxHeightFraction: widget._sheetMaxHeightFraction,
      sheetDragDismissThresholdFraction:
          widget._sheetDragDismissThresholdFraction,
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
  final EdgeInsetsGeometry expandedMargin;
  final EdgeInsetsGeometry expandedPadding;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final double elevation;
  final Color? shadowColor;
  final double? maxWidth;
  final bool useSafeArea;
  final CardType type;
  final double menuOffset;
  final double? sheetMaxHeight;
  final double? sheetMaxHeightFraction;
  final double? sheetDragDismissThresholdFraction;
  final WidgetBuilder expandedBuilder;
  final Curve animationCurve;
  final Interval fadeInterval;
  final HeaderMode headerMode;
  final double headerHeight;
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;
  final Color overlayBackgroundColor;
  final double blurSigma;
  final Widget Function(BuildContext, Animation<double>)? scrimBuilder;
  final bool barrierDismissible;
  final bool enableDragToDismiss;
  final double dragDismissThreshold;
  final VoidCallback? onClose;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final ValueChanged<bool>? onStateChanged;
  final Clip clipBehavior;

  const _ExpandableAnimatedOverlay({
    required this.initialRect,
    required this.expandedBuilder,
    required this.animationCurve,
    required this.fadeInterval,
    required this.expandedMargin,
    required this.expandedPadding,
    required this.maxWidth,
    required this.useSafeArea,
    required this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    required this.borderWidth,
    this.borderRadius,
    required this.elevation,
    this.shadowColor,
    required this.headerMode,
    required this.headerHeight,
    required this.headerBuilder,
    required this.overlayBackgroundColor,
    required this.blurSigma,
    required this.scrimBuilder,
    required this.barrierDismissible,
    required this.enableDragToDismiss,
    required this.dragDismissThreshold,
    required this.onClose,
    required this.onOpened,
    required this.onClosed,
    required this.onStateChanged,
    required this.clipBehavior,
    required this.type,
    required this.menuOffset,
    this.sheetMaxHeight,
    this.sheetMaxHeightFraction,
    this.sheetDragDismissThresholdFraction,
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
      widget.onOpened?.call();
      widget.onStateChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onClosed?.call();
      widget.onClose?.call();
      widget.onStateChanged?.call(false);
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
        height: widget.headerHeight,
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
    final EdgeInsets viewPadding = MediaWidgetPadding.viewPaddingOf(context);
    final TextDirection dir = Directionality.of(context);

    final EdgeInsets baseOuter = widget.expandedMargin.resolve(dir);
    final EdgeInsets innerPad = widget.expandedPadding.resolve(dir);

    double left = baseOuter.left;
    double top =
        baseOuter.top +
        (widget.headerMode == HeaderMode.overlay ? widget.headerHeight : 0);
    double width = screen.width - baseOuter.left - baseOuter.right;
    double height = screen.height - top - baseOuter.bottom;

    if (widget.useSafeArea) {
      left += viewPadding.left;
      top += viewPadding.top;
      width -= (viewPadding.left + viewPadding.right);
      height -= (viewPadding.bottom);
    }

    final Rect initialRect = widget.initialRect;

    if (widget.type == CardType.menu) {
      width = widget.maxWidth ?? 250.0;
      height = widget.sheetMaxHeight ?? 300.0;

      left = initialRect.center.dx - (width / 2);
      if (left < baseOuter.left) left = baseOuter.left;
      if (left + width > screen.width - baseOuter.right) {
        left = screen.width - baseOuter.right - width;
      }

      top = initialRect.top - height - widget.menuOffset;
      if (top < baseOuter.top + (widget.useSafeArea ? viewPadding.top : 0)) {
        top = initialRect.bottom + widget.menuOffset;
      }
    } else {
      double xInset = 0;
      if (widget.maxWidth != null && width > widget.maxWidth!) {
        xInset = (width - widget.maxWidth!) / 2;
        left += xInset;
        width = widget.maxWidth!;
      }

      double clampedHeight = height;
      if (widget.sheetMaxHeightFraction != null) {
        clampedHeight = clampedHeight.clamp(
          0.0,
          screen.height * widget.sheetMaxHeightFraction!,
        );
      }
      if (widget.sheetMaxHeight != null) {
        clampedHeight = clampedHeight.clamp(0.0, widget.sheetMaxHeight!);
      }

      if (clampedHeight < height) {
        final double bottom = baseOuter.bottom + (widget.useSafeArea ? 0 : 0);
        top = screen.height - bottom - clampedHeight;
        height = clampedHeight;
      }
    }

    final Rect finalRect = Rect.fromLTWH(left, top, width, height);
    final Size finalSize = Size(width, height);

    double effectiveDismissThreshold = widget.dragDismissThreshold;
    if (widget.sheetDragDismissThresholdFraction != null) {
      effectiveDismissThreshold =
          height * widget.sheetDragDismissThresholdFraction!;
    }

    final Animation<double> fadeAnim = routeAnim.drive(
      CurveTween(curve: widget.fadeInterval),
    );

    // Create a delayed fade animation for the content so it only appears as the card opens
    final Animation<double> contentFade = routeAnim.drive(
      CurveTween(curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic)),
    );

    Widget scrim =
        widget.scrimBuilder?.call(context, fadeAnim) ??
        FadeTransition(
          opacity: fadeAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.barrierDismissible ? _close : null,
            child: Container(color: widget.overlayBackgroundColor),
          ),
        );

    if (widget.blurSigma > 0) {
      scrim = AnimatedBuilder(
        animation: fadeAnim,
        builder: (context, child) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurSigma * fadeAnim.value,
              sigmaY: widget.blurSigma * fadeAnim.value,
            ),
            child: child,
          );
        },
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
              final t = widget.animationCurve.transform(routeAnim.value);
              final Rect rect = Rect.lerp(initialRect, finalRect, t)!;
              final double dragOffset = _dragDy > 0 ? _dragDy : 0;

              return Positioned(
                left: rect.left,
                top: rect.top + dragOffset,
                width: rect.width,
                height: rect.height,
                child: RistoDecorator(
                  backgroundColor: widget.backgroundColor,
                  backgroundGradient: widget.backgroundGradient,
                  borderColor: widget.borderColor,
                  borderWidth: widget.borderWidth,
                  borderRadius: widget.borderRadius,
                  elevation: widget.elevation,
                  shadowColor: widget.shadowColor,
                  clipBehavior: widget.clipBehavior,
                  child: GestureDetector(
                    onVerticalDragUpdate: widget.enableDragToDismiss
                        ? (details) => setState(() {
                            _dragDy += details.delta.dy;
                            if (_dragDy < 0) _dragDy = 0;
                          })
                        : null,
                    onVerticalDragEnd: widget.enableDragToDismiss
                        ? (_) {
                            if (_dragDy >= effectiveDismissThreshold) {
                              _close();
                            } else {
                              setState(() => _dragDy = 0); // snap back
                            }
                          }
                        : null,

                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.topCenter,
                        minWidth: finalSize.width,
                        maxWidth: finalSize.width,
                        minHeight: finalSize.height,
                        maxHeight: finalSize.height,
                        child: FadeTransition(
                          opacity: contentFade,
                          // Fade out before closing starts
                          child: Padding(
                            padding: innerPad,
                            child: widget.expandedBuilder(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          if (widget.headerMode == HeaderMode.overlay &&
              widget.type != CardType.menu)
            Positioned(
              left: left,
              right: screen.width - left - width,
              top: widget.useSafeArea ? viewPadding.top : 0,
              height: widget.headerHeight,
              child: FadeTransition(
                opacity: fadeAnim,
                child: (widget.headerBuilder != null)
                    ? widget.headerBuilder!(context, _close)
                    : _buildDefaultHeader(context),
              ),
            ),
        ],
      ),
    );
  }
}

class MediaWidgetPadding {
  static EdgeInsets viewPaddingOf(BuildContext context) {
    try {
      return MediaQuery.viewPaddingOf(context);
    } catch (_) {
      return MediaQuery.of(context).viewPadding;
    }
  }
}
