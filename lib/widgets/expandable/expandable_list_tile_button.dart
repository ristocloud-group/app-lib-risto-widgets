import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/list_tile_button.dart';

/// A wrapper that manages multiple [ExpandableListTileButton]s, ensuring
/// that only one tile can be expanded at any given time.
class ExpandableAccordionGroup extends StatefulWidget {
  final List<Widget> children;

  const ExpandableAccordionGroup({super.key, required this.children});

  @override
  State<ExpandableAccordionGroup> createState() =>
      _ExpandableAccordionGroupState();
}

class _ExpandableAccordionGroupState extends State<ExpandableAccordionGroup> {
  late List<ExpandableController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (_) => ExpandableController(),
    );

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].expanded) {
          for (int j = 0; j < _controllers.length; j++) {
            if (i != j && _controllers[j].expanded) {
              _controllers[j].expanded = false;
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (index) {
        final child = widget.children[index];

        if (child is ExpandableListTileButton) {
          return child._copyWithController(_controllers[index]);
        }
        return child;
      }),
    );
  }
}

/// A versatile, animated, expandable list tile button.
class ExpandableListTileButton extends StatefulWidget {
  final Widget expanded;
  final Widget? title;
  final Widget? subtitle;

  final Color? headerBackgroundColor;
  final Color? expandedBodyColor;
  final Color? backgroundColor;
  final Color? expandedColor;

  final Color? iconColor;
  final Color? trailingIconColor;
  final Color? borderColor;
  final Color? shadowColor;

  final double elevation;
  final EdgeInsetsGeometry? margin;
  final double expandedBottomMargin; // NEW: Ensures shadows are never clipped
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? headerBodyPadding;
  final EdgeInsetsGeometry? leadingPadding;
  final EdgeInsetsGeometry? trailingPadding;

  final double? headerWidth;
  final double? headerHeight;
  final double? headerMinWidth;
  final double? headerMaxWidth;
  final double? headerMinHeight;
  final double? headerMaxHeight;
  final Alignment headerContentAlignment;

  final double? leadingSizeFactor;
  final Widget? leading;
  final IconData? icon;

  final IconData trailingExpandedIcon;
  final IconData trailingCollapsedIcon;

  final Widget Function(
    Function() tapAction,
    bool isExpanded,
    bool isDisabled,
    double animationValue,
  )?
  customHeaderBuilder;

  final Widget Function(bool isExpanded, bool isDisabled)? trailingBuilder;

  final BorderRadius borderRadius;
  final bool disabled;
  final bool headerDisabled;
  final AlignmentGeometry bodyAlignment;
  final ExpandableController? controller;
  final Size? trailingSize;

  final Duration animationDuration;
  final Curve animationCurve;

  final bool enableHaptics;
  final MouseCursor mouseCursor;
  final String? semanticsLabel;

  /// Determines the expansion style.
  /// `true` (Continuous): Header's bottom corners flatten to merge with the body.
  /// `false` (Layered): Header remains fully rounded, body spawns from half-way underneath it.
  final bool continuous;

  final Future<Widget> Function()? fetchExpandedContent;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  final Color? _finalHeaderBackgroundColor;
  final Color? _finalExpandedBodyColor;
  final bool _useOverlay;

  const ExpandableListTileButton({
    super.key,
    required this.expanded,
    this.customHeaderBuilder,
    this.title,
    this.subtitle,
    this.headerBackgroundColor,
    this.expandedBodyColor,
    this.backgroundColor,
    this.expandedColor,
    this.iconColor,
    this.trailingIconColor,
    this.borderColor,
    this.shadowColor,
    this.elevation = 1,
    this.margin,
    this.expandedBottomMargin = 16.0,
    this.headerPadding,
    this.headerBodyPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.headerWidth,
    this.headerHeight,
    this.headerMinWidth,
    this.headerMaxWidth,
    this.headerMinHeight,
    this.headerMaxHeight,
    this.headerContentAlignment = Alignment.centerLeft,
    this.leadingSizeFactor,
    this.leading,
    this.icon,
    this.trailingExpandedIcon = Icons.expand_less,
    this.trailingCollapsedIcon = Icons.expand_more,
    this.trailingBuilder,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.disabled = false,
    this.headerDisabled = false,
    this.bodyAlignment = Alignment.topCenter,
    this.controller,
    this.trailingSize,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOutCubic,
    this.enableHaptics = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticsLabel,
    this.continuous = true,
    this.fetchExpandedContent,
    this.loadingWidget,
    this.errorWidget,
    bool overlay = false,
  }) : _finalHeaderBackgroundColor = headerBackgroundColor ?? backgroundColor,
       _finalExpandedBodyColor = expandedBodyColor ?? expandedColor,
       _useOverlay = overlay,
       assert(
         customHeaderBuilder != null || title != null,
         'Either customHeaderBuilder or title must be provided for the header.',
       );

  ExpandableListTileButton _copyWithController(
    ExpandableController newController,
  ) {
    return ExpandableListTileButton(
      key: key,
      expanded: expanded,
      customHeaderBuilder: customHeaderBuilder,
      title: title,
      subtitle: subtitle,
      headerBackgroundColor: headerBackgroundColor,
      expandedBodyColor: expandedBodyColor,
      backgroundColor: backgroundColor,
      expandedColor: expandedColor,
      iconColor: iconColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      headerPadding: headerPadding,
      headerBodyPadding: headerBodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      headerWidth: headerWidth,
      headerHeight: headerHeight,
      headerMinWidth: headerMinWidth,
      headerMaxWidth: headerMaxWidth,
      headerMinHeight: headerMinHeight,
      headerMaxHeight: headerMaxHeight,
      headerContentAlignment: headerContentAlignment,
      leadingSizeFactor: leadingSizeFactor,
      leading: leading,
      icon: icon,
      trailingExpandedIcon: trailingExpandedIcon,
      trailingCollapsedIcon: trailingCollapsedIcon,
      trailingBuilder: trailingBuilder,
      borderRadius: borderRadius,
      disabled: disabled,
      headerDisabled: headerDisabled,
      bodyAlignment: bodyAlignment,
      controller: newController,
      trailingSize: trailingSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      enableHaptics: enableHaptics,
      mouseCursor: mouseCursor,
      semanticsLabel: semanticsLabel,
      continuous: continuous,
      fetchExpandedContent: fetchExpandedContent,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      overlay: _useOverlay,
    );
  }

  factory ExpandableListTileButton.listTile({
    Key? key,
    required Widget expanded,
    required Widget title,
    Widget? subtitle,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor,
    Color? expandedColor,
    Color? trailingIconColor,
    Color? borderColor,
    Color? shadowColor,
    double elevation = 1,
    Widget? leading,
    EdgeInsetsGeometry? margin,
    double expandedBottomMargin = 16.0,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? headerBodyPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    double? headerWidth,
    double? headerHeight,
    double? headerMinWidth,
    double? headerMaxWidth,
    double? headerMinHeight,
    double? headerMaxHeight,
    Alignment headerContentAlignment = Alignment.centerLeft,
    IconData trailingExpandedIcon = Icons.expand_less,
    IconData trailingCollapsedIcon = Icons.expand_more,
    Widget Function(bool isExpanded, bool isDisabled)? trailingBuilder,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    bool disabled = false,
    bool headerDisabled = false,
    AlignmentGeometry bodyAlignment = Alignment.topCenter,
    ExpandableController? controller,
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOutCubic,
    bool enableHaptics = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    String? semanticsLabel,
    bool continuous = true,
  }) {
    return ExpandableListTileButton(
      key: key,
      expanded: expanded,
      title: title,
      subtitle: subtitle,
      headerBackgroundColor: headerBackgroundColor,
      backgroundColor: backgroundColor,
      expandedBodyColor: expandedBodyColor,
      expandedColor: expandedColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      headerPadding: headerPadding,
      headerBodyPadding: headerBodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      headerWidth: headerWidth,
      headerHeight: headerHeight,
      headerMinWidth: headerMinWidth,
      headerMaxWidth: headerMaxWidth,
      headerMinHeight: headerMinHeight,
      headerMaxHeight: headerMaxHeight,
      headerContentAlignment: headerContentAlignment,
      leading: leading,
      trailingExpandedIcon: trailingExpandedIcon,
      trailingCollapsedIcon: trailingCollapsedIcon,
      trailingBuilder: trailingBuilder,
      borderRadius: borderRadius,
      disabled: disabled,
      headerDisabled: headerDisabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      enableHaptics: enableHaptics,
      mouseCursor: mouseCursor,
      semanticsLabel: semanticsLabel,
      continuous: continuous,
      customHeaderBuilder:
          (toggleExpansion, isExpanded, isDisabled, animValue) =>
              ListTileButton(
                padding: headerPadding,
                bodyPadding: headerBodyPadding,
                leadingPadding: leadingPadding,
                trailingPadding: trailingPadding,
                width: headerWidth,
                height: headerHeight,
                minWidth: headerMinWidth,
                maxWidth: headerMaxWidth,
                minHeight: headerMinHeight ?? 60.0,
                maxHeight: headerMaxHeight,
                contentAlignment: headerContentAlignment,
                onPressed: toggleExpansion,
                leading: leading,
                body: title,
                subtitle: subtitle,
                trailing: isDisabled
                    ? null
                    : trailingBuilder != null
                    ? trailingBuilder(isExpanded, isDisabled)
                    : RotationTransition(
                        turns: AlwaysStoppedAnimation(animValue * 0.5),
                        child: Icon(
                          trailingCollapsedIcon,
                          color: trailingIconColor,
                        ),
                      ),
                backgroundColor: Colors.transparent,
                disabled: headerDisabled,
              ),
    );
  }

  factory ExpandableListTileButton.iconListTile({
    Key? key,
    required Widget expanded,
    required IconData icon,
    required Widget title,
    Widget? subtitle,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor,
    Color? expandedColor,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    Color? iconColor,
    Color? trailingIconColor,
    Color? borderColor,
    Color? shadowColor,
    double elevation = 1,
    double? leadingSizeFactor,
    EdgeInsetsGeometry? margin,
    double expandedBottomMargin = 16.0,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? headerBodyPadding,
    double? headerWidth,
    double? headerHeight,
    double? headerMinWidth,
    double? headerMaxWidth,
    double? headerMinHeight,
    double? headerMaxHeight,
    Alignment headerContentAlignment = Alignment.centerLeft,
    IconData trailingExpandedIcon = Icons.expand_less,
    IconData trailingCollapsedIcon = Icons.expand_more,
    Widget Function(bool isExpanded, bool isDisabled)? trailingBuilder,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    bool disabled = false,
    bool headerDisabled = false,
    AlignmentGeometry bodyAlignment = Alignment.topCenter,
    ExpandableController? controller,
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOutCubic,
    bool enableHaptics = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    String? semanticsLabel,
    bool continuous = true,
  }) {
    return ExpandableListTileButton(
      key: key,
      expanded: expanded,
      title: title,
      subtitle: subtitle,
      headerBackgroundColor: headerBackgroundColor,
      backgroundColor: backgroundColor,
      expandedBodyColor: expandedBodyColor,
      expandedColor: expandedColor,
      icon: icon,
      iconColor: iconColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      headerPadding: headerPadding,
      headerBodyPadding: headerBodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      headerWidth: headerWidth,
      headerHeight: headerHeight,
      headerMinWidth: headerMinWidth,
      headerMaxWidth: headerMaxWidth,
      headerMinHeight: headerMinHeight,
      headerMaxHeight: headerMaxHeight,
      headerContentAlignment: headerContentAlignment,
      leadingSizeFactor: leadingSizeFactor,
      trailingExpandedIcon: trailingExpandedIcon,
      trailingCollapsedIcon: trailingCollapsedIcon,
      trailingBuilder: trailingBuilder,
      borderRadius: borderRadius,
      disabled: disabled,
      headerDisabled: headerDisabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      enableHaptics: enableHaptics,
      mouseCursor: mouseCursor,
      semanticsLabel: semanticsLabel,
      continuous: continuous,
      customHeaderBuilder:
          (toggleExpansion, isExpanded, isDisabled, animValue) =>
              IconListTileButton(
                padding: headerPadding,
                bodyPadding: headerBodyPadding,
                leadingPadding: leadingPadding,
                trailingPadding: trailingPadding,
                width: headerWidth,
                height: headerHeight,
                minWidth: headerMinWidth,
                maxWidth: headerMaxWidth,
                minHeight: headerMinHeight ?? 60.0,
                maxHeight: headerMaxHeight,
                contentAlignment: headerContentAlignment,
                icon: icon,
                iconColor: iconColor,
                leadingSizeFactor: leadingSizeFactor ?? 1.0,
                title: title,
                subtitle: subtitle,
                trailing: isDisabled
                    ? null
                    : trailingBuilder != null
                    ? trailingBuilder(isExpanded, isDisabled)
                    : RotationTransition(
                        turns: AlwaysStoppedAnimation(animValue * 0.5),
                        child: Icon(
                          trailingCollapsedIcon,
                          color: trailingIconColor,
                        ),
                      ),
                onPressed: toggleExpansion,
                backgroundColor: Colors.transparent,
                disabled: headerDisabled,
              ),
    );
  }

  factory ExpandableListTileButton.async({
    Key? key,
    required Future<Widget> Function() fetchExpandedContent,
    required Widget title,
    Widget? loadingWidget,
    Widget? errorWidget,
    Widget? subtitle,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? trailingIconColor,
    double elevation = 1,
    Widget? leading,
    EdgeInsetsGeometry? margin,
    double expandedBottomMargin = 16.0,
    IconData trailingExpandedIcon = Icons.expand_less,
    IconData trailingCollapsedIcon = Icons.expand_more,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    ExpandableController? controller,
    Duration animationDuration = const Duration(milliseconds: 300),
    bool continuous = true,
  }) {
    return ExpandableListTileButton.listTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      headerBackgroundColor: headerBackgroundColor,
      expandedBodyColor: expandedBodyColor,
      trailingIconColor: trailingIconColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      borderRadius: borderRadius,
      trailingExpandedIcon: trailingExpandedIcon,
      trailingCollapsedIcon: trailingCollapsedIcon,
      controller: controller,
      animationDuration: animationDuration,
      continuous: continuous,
      expanded: FutureBuilder<Widget>(
        future: fetchExpandedContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: loadingWidget ?? const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child:
                  errorWidget ??
                  const Text(
                    "Failed to load content.",
                    style: TextStyle(color: Colors.red),
                  ),
            );
          }
          return snapshot.data ?? const SizedBox.shrink();
        },
      ),
    );
  }

  factory ExpandableListTileButton.custom({
    Key? key,
    required Widget expanded,
    required Widget Function(
      Function() tapAction,
      bool isExpanded,
      bool isDisabled,
      double animValue,
    )
    customHeaderBuilder,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor,
    Color? expandedColor,
    Color? borderColor,
    Color? shadowColor,
    double elevation = 1,
    EdgeInsetsGeometry? margin,
    double expandedBottomMargin = 16.0,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? headerBodyPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    double? headerWidth,
    double? headerHeight,
    double? headerMinWidth,
    double? headerMaxWidth,
    double? headerMinHeight,
    double? headerMaxHeight,
    Alignment headerContentAlignment = Alignment.centerLeft,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    bool disabled = false,
    bool headerDisabled = false,
    AlignmentGeometry bodyAlignment = Alignment.topCenter,
    ExpandableController? controller,
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOutCubic,
    bool enableHaptics = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    String? semanticsLabel,
    bool continuous = true,
  }) {
    return ExpandableListTileButton(
      key: key,
      expanded: expanded,
      customHeaderBuilder: customHeaderBuilder,
      headerBackgroundColor: headerBackgroundColor,
      backgroundColor: backgroundColor,
      expandedBodyColor: expandedBodyColor,
      expandedColor: expandedColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      headerPadding: headerPadding,
      headerBodyPadding: headerBodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      headerWidth: headerWidth,
      headerHeight: headerHeight,
      headerMinWidth: headerMinWidth,
      headerMaxWidth: headerMaxWidth,
      headerMinHeight: headerMinHeight,
      headerMaxHeight: headerMaxHeight,
      headerContentAlignment: headerContentAlignment,
      borderRadius: borderRadius,
      disabled: disabled,
      headerDisabled: headerDisabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      enableHaptics: enableHaptics,
      mouseCursor: mouseCursor,
      semanticsLabel: semanticsLabel,
      continuous: continuous,
    );
  }

  factory ExpandableListTileButton.overlayMenu({
    Key? key,
    required Widget expanded,
    required Widget title,
    Widget? subtitle,
    Widget? leading,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? trailingIconColor,
    Color? borderColor,
    Color? shadowColor,
    double elevation = 1,
    EdgeInsetsGeometry? margin,
    double expandedBottomMargin = 16.0,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? headerBodyPadding,
    EdgeInsetsGeometry? leadingPadding,
    EdgeInsetsGeometry? trailingPadding,
    double? headerWidth,
    double? headerHeight,
    double? headerMinWidth,
    double? headerMaxWidth,
    double? headerMinHeight,
    double? headerMaxHeight,
    Alignment headerContentAlignment = Alignment.centerLeft,
    IconData trailingExpandedIcon = Icons.expand_less,
    IconData trailingCollapsedIcon = Icons.expand_more,
    Widget Function(bool isExpanded, bool isDisabled)? trailingBuilder,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    bool disabled = false,
    bool headerDisabled = false,
    AlignmentGeometry bodyAlignment = Alignment.center,
    ExpandableController? controller,
    double leadingSizeFactor = 1,
    Size? trailingSize,
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOutCubic,
    bool enableHaptics = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    String? semanticsLabel,
    bool continuous = true,
  }) {
    return ExpandableListTileButton(
      key: key,
      expanded: expanded,
      title: title,
      subtitle: subtitle,
      leading: leading,
      headerBackgroundColor: headerBackgroundColor,
      expandedBodyColor: expandedBodyColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      shadowColor: shadowColor,
      elevation: elevation,
      margin: margin,
      expandedBottomMargin: expandedBottomMargin,
      headerPadding: headerPadding,
      headerBodyPadding: headerBodyPadding,
      leadingPadding: leadingPadding,
      trailingPadding: trailingPadding,
      headerWidth: headerWidth,
      headerHeight: headerHeight,
      headerMinWidth: headerMinWidth,
      headerMaxWidth: headerMaxWidth,
      headerMinHeight: headerMinHeight,
      headerMaxHeight: headerMaxHeight,
      headerContentAlignment: headerContentAlignment,
      trailingExpandedIcon: trailingExpandedIcon,
      trailingCollapsedIcon: trailingCollapsedIcon,
      trailingBuilder: trailingBuilder,
      borderRadius: borderRadius,
      disabled: disabled,
      headerDisabled: headerDisabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      trailingSize: trailingSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      enableHaptics: enableHaptics,
      mouseCursor: mouseCursor,
      semanticsLabel: semanticsLabel,
      continuous: continuous,
      overlay: true,
      customHeaderBuilder: (toggle, isExp, isDis, animValue) => ListTileButton(
        padding: headerPadding,
        bodyPadding: headerBodyPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        width: headerWidth,
        height: headerHeight,
        minWidth: headerMinWidth,
        maxWidth: headerMaxWidth,
        minHeight: headerMinHeight ?? 60.0,
        maxHeight: headerMaxHeight,
        contentAlignment: headerContentAlignment,
        onPressed: toggle,
        leading: leading,
        leadingSizeFactor: leadingSizeFactor,
        body: title,
        subtitle: subtitle,
        trailing: isDis
            ? null
            : trailingBuilder != null
            ? trailingBuilder(isExp, isDis)
            : (trailingSize != null
                  ? SizedBox.fromSize(
                      size: trailingSize,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(animValue * 0.5),
                        child: Icon(
                          trailingCollapsedIcon,
                          color: trailingIconColor,
                        ),
                      ),
                    )
                  : RotationTransition(
                      turns: AlwaysStoppedAnimation(animValue * 0.5),
                      child: Icon(
                        trailingCollapsedIcon,
                        color: trailingIconColor,
                      ),
                    )),
        backgroundColor: Colors.transparent,
        disabled: headerDisabled,
      ),
    );
  }

  @override
  State<ExpandableListTileButton> createState() =>
      _ExpandableListTileButtonState();
}

class _ExpandableListTileButtonState extends State<ExpandableListTileButton>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isStateManagedExternally = false;
  final GlobalKey _headerKey = GlobalKey();

  double _headerHeight = 0.0;
  double _headerWidth = 0.0;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _isStateManagedExternally = widget.controller != null;
    _isExpanded = _isStateManagedExternally
        ? widget.controller!.expanded
        : false;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    if (_isExpanded && !widget.disabled) {
      _animationController.value = 1.0;
    }

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (!_isStateManagedExternally && mounted) {
          if (!_isExpanded && status == AnimationStatus.dismissed) {
            setState(() {});
          }
        }
      }
    });

    if (_isStateManagedExternally) {
      widget.controller!.addListener(_handleControllerChanged);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderSize());
  }

  void _handleControllerChanged() {
    if (widget.controller?.expanded != _isExpanded && mounted) {
      _syncExpansionState(widget.controller!.expanded);
    }
  }

  @override
  void didUpdateWidget(covariant ExpandableListTileButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _isStateManagedExternally = widget.controller != null;
      if (_isStateManagedExternally) {
        widget.controller?.removeListener(_handleControllerChanged);
        widget.controller?.addListener(_handleControllerChanged);
        if (widget.controller!.expanded != _isExpanded) {
          _syncExpansionState(widget.controller!.expanded);
        }
      }
    }

    if (widget.disabled && !oldWidget.disabled && _isExpanded) {
      _syncExpansionState(false);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderSize());
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _updateHeaderSize() {
    final RenderBox? headerRenderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (headerRenderBox != null) {
      final currentHeaderHeight = headerRenderBox.size.height;
      final currentHeaderWidth = headerRenderBox.size.width;

      if ((_headerHeight != currentHeaderHeight ||
              _headerWidth != currentHeaderWidth) &&
          mounted) {
        setState(() {
          _headerHeight = currentHeaderHeight > 10 ? currentHeaderHeight : 50.0;
          _headerWidth = currentHeaderWidth;
        });
      }
    } else if (_headerHeight == 0.0 && mounted) {
      setState(() {
        _headerHeight = 50.0;
        _headerWidth = MediaQuery.sizeOf(context).width;
      });
    }
  }

  void _toggleExpansion() {
    if (widget.disabled || widget.headerDisabled) return;

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }

    if (widget._useOverlay) {
      if (_overlayEntry == null) {
        setState(() => _isExpanded = true);
        _showOverlay();
        _animationController.forward();
      } else {
        _animationController.reverse().whenComplete(() {
          _removeOverlay();
          if (mounted) setState(() => _isExpanded = false);
        });
      }
      return;
    }

    if (_isStateManagedExternally) {
      widget.controller!.toggle();
    } else {
      _syncExpansionState(!_isExpanded);
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || widget.disabled || widget.headerDisabled) {
      return;
    }

    if (_headerWidth == 0.0 || _headerHeight == 0.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_headerWidth > 0 && _headerHeight > 0 && _overlayEntry == null) {
          _showOverlay();
        }
      });
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final effectiveExpandedBodyColor =
            widget._finalExpandedBodyColor ??
            theme.colorScheme.secondary.withCustomOpacity(0.1);

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            Widget actualHeaderContentForOverlay =
                widget.customHeaderBuilder != null
                ? widget.customHeaderBuilder!(
                    _toggleExpansion,
                    _isExpanded,
                    widget.disabled,
                    _animationController.value,
                  )
                : _buildDefaultHeader(context, theme);

            final double animValue = _animation.value.clamp(0.0, 1.0);

            // Continuous flattens the bottom of the header. Layered keeps it fully rounded.
            final double currentBottomRadius = widget.continuous
                ? widget.borderRadius.bottomLeft.x * (1.0 - animValue)
                : widget.borderRadius.bottomLeft.x;

            // In continuous mode, overlap is minimal. In layered mode, overlap spawns body from halfway up the header.
            final double overlap = widget.continuous
                ? 1.0
                : (_headerHeight / 2).clamp(0.0, 40.0);

            return TapRegion(
              onTapOutside: (event) {
                if (_isExpanded) _toggleExpansion();
              },
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0.0, 0.0),
                targetAnchor: Alignment.topLeft,
                followerAnchor: Alignment.topLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Expanded Body
                    Positioned(
                      top: _headerHeight - overlap,
                      left: 0,
                      width: _headerWidth,
                      child: Material(
                        elevation: widget.elevation,
                        shadowColor: widget.shadowColor,
                        color: effectiveExpandedBodyColor,
                        shape: RemainsRoundedBorder(
                          topRadius: widget.continuous
                              ? currentBottomRadius
                              : 0.0,
                          bottomRadius: widget.borderRadius.bottomLeft.x,
                          borderColor: widget.borderColor,
                          borderWidth: widget.borderColor != null ? 1.0 : 0.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SizeTransition(
                          sizeFactor: _animation,
                          axis: Axis.vertical,
                          axisAlignment: -1.0,
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: overlap,
                                bottom: widget.expandedBottomMargin,
                              ),
                              child: Align(
                                alignment: widget.bodyAlignment,
                                child: widget.expanded,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Header
                    Material(
                      elevation: widget.elevation,
                      shadowColor: widget.shadowColor,
                      color:
                          (widget._finalHeaderBackgroundColor ??
                          theme.cardColor),
                      shape: RemainsRoundedBorder(
                        topRadius: widget.borderRadius.topLeft.x,
                        bottomRadius: currentBottomRadius,
                        borderColor: widget.borderColor,
                        borderWidth: widget.borderColor != null ? 1.0 : 0.0,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: _headerHeight,
                        width: _headerWidth,
                        child: actualHeaderContentForOverlay,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _syncExpansionState(bool expand) {
    if (!mounted) return;
    if (expand && (widget.disabled || widget.headerDisabled)) return;

    setState(() => _isExpanded = expand);

    if (widget._useOverlay) {
      if (expand) {
        if (_overlayEntry == null) _showOverlay();
        _animationController.forward();
      } else {
        _animationController.reverse().whenComplete(() => _removeOverlay());
      }
    } else {
      if (expand) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveHeaderBgColor =
        widget._finalHeaderBackgroundColor ?? theme.cardColor;
    final effectiveExpandedBodyColor =
        widget._finalExpandedBodyColor ??
        theme.colorScheme.secondary.withCustomOpacity(0.1);

    final MouseCursor effectiveCursor =
        (widget.disabled || widget.headerDisabled)
        ? SystemMouseCursors.forbidden
        : widget.mouseCursor;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        Widget actualHeaderContent = widget.customHeaderBuilder != null
            ? widget.customHeaderBuilder!(
                _toggleExpansion,
                _isExpanded,
                widget.disabled,
                _animationController.value,
              )
            : _buildDefaultHeader(context, theme);

        final placeholderHeight = _headerHeight > 0 ? _headerHeight : 50.0;
        final double animValue = _animation.value.clamp(0.0, 1.0);

        final double currentBottomRadius = widget.continuous
            ? widget.borderRadius.bottomLeft.x * (1.0 - animValue)
            : widget.borderRadius.bottomLeft.x;

        final double overlap = widget.continuous
            ? 1.0
            : (_headerHeight / 2).clamp(0.0, 40.0);

        return Container(
          margin: widget.margin,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Render Body
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: placeholderHeight),
                  if (!widget._useOverlay &&
                      (_isExpanded || _animationController.isAnimating))
                    Transform.translate(
                      offset: Offset(0, -overlap),
                      child: Material(
                        elevation: widget.elevation,
                        shadowColor: widget.shadowColor,
                        color: effectiveExpandedBodyColor,
                        shape: RemainsRoundedBorder(
                          topRadius: widget.continuous
                              ? currentBottomRadius
                              : 0.0,
                          // Top corners hide behind header in layered mode
                          bottomRadius: widget.borderRadius.bottomLeft.x,
                          borderColor: widget.borderColor,
                          borderWidth: widget.borderColor != null ? 1.0 : 0.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SizeTransition(
                          sizeFactor: _animation,
                          axis: Axis.vertical,
                          axisAlignment: -1.0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: overlap,
                              bottom: widget.expandedBottomMargin,
                            ),
                            child: Align(
                              alignment: widget.bodyAlignment,
                              child: widget.expanded,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // 2. Render Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: Semantics(
                    label:
                        widget.semanticsLabel ??
                        (widget.title is Text
                            ? (widget.title as Text).data
                            : 'Expandable Tile'),
                    button: true,
                    expanded: _isExpanded,
                    child: MouseRegion(
                      cursor: effectiveCursor,
                      child: Material(
                        key: _headerKey,
                        elevation: widget.elevation,
                        shadowColor: widget.shadowColor,
                        color: effectiveHeaderBgColor,
                        shape: RemainsRoundedBorder(
                          topRadius: widget.borderRadius.topLeft.x,
                          bottomRadius: currentBottomRadius,
                          borderColor: widget.borderColor,
                          borderWidth: widget.borderColor != null ? 1.0 : 0.0,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: actualHeaderContent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultHeader(BuildContext context, ThemeData theme) {
    Widget? trailingWidget;
    if (!widget.disabled) {
      if (widget.trailingBuilder != null) {
        trailingWidget = widget.trailingBuilder!(_isExpanded, widget.disabled);
      } else {
        trailingWidget = RotationTransition(
          turns: AlwaysStoppedAnimation(_animationController.value * 0.5),
          child: Icon(
            widget.trailingCollapsedIcon,
            color: widget.trailingIconColor,
          ),
        );
      }
    }

    if (widget.icon != null && widget.title != null) {
      return IconListTileButton(
        padding: widget.headerPadding,
        bodyPadding: widget.headerBodyPadding,
        leadingPadding: widget.leadingPadding,
        trailingPadding: widget.trailingPadding,
        width: widget.headerWidth,
        height: widget.headerHeight,
        minWidth: widget.headerMinWidth,
        maxWidth: widget.headerMaxWidth,
        minHeight: widget.headerMinHeight ?? 60.0,
        maxHeight: widget.headerMaxHeight,
        contentAlignment: widget.headerContentAlignment,
        icon: widget.icon!,
        iconColor: widget.iconColor,
        leadingSizeFactor: widget.leadingSizeFactor ?? 1.0,
        title: widget.title!,
        subtitle: widget.subtitle,
        trailing: trailingWidget,
        onPressed: _toggleExpansion,
        backgroundColor: Colors.transparent,
        disabled: widget.headerDisabled,
      );
    } else if (widget.title != null) {
      return ListTileButton(
        padding: widget.headerPadding,
        bodyPadding: widget.headerBodyPadding,
        leadingPadding: widget.leadingPadding,
        trailingPadding: widget.trailingPadding,
        width: widget.headerWidth,
        height: widget.headerHeight,
        minWidth: widget.headerMinWidth,
        maxWidth: widget.headerMaxWidth,
        minHeight: widget.headerMinHeight ?? 60.0,
        maxHeight: widget.headerMaxHeight,
        contentAlignment: widget.headerContentAlignment,
        onPressed: _toggleExpansion,
        leading: widget.leading,
        body: widget.title!,
        subtitle: widget.subtitle,
        trailing: trailingWidget,
        backgroundColor: Colors.transparent,
        disabled: widget.headerDisabled,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class RemainsRoundedBorder extends RoundedRectangleBorder {
  final double topRadius;
  final double bottomRadius;
  final Color? borderColor;
  final double borderWidth;

  RemainsRoundedBorder({
    required this.topRadius,
    required this.bottomRadius,
    this.borderColor,
    this.borderWidth = 0.0,
  }) : super(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(topRadius),
           topRight: Radius.circular(topRadius),
           bottomLeft: Radius.circular(bottomRadius),
           bottomRight: Radius.circular(bottomRadius),
         ),
         side: BorderSide.none,
       );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(topRadius),
        topRight: Radius.circular(topRadius),
        bottomLeft: Radius.circular(bottomRadius),
        bottomRight: Radius.circular(bottomRadius),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderColor != null && borderWidth > 0) {
      final paint = Paint()
        ..color = borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect.inflate(-borderWidth / 2),
          topLeft: Radius.circular(topRadius),
          topRight: Radius.circular(topRadius),
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        paint,
      );
    }
  }

  @override
  ShapeBorder scale(double t) {
    return RemainsRoundedBorder(
      topRadius: topRadius * t,
      bottomRadius: bottomRadius * t,
      borderColor: borderColor,
      borderWidth: borderWidth * t,
    );
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder? a, double t) {
    if (a is RemainsRoundedBorder) {
      return RemainsRoundedBorder(
        topRadius: lerpDouble(a.topRadius, topRadius, t)!,
        bottomRadius: lerpDouble(a.bottomRadius, bottomRadius, t)!,
        borderColor: Color.lerp(a.borderColor, borderColor, t),
        borderWidth: lerpDouble(a.borderWidth, borderWidth, t)!,
      );
    }
    return super.lerpFrom(a, t) as ShapeBorder;
  }

  @override
  ShapeBorder lerpTo(ShapeBorder? b, double t) {
    if (b is RemainsRoundedBorder) {
      return RemainsRoundedBorder(
        topRadius: lerpDouble(topRadius, b.topRadius, t)!,
        bottomRadius: lerpDouble(bottomRadius, b.bottomRadius, t)!,
        borderColor: Color.lerp(borderColor, b.borderColor, t),
        borderWidth: lerpDouble(borderWidth, b.borderWidth, t)!,
      );
    }
    return super.lerpTo(b, t) as ShapeBorder;
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderWidth);
}
