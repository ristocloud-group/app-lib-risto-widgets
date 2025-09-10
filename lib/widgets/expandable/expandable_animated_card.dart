import 'package:flutter/material.dart';

import '../layouts/size_reporting_widget.dart';

enum HeaderMode { overlay, none }

enum CardType { normal, fullscreen, sheet }

/// Controller opzionale per apertura/chiusura programmatica.
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

  // Decoration
  final BoxDecoration expandedDecoration;

  // Header
  final HeaderMode headerMode;
  final double headerHeight;
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  // Background scrim (inside overlay)
  final Color overlayBackgroundColor;
  final Widget Function(BuildContext, Animation<double>)? scrimBuilder;

  // Route barrier (outside page builder)
  /// Color used by the route barrier (NOT the scrim). Default: fully transparent.
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

  // --- Sheet-only (optional) ---
  final double? _sheetMaxHeight;
  final double? _sheetMaxHeightFraction;
  final double? _sheetDragDismissThresholdFraction;

  // Navigation
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final String? barrierLabel;

  // Visual
  final Clip clipBehavior;

  // Control
  final ExpandableAnimatedCardController? controller;
  final bool autoOpenOnTap;

  // Tipo privato impostato dai factory
  final CardType _type;

  /// Public (free) constructor — allows full customization.
  factory ExpandableAnimatedCard({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Curve animationCurve = Curves.easeInOut,
    Interval fadeInterval =
        const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
    EdgeInsetsGeometry expandedMargin =
        const EdgeInsets.fromLTRB(16, 16, 16, 16),
    EdgeInsetsGeometry expandedPadding = const EdgeInsets.all(0),
    double? maxWidth,
    bool useSafeArea = true,
    BoxDecoration expandedDecoration = const BoxDecoration(
      color: Color(0xFF5D5D5D),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    HeaderMode headerMode = HeaderMode.overlay,
    double headerHeight = 40.0,
    Color overlayBackgroundColor = Colors.black54,
    Widget Function(BuildContext, Animation<double>)? scrimBuilder,
    Widget Function(BuildContext, VoidCallback)? headerBuilder,

    // Barrier config
    Color barrierColor = Colors.transparent,
    bool barrierDismissible = true,

    // Drag
    bool enableDragToDismiss = false,
    double dragDismissThreshold = 120.0,

    // Hooks
    VoidCallback? onClose,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    ValueChanged<bool>? onStateChanged,

    // Nav
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,

    // Visual
    Clip clipBehavior = Clip.antiAlias,

    // Control
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
      expandedDecoration: expandedDecoration,
      headerMode: headerMode,
      headerHeight: headerHeight,
      overlayBackgroundColor: overlayBackgroundColor,
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
  /// - Full-bleed, no header, no drag-to-dismiss (avoids accidental closes).
  /// - Safe defaults, very limited knobs to prevent config mistakes.
  factory ExpandableAnimatedCard.fullscreen({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    Curve animationCurve = Curves.easeInOut,

    // Scrim + barrier
    Color overlayBackgroundColor = Colors.black54,
    Color barrierColor = Colors.transparent,
    bool barrierDismissible = true,

    // Nav
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
  }) {
    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,
      // animations (limited)
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      fadeInterval: const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
      // layout
      expandedMargin: EdgeInsets.zero,
      expandedPadding: EdgeInsets.zero,
      maxWidth: null,
      useSafeArea: false,
      // decoration
      expandedDecoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.zero,
      ),
      // header & scrim
      headerMode: HeaderMode.none,
      headerHeight: 0,
      overlayBackgroundColor: overlayBackgroundColor,
      scrimBuilder: null,
      headerBuilder: null,

      // barrier
      barrierColor: barrierColor,

      // UX
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: false,
      // locked
      dragDismissThreshold: 9999,
      // irrelevant

      // hooks
      onClose: null,
      onOpened: null,
      onClosed: null,
      onStateChanged: null,

      // nav
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,

      // visual
      clipBehavior: Clip.hardEdge,
      controller: null,
      autoOpenOnTap: true,
      type: CardType.fullscreen,
    );
  }

  /// Factory: sheet
  /// - Rounded card + shadow.
  /// - No header. Close is via drag or internal controls.
  /// - Supports clamped height like modal bottom sheet.
  factory ExpandableAnimatedCard.sheet({
    Key? key,
    required WidgetBuilder collapsedBuilder,
    required WidgetBuilder expandedBuilder,

    // Look & feel
    double corner = 20,
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    Color color = const Color(0xFF5D5D5D),
    List<BoxShadow> shadow = const [
      BoxShadow(blurRadius: 24, offset: Offset(0, 8), color: Colors.black26),
    ],

    // Clamp / thresholds
    double? maxHeight, // pixel cap
    double? maxHeightFraction, // 0..1 of screen height
    double? dragDismissThresholdFraction, // 0..1 of final height

    // Scrim + barrier
    Color overlayBackgroundColor = Colors.black54,
    Color barrierColor = Colors.transparent,

    // UX
    bool dragToClose = true,
    double dragDismissThreshold = 120.0, // fallback when fraction not provided
    bool barrierDismissible = true,

    // Nav
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    String? barrierLabel,
  }) {
    assert(maxHeight == null || maxHeight > 0);
    assert(maxHeightFraction == null ||
        (maxHeightFraction > 0 && maxHeightFraction <= 1));
    assert(dragDismissThresholdFraction == null ||
        (dragDismissThresholdFraction > 0 &&
            dragDismissThresholdFraction <= 1));

    return ExpandableAnimatedCard._internal(
      key: key,
      collapsedBuilder: collapsedBuilder,
      expandedBuilder: expandedBuilder,

      expandedMargin: margin,
      expandedPadding: EdgeInsets.zero,
      maxWidth: null,
      useSafeArea: false,
      expandedDecoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(corner),
        boxShadow: shadow,
      ),

      headerMode: HeaderMode.none,
      headerHeight: 0,
      headerBuilder: null,

      // scrim + barrier
      overlayBackgroundColor: overlayBackgroundColor,
      scrimBuilder: null,
      barrierColor: barrierColor,

      // UX
      barrierDismissible: barrierDismissible,
      enableDragToDismiss: dragToClose,
      dragDismissThreshold: dragDismissThreshold,

      // animation
      animationDuration: const Duration(milliseconds: 500),
      animationCurve: Curves.easeInOut,
      fadeInterval: const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),

      // hooks & nav
      onClose: null,
      onOpened: null,
      onClosed: null,
      onStateChanged: null,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierLabel: barrierLabel,
      clipBehavior: Clip.antiAlias,
      controller: null,
      autoOpenOnTap: true,
      type: CardType.sheet,
    )._withSheetClamp(
      maxHeight: maxHeight,
      maxHeightFraction: maxHeightFraction,
      dragDismissThresholdFraction: dragDismissThresholdFraction,
    );
  }

  const ExpandableAnimatedCard._internal({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
    this.fadeInterval =
        const Interval(0.35, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
    this.expandedMargin = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.expandedPadding = const EdgeInsets.all(0),
    this.maxWidth,
    this.useSafeArea = true,
    this.expandedDecoration = const BoxDecoration(
      color: Color(0xFF5D5D5D),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    this.headerMode = HeaderMode.overlay,
    this.headerHeight = 40.0,

    // scrim + barrier
    this.overlayBackgroundColor = Colors.black54,
    this.scrimBuilder,
    this.barrierColor = Colors.transparent,

    // header
    this.headerBuilder,

    // UX
    this.barrierDismissible = true,
    this.enableDragToDismiss = true,
    this.dragDismissThreshold = 120.0,

    // hooks
    this.onClose,
    this.onOpened,
    this.onClosed,
    this.onStateChanged,

    // nav
    this.useRootNavigator = false,
    this.routeSettings,
    this.barrierLabel,

    // visual
    this.clipBehavior = Clip.antiAlias,

    // control
    this.controller,
    this.autoOpenOnTap = true,

    // internals
    required CardType type,
    double? sheetMaxHeight,
    double? sheetMaxHeightFraction,
    double? sheetDragDismissThresholdFraction,
  })  : _type = type,
        _sheetMaxHeight = sheetMaxHeight,
        _sheetMaxHeightFraction = sheetMaxHeightFraction,
        _sheetDragDismissThresholdFraction = sheetDragDismissThresholdFraction;

  // convenience to attach sheet clamp values from the factory
  ExpandableAnimatedCard _withSheetClamp({
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
      expandedDecoration: expandedDecoration,
      headerMode: headerMode,
      headerHeight: headerHeight,

      // scrim + barrier
      overlayBackgroundColor: overlayBackgroundColor,
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
      debugPrint(
          "ExpandableAnimatedCard: overlay skipped (size/context missing)");
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
        (widget._type == CardType.sheet) && widget.enableDragToDismiss;

    final overlayWidget = _ExpandableAnimatedOverlay(
      initialRect: initialRect,
      expandedBuilder: widget.expandedBuilder,
      animationCurve: widget.animationCurve,
      fadeInterval: widget.fadeInterval,

      // Layout
      expandedMargin: widget.expandedMargin,
      expandedPadding: widget.expandedPadding,
      expandedDecoration: widget.expandedDecoration,
      maxWidth: widget.maxWidth,
      useSafeArea: widget.useSafeArea,

      // Header
      headerMode: widget.headerMode,
      headerHeight: widget.headerHeight,
      headerBuilder: widget.headerBuilder,

      // Background
      overlayBackgroundColor: widget.overlayBackgroundColor,
      scrimBuilder: widget.scrimBuilder,

      // UX
      barrierDismissible: widget.barrierDismissible,
      enableDragToDismiss: canDrag,
      dragDismissThreshold: widget.dragDismissThreshold,

      // Hooks
      onClose: widget.onClose,
      onOpened: widget.onOpened,
      onClosed: widget.onClosed,
      onStateChanged: widget.onStateChanged,

      // Visual
      clipBehavior: widget.clipBehavior,

      // Sheet clamp
      sheetMaxHeight:
          (widget._type == CardType.sheet) ? widget._sheetMaxHeight : null,
      sheetMaxHeightFraction: (widget._type == CardType.sheet)
          ? widget._sheetMaxHeightFraction
          : null,
      sheetDragDismissThresholdFraction: (widget._type == CardType.sheet)
          ? widget._sheetDragDismissThresholdFraction
          : null,
    );

    final route = PageRouteBuilder(
      settings: widget.routeSettings,
      opaque: false,
      barrierDismissible: false,
      // scrim handles taps
      barrierColor: widget.barrierColor,
      // <-- customizable
      barrierLabel: widget.barrierLabel,
      transitionDuration: widget.animationDuration,
      reverseTransitionDuration: widget.animationDuration,
      pageBuilder: (_, __, ___) => overlayWidget,
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

  // Layout
  final EdgeInsetsGeometry expandedMargin;
  final EdgeInsetsGeometry expandedPadding;
  final BoxDecoration expandedDecoration;
  final double? maxWidth;
  final bool useSafeArea;

  final double? sheetMaxHeight; // px
  final double? sheetMaxHeightFraction; // 0..1
  final double? sheetDragDismissThresholdFraction; // 0..1

  // Content
  final WidgetBuilder expandedBuilder;

  // Animations
  final Curve animationCurve;
  final Interval fadeInterval;

  // Header
  final HeaderMode headerMode;
  final double headerHeight;
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  // Background (scrim inside overlay)
  final Color overlayBackgroundColor;
  final Widget Function(BuildContext, Animation<double>)? scrimBuilder;

  // UX
  final bool barrierDismissible;
  final bool enableDragToDismiss;
  final double dragDismissThreshold;

  // Hooks
  final VoidCallback? onClose;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final ValueChanged<bool>? onStateChanged;

  // Visual
  final Clip clipBehavior;

  const _ExpandableAnimatedOverlay({
    required this.initialRect,
    required this.expandedBuilder,
    required this.animationCurve,
    required this.fadeInterval,
    required this.expandedMargin,
    required this.expandedPadding,
    required this.expandedDecoration,
    required this.maxWidth,
    required this.useSafeArea,
    required this.headerMode,
    required this.headerHeight,
    required this.headerBuilder,
    required this.overlayBackgroundColor,
    required this.scrimBuilder,
    required this.barrierDismissible,
    required this.enableDragToDismiss,
    required this.dragDismissThreshold,
    required this.onClose,
    required this.onOpened,
    required this.onClosed,
    required this.onStateChanged,
    required this.clipBehavior,
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
    // onClose is fired in the status listener on dismissed.
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onOpened?.call();
      widget.onStateChanged?.call(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onClosed?.call();
      widget.onClose?.call(); // BC hook
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

    // Resolve directional margins/paddings safely
    final EdgeInsets baseOuter = widget.expandedMargin.resolve(dir);
    final EdgeInsets innerPad = widget.expandedPadding.resolve(dir);

    // Final rect (where the card ends up)
    double left = baseOuter.left;
    double top = baseOuter.top +
        (widget.headerMode == HeaderMode.overlay ? widget.headerHeight : 0);
    double width = screen.width - baseOuter.left - baseOuter.right;
    double height = screen.height - top - baseOuter.bottom;

    // Safe areas
    if (widget.useSafeArea) {
      left += viewPadding.left;
      top += viewPadding.top;
      width -= (viewPadding.left + viewPadding.right);
      height -= (viewPadding.bottom);
    }

    // Max width centering (e.g., tablets)
    double xInset = 0;
    if (widget.maxWidth != null && width > widget.maxWidth!) {
      xInset = (width - widget.maxWidth!) / 2;
      left += xInset;
      width = widget.maxWidth!;
    }

    // Clamp height for sheet if requested
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

    // If clamped, recompute top so we keep bottom margin and stop at the cap
    if (clampedHeight < height) {
      final double bottom = baseOuter.bottom + (widget.useSafeArea ? 0 : 0);
      top = screen.height - bottom - clampedHeight;
      height = clampedHeight;
    }

    final Rect finalRect = Rect.fromLTWH(left, top, width, height);
    final Rect initialRect = widget.initialRect;

    double effectiveDismissThreshold = widget.dragDismissThreshold;
    if (widget.sheetDragDismissThresholdFraction != null) {
      effectiveDismissThreshold =
          height * widget.sheetDragDismissThresholdFraction!;
    }

    final Animation<double> fadeAnim =
        routeAnim.drive(CurveTween(curve: widget.fadeInterval));

    // Scrim (custom or default)
    final Widget scrim = widget.scrimBuilder?.call(context, fadeAnim) ??
        FadeTransition(
          opacity: fadeAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.barrierDismissible ? _close : null,
            child: Container(color: widget.overlayBackgroundColor),
          ),
        );

    // Resolve border radius geometry safely for ClipRRect
    final BorderRadius borderRadius =
        (widget.expandedDecoration.borderRadius ?? BorderRadius.zero)
            .resolve(dir);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background scrim + outside tap to dismiss
          Positioned.fill(child: scrim),

          // Animated card
          AnimatedBuilder(
            animation: routeAnim,
            builder: (context, child) {
              final t = widget.animationCurve.transform(routeAnim.value);
              final Rect rect = Rect.lerp(initialRect, finalRect, t)!;

              // Apply drag offset on top of animation (only downward)
              final double dragOffset = _dragDy > 0 ? _dragDy : 0;

              return Positioned(
                left: rect.left,
                top: rect.top + dragOffset,
                width: rect.width,
                height: rect.height,
                child: child!,
              );
            },
            child: ClipRRect(
              clipBehavior: widget.clipBehavior,
              borderRadius: borderRadius,
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
                child: Container(
                  decoration: widget.expandedDecoration,
                  padding: innerPad,
                  child: widget.expandedBuilder(context),
                ),
              ),
            ),
          ),

          // Header overlay (optional)
          if (widget.headerMode == HeaderMode.overlay)
            Positioned(
              left: xInset == 0 ? 0 : xInset,
              right: xInset == 0 ? 0 : xInset,
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

/// Helper per ottenere i padding di sistema anche su API Flutter diverse.
class MediaWidgetPadding {
  static EdgeInsets viewPaddingOf(BuildContext context) {
    try {
      return MediaQuery.viewPaddingOf(context);
    } catch (_) {
      return MediaQuery.of(context).viewPadding;
    }
  }
}
