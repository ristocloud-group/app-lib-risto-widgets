import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../risto_widgets.dart';

/// Enum to internally identify the type of sheet to be built.
enum _SheetType { standard, confirm, scrollable, expandable }

/// A class responsible for displaying customized modal bottom popup.
class OpenCustomSheet {
  final bool barrierDismissible;
  final Color? barrierColor;
  final Function(dynamic)? onClose;
  final Color? backgroundColor;
  final Color? handleColor;
  final ShapeBorder? sheetShape;
  final EdgeInsetsGeometry? sheetPadding;
  final bool enableDrag;
  final bool showDragHandle;

  final bool scrollable;

  /// If true, the sheet forces its layout to fill the screen up to [initialChildSize].
  /// If false, the sheet shrink-wraps to the intrinsic height of its content.
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  final bool showDefaultButtons;
  final Color? firstButtonColor;
  final Color? secondButtonColor;
  final Color? firstButtonTextColor;
  final Color? secondButtonTextColor;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final EdgeInsetsGeometry? padding;
  final double? buttonSpacing;

  final _SheetType _type;
  final Widget Function({ScrollController? scrollController})? _standardBody;
  final Widget? _confirmBody;

  final Widget? _expandableHeader;
  final Widget? _expandableFooter;
  final Widget Function({ScrollController? scrollController})? _expandableBody;
  final ExpandableController? _expandableController;
  final bool _presentAsRoute;

  /// PUBLIC: Standard (non-scrollable) sheet constructor.
  /// For confirm/scrollable/expandable use the dedicated factories.
  const OpenCustomSheet({
    required Widget Function({ScrollController? scrollController}) body,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierColor,
    this.backgroundColor,
    this.handleColor,
    this.sheetShape,
    this.sheetPadding,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.expand = false,
  }) : _type = _SheetType.standard,
       _standardBody = body,
       _confirmBody = null,
       _expandableHeader = null,
       _expandableFooter = null,
       _expandableBody = null,
       _expandableController = null,
       _presentAsRoute = true,
       scrollable = false,
       showDefaultButtons = false,
       firstButtonColor = null,
       secondButtonColor = null,
       firstButtonTextColor = null,
       secondButtonTextColor = null,
       confirmButtonText = null,
       cancelButtonText = null,
       padding = null,
       buttonSpacing = null;

  /// PRIVATE: universal constructor used by factories.
  const OpenCustomSheet._internal({
    required _SheetType type,
    required this.barrierDismissible,
    this.barrierColor,
    required this.enableDrag,
    this.onClose,
    this.backgroundColor,
    this.handleColor,
    this.sheetShape,
    this.sheetPadding,
    this.showDragHandle = true,
    this.scrollable = false,
    this.expand = false,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.showDefaultButtons = false,
    this.firstButtonColor,
    this.secondButtonColor,
    this.firstButtonTextColor,
    this.secondButtonTextColor,
    this.confirmButtonText,
    this.cancelButtonText,
    this.padding,
    this.buttonSpacing,
    Widget Function({ScrollController? scrollController})? standardBody,
    Widget? confirmBody,
    Widget? expandableHeader,
    Widget? expandableFooter,
    Widget Function({ScrollController? scrollController})? expandableBody,
    ExpandableController? expandableController,
    bool presentAsRoute = true,
  }) : _type = type,
       _standardBody = standardBody,
       _confirmBody = confirmBody,
       _expandableHeader = expandableHeader,
       _expandableFooter = expandableFooter,
       _expandableBody = expandableBody,
       _expandableController = expandableController,
       _presentAsRoute = presentAsRoute;

  /// Factory for a simple, non-scrollable confirmation sheet with default buttons.
  factory OpenCustomSheet.openConfirmSheet(
    BuildContext context, {
    required Widget body,
    Function(dynamic)? onClose,
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    String? confirmButtonText,
    String? cancelButtonText,
    EdgeInsetsGeometry? padding,
    double? buttonSpacing,
  }) {
    return OpenCustomSheet._internal(
      type: _SheetType.confirm,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      enableDrag: enableDrag,
      onClose: onClose,
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      showDragHandle: showDragHandle,
      showDefaultButtons: true,
      firstButtonColor: firstButtonColor,
      secondButtonColor: secondButtonColor,
      firstButtonTextColor: firstButtonTextColor,
      secondButtonTextColor: secondButtonTextColor,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      padding: padding,
      buttonSpacing: buttonSpacing,
      confirmBody: body,
    );
  }

  /// Factory for a standard scrollable sheet.
  factory OpenCustomSheet.scrollableSheet(
    BuildContext context, {
    required Widget Function({ScrollController? scrollController}) body,
    Function(dynamic)? onClose,
    bool expand = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    Color? barrierColor,
    Color? backgroundColor,
    Color? handleColor,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    ShapeBorder? sheetShape,
    EdgeInsetsGeometry? sheetPadding,
  }) {
    return OpenCustomSheet._internal(
      type: _SheetType.scrollable,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      enableDrag: enableDrag,
      onClose: onClose,
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      sheetShape: sheetShape,
      sheetPadding: sheetPadding,
      showDragHandle: showDragHandle,
      scrollable: true,
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      standardBody: body,
    );
  }

  /// Factory for an expandable sheet that can behave as a modal route or as an in-route overlay widget.
  factory OpenCustomSheet.expandable(
    BuildContext context, {
    required Widget header,
    required Widget Function({ScrollController? scrollController}) body,
    required Widget footer,
    ExpandableController? controller,
    bool presentAsRoute = true,
    double initialChildSize = 0.3,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    EdgeInsetsGeometry? sheetPadding,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
  }) {
    return OpenCustomSheet._internal(
      type: _SheetType.expandable,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      enableDrag: enableDrag,
      onClose: null,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      sheetPadding: sheetPadding,
      showDragHandle: showDragHandle,
      expandableHeader: header,
      expandableFooter: footer,
      expandableBody: body,
      expandableController: controller,
      presentAsRoute: presentAsRoute,
    );
  }

  /// Displays the configured sheet.
  void show(BuildContext context) {
    if (_type == _SheetType.expandable && !_presentAsRoute) {
      throw Exception(
        'Use buildExpandable(context) when presentAsRoute is false.',
      );
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: barrierDismissible,
      barrierColor: barrierColor,
      isScrollControlled: true,
      useSafeArea: false,
      enableDrag: enableDrag,
      context: context,
      builder: (context) {
        switch (_type) {
          case _SheetType.standard:
            if (!enableDrag) {
              final init = initialChildSize.clamp(minChildSize, maxChildSize);
              return SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    final cap = viewport.maxHeight * init;

                    return Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: expand ? double.infinity : cap,
                      ),
                      height: expand ? cap : null,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: backgroundColor ?? Theme.of(context).cardColor,
                      ),
                      child: Column(
                        mainAxisSize: expand
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (showDragHandle &&
                              handleColor != Colors.transparent)
                            _buildHandle(handleColor),
                          Flexible(
                            fit: expand ? FlexFit.tight : FlexFit.loose,
                            child: SingleChildScrollView(
                              padding:
                                  sheetPadding ??
                                  const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 20,
                                  ),
                              child: _standardBody!(scrollController: null),
                            ),
                          ),
                          if (showDefaultButtons)
                            _buildButtons(
                              context,
                              firstButtonColor,
                              secondButtonColor,
                              firstButtonTextColor,
                              secondButtonTextColor,
                              buttonSpacing,
                              confirmButtonText,
                              cancelButtonText,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              final init = initialChildSize.clamp(minChildSize, maxChildSize);
              return DraggableScrollableSheet(
                expand: expand,
                initialChildSize: init,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: backgroundColor ?? Theme.of(context).cardColor,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: expand
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        children: [
                          if (showDragHandle &&
                              handleColor != Colors.transparent)
                            _buildHandle(handleColor),
                          Flexible(
                            fit: expand ? FlexFit.tight : FlexFit.loose,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding:
                                  sheetPadding ??
                                  const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 20,
                                  ),
                              child: _standardBody!(
                                scrollController: scrollController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

          case _SheetType.confirm:
            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: backgroundColor ?? Theme.of(context).cardColor,
                ),
                padding: padding ?? const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDragHandle && handleColor != Colors.transparent)
                      _buildHandle(handleColor),
                    Flexible(
                      child: SingleChildScrollView(
                        padding:
                            sheetPadding ??
                            const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                        child: _confirmBody!,
                      ),
                    ),
                    if (showDefaultButtons)
                      _buildButtons(
                        context,
                        firstButtonColor,
                        secondButtonColor,
                        firstButtonTextColor,
                        secondButtonTextColor,
                        buttonSpacing,
                        confirmButtonText,
                        cancelButtonText,
                      ),
                  ],
                ),
              ),
            );

          case _SheetType.scrollable:
            return DraggableScrollableSheet(
              expand: expand,
              initialChildSize: initialChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: backgroundColor ?? Theme.of(context).cardColor,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: expand
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      children: [
                        if (handleColor != Colors.transparent)
                          _buildHandle(handleColor),
                        Flexible(
                          fit: expand ? FlexFit.tight : FlexFit.loose,
                          child: Padding(
                            padding: sheetPadding ?? EdgeInsets.zero,
                            child: _standardBody!(
                              scrollController: scrollController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          case _SheetType.expandable:
            return _ExpandableSheet(
              backgroundColor: backgroundColor,
              handleColor: handleColor,
              sheetPadding: sheetPadding,
              showDragHandle: showDragHandle,
              header: _expandableHeader!,
              bodyBuilder: _expandableBody!,
              footer: _expandableFooter!,
              controller: _expandableController ?? ExpandableController(),
              minChildSize: minChildSize,
              initialChildSize: initialChildSize,
              maxChildSize: maxChildSize,
              onDismiss: () => Navigator.of(context).maybePop(),
            );
        }
      },
    ).then((value) => onClose?.call(value));
  }

  /// Builds the expandable widget for in-route usage (inside a Stack).
  /// Use this when the factory was created with `presentAsRoute: false`.
  Widget buildExpandable(BuildContext context) {
    if (_type != _SheetType.expandable) {
      throw Exception(
        'buildExpandable() is only available for expandable popup.',
      );
    }
    return _ExpandableSheet(
      backgroundColor: backgroundColor,
      handleColor: handleColor,
      sheetPadding: sheetPadding,
      header: _expandableHeader!,
      bodyBuilder: _expandableBody!,
      footer: _expandableFooter!,
      controller: _expandableController ?? ExpandableController(),
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      onDismiss: onClose == null ? null : () => onClose!(null),
    );
  }

  static Widget _buildButtons(
    BuildContext context,
    Color? firstButtonColor,
    Color? secondButtonColor,
    Color? firstButtonTextColor,
    Color? secondButtonTextColor,
    double? buttonSpacing,
    String? confirmButtonText,
    String? cancelButtonText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DoubleListTileButtons(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        space: buttonSpacing ?? 8,
        firstButton: CustomActionButton.flat(
          margin: EdgeInsets.zero,
          width: double.infinity,
          onPressed: () => Navigator.pop(context, false),
          backgroundColor: firstButtonColor ?? Colors.red,
          child: Text(
            cancelButtonText ?? 'Close',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: firstButtonTextColor ?? Colors.white,
            ),
          ),
        ),
        secondButton: CustomActionButton.flat(
          onPressed: () => Navigator.pop(context, true),
          margin: EdgeInsets.zero,
          width: double.infinity,
          backgroundColor: secondButtonColor ?? Colors.green,
          child: Text(
            confirmButtonText ?? 'Confirm',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: secondButtonTextColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildHandle(Color? handleColor) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: handleColor ?? Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

/// Internal widget implementing the expandable behavior with snap-to-states,
/// coordinated scroll, and header/footer always visible when collapsed.
class _ExpandableSheet extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color? backgroundColor;
  final Color? handleColor;
  final EdgeInsetsGeometry? sheetPadding;
  final bool showDragHandle;
  final Widget header;
  final Widget footer;
  final Widget Function({ScrollController? scrollController}) bodyBuilder;
  final ExpandableController controller;
  final VoidCallback? onDismiss;

  const _ExpandableSheet({
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    this.backgroundColor,
    this.handleColor,
    this.sheetPadding,
    this.showDragHandle = true,
    required this.header,
    required this.bodyBuilder,
    required this.footer,
    required this.controller,
    this.onDismiss,
  });

  @override
  State<_ExpandableSheet> createState() => _ExpandableSheetState();
}

class _ExpandableSheetState extends State<_ExpandableSheet> {
  final DraggableScrollableController _dragCtrl =
      DraggableScrollableController();
  late final ScrollController _bodyScrollCtrl;

  bool _snapping = false;
  bool _didInitSnap = false;

  bool? _dragStartExpanded;
  double? _dragStartExtent;

  double _footerHeight = 0.0;
  double _headerHeight = 0.0;

  static const double _snapThresholdFraction = 0.20;

  double get _expandedSize => widget.maxChildSize;

  double get _handleHeight =>
      (widget.showDragHandle && widget.handleColor != Colors.transparent)
      ? (4.0 + 16.0)
      : 0.0;

  double get _verticalSheetPadding {
    final p = widget.sheetPadding;
    if (p is EdgeInsets) return p.vertical;
    return 0.0;
  }

  double _minCollapsedExtent(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final neededPx =
        _handleHeight + _headerHeight + _footerHeight + _verticalSheetPadding;
    if (screenH <= 0) return widget.initialChildSize;
    final frac = (neededPx / screenH).clamp(0.0, 1.0);
    return frac.clamp(widget.minChildSize, widget.maxChildSize);
  }

  double _collapsedTarget(BuildContext context) {
    final minNeeded = _minCollapsedExtent(context);
    return (widget.initialChildSize >= minNeeded)
        ? widget.initialChildSize
        : minNeeded;
  }

  @override
  void initState() {
    super.initState();
    _bodyScrollCtrl = ScrollController();
    _dragCtrl.addListener(_onDrag);
    widget.controller.addListener(_onControllerChange);

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeInitSnap());
  }

  @override
  void dispose() {
    _dragCtrl.removeListener(_onDrag);
    widget.controller.removeListener(_onControllerChange);
    _bodyScrollCtrl.dispose();
    _dragCtrl.dispose();
    super.dispose();
  }

  void _onHeaderSize(Size s) {
    if ((_headerHeight - s.height).abs() > 0.5) {
      _headerHeight = s.height;
      _coerceExtentAfterMeasure();
      setState(() {});
    }
  }

  void _onFooterSize(Size s) {
    if ((_footerHeight - s.height).abs() > 0.5) {
      _footerHeight = s.height;
      _coerceExtentAfterMeasure();
      setState(() {});
    }
  }

  void _coerceExtentAfterMeasure() {
    if (!_dragCtrl.isAttached) return;
    final collapsed = _collapsedTarget(context);

    if (!widget.controller.expanded && !_snapping) {
      final now = _dragCtrl.size;
      if ((now - collapsed).abs() > 0.005) {
        _dragCtrl.jumpTo(collapsed);
      }
    }
  }

  void _maybeInitSnap() {
    if (_didInitSnap) return;
    final target = widget.controller.expanded
        ? _expandedSize
        : _collapsedTarget(context);
    if (_dragCtrl.isAttached) {
      _dragCtrl.jumpTo(target);
      _didInitSnap = true;
      if (mounted) setState(() {});
      return;
    }
    void onAttachListener() {
      if (!_dragCtrl.isAttached) return;
      _dragCtrl.removeListener(onAttachListener);
      if (_didInitSnap) return;
      _dragCtrl.jumpTo(target);
      _didInitSnap = true;
      if (mounted) setState(() {});
    }

    _dragCtrl.addListener(onAttachListener);
  }

  void _onControllerChange() {
    final target = widget.controller.expanded
        ? _expandedSize
        : _collapsedTarget(context);
    _animateTo(target);
  }

  void _onDrag() {
    if (_snapping) return;
    final collapsed = _collapsedTarget(context);
    final expanded = _expandedSize;
    final range = (expanded - collapsed).abs();
    if (range <= 0) return;

    final threshold = _snapThresholdFraction * range;
    final size = _dragCtrl.size;

    if (!widget.controller.expanded && size >= (collapsed + threshold)) {
      _snap(expand: true);
    } else if (widget.controller.expanded && size <= (expanded - threshold)) {
      _snap(expand: false);
    }
  }

  Future<void> _snap({required bool expand}) async {
    if (_snapping) return;
    _snapping = true;
    final target = expand ? _expandedSize : _collapsedTarget(context);
    await _dragCtrl.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
    widget.controller.expanded = expand;
    _snapping = false;
  }

  Future<void> _animateTo(double size) async {
    if (_snapping) return;
    _snapping = true;
    await _dragCtrl.animateTo(
      size,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
    _snapping = false;
  }

  @override
  Widget build(BuildContext context) {
    final collapsedNow = _collapsedTarget(context);

    return GestureDetector(
      onVerticalDragStart: (_) {
        _dragStartExpanded = widget.controller.expanded;
        _dragStartExtent = _dragCtrl.size;
      },
      onVerticalDragEnd: (details) {
        if (!widget.controller.expanded &&
            details.primaryVelocity != null &&
            details.primaryVelocity! > 300) {
          widget.onDismiss?.call();
          return;
        }
      },
      child: DraggableScrollableSheet(
        controller: _dragCtrl,
        expand: true,
        initialChildSize: widget.controller.expanded
            ? _expandedSize
            : collapsedNow,
        minChildSize: collapsedNow,
        maxChildSize: widget.maxChildSize,
        builder: (context, draggableScrollController) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return ScrollConfiguration(
                behavior: const _NoBounceBehavior(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (sn) {
                    if (sn is ScrollStartNotification) {
                      _dragStartExpanded ??= widget.controller.expanded;
                      _dragStartExtent ??= _dragCtrl.size;
                    } else if (sn is ScrollEndNotification) {
                      final collapsed = _collapsedTarget(context);
                      final expanded = _expandedSize;
                      final range = (expanded - collapsed).abs();
                      if (range > 0 && !_snapping) {
                        final size = _dragCtrl.size;
                        final delta = (_dragStartExtent == null)
                            ? 0.0
                            : size - _dragStartExtent!;
                        final thr = _snapThresholdFraction * range;
                        if (_dragStartExpanded != null &&
                            widget.controller.expanded != _dragStartExpanded) {
                        } else {
                          if (delta.abs() < thr) {
                            final backTarget = (_dragStartExpanded == true)
                                ? expanded
                                : collapsed;
                            _animateTo(backTarget);
                          } else {
                            _snap(expand: delta > 0);
                          }
                        }
                      }
                      _dragStartExtent = null;
                      _dragStartExpanded = null;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: draggableScrollController,
                    dragStartBehavior: DragStartBehavior.start,
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color:
                            widget.backgroundColor ??
                            Theme.of(context).cardColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: widget.sheetPadding ?? EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (widget.showDragHandle &&
                                widget.handleColor != Colors.transparent)
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                        widget.handleColor ?? Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),

                            _SizeProbe(
                              onSize: _onHeaderSize,
                              child: widget.header,
                            ),

                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, inner) {
                                  final reservedFooter = _footerHeight;
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      NotificationListener<ScrollNotification>(
                                        onNotification: (n) {
                                          if (widget.controller.expanded) {
                                            final draggingDown =
                                                (n is OverscrollNotification &&
                                                    n.overscroll < 0) ||
                                                (n is UserScrollNotification &&
                                                    n.direction ==
                                                        ScrollDirection
                                                            .forward);
                                            if (draggingDown &&
                                                (!_bodyScrollCtrl.hasClients ||
                                                    _bodyScrollCtrl.offset <=
                                                        0.0)) {
                                              _snap(expand: false);
                                              return true;
                                            }
                                          }
                                          return false;
                                        },
                                        child: PrimaryScrollController(
                                          controller: _bodyScrollCtrl,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: reservedFooter,
                                            ),
                                            child: widget.controller.expanded
                                                ? widget.bodyBuilder(
                                                    scrollController:
                                                        _bodyScrollCtrl,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                      ),

                                      if (reservedFooter > 0)
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: reservedFooter,
                                            color:
                                                widget.backgroundColor ??
                                                Theme.of(context).cardColor,
                                          ),
                                        ),

                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: _SizeProbe(
                                          onSize: _onFooterSize,
                                          child: SafeArea(
                                            top: false,
                                            left: false,
                                            right: false,
                                            bottom: true,
                                            minimum: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: widget.footer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Reports child's laid-out size each time it changes, without affecting layout.
class _SizeProbe extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSize;

  const _SizeProbe({required this.onSize, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _SizeProbeRender(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _SizeProbeRender renderObject,
  ) {
    renderObject.onSize = onSize;
  }
}

class _SizeProbeRender extends RenderProxyBox {
  _SizeProbeRender(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    final s = child?.size ?? Size.zero;
    if (_last != s) {
      _last = s;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(s));
    }
  }
}

class _NoBounceBehavior extends ScrollBehavior {
  const _NoBounceBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
