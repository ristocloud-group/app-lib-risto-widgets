import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/list_tile_button.dart';

/// A versatile, animated, expandable list tile button.
///
/// The [ExpandableListTileButton] provides a sleek card interface that expands
/// smoothly to reveal additional content when tapped. It manages a Stack layout
/// internally to ensure the header remains fully rounded while the body expands
/// naturally beneath it.
///
/// It supports custom headers, icons, constrained sizing, overlays, and external
/// control via [ExpandableController].
///
/// ### Key Features:
/// * **Factories:** Easily create standard tiles (`.listTile`), icon-focused tiles
///   (`.iconListTile`), completely custom headers (`.custom`), or floating dropdown
///   menus (`.overlayMenu`).
/// * **Sizing & Padding:** Fine-grained control over heights, widths, and internal padding.
/// * **Disabled State:** Setting [disabled] to `true` automatically dims the widget,
///   hides the trailing expansion icon, and completely blocks user interactions.
///
/// Example usage:
/// ```dart
/// ExpandableListTileButton.listTile(
///   title: const Text('Tap to expand'),
///   headerBackgroundColor: Colors.blue[100],
///   expandedBodyColor: Colors.blue[50],
///   borderRadius: BorderRadius.circular(12),
///   expanded: const Padding(
///     padding: EdgeInsets.all(16.0),
///     child: Text('Expanded content goes here.'),
///   ),
/// );
/// ```
class ExpandableListTileButton extends StatefulWidget {
  /// The content to display when the tile is successfully expanded.
  final Widget expanded;

  /// The primary content of the tile when collapsed. Used automatically by the default headers.
  final Widget? title;

  /// Additional content displayed below the [title] when collapsed.
  final Widget? subtitle;

  /// The background color of the header area.
  ///
  /// Takes priority over the legacy [backgroundColor] property.
  final Color? headerBackgroundColor;

  /// The background color of the expanded content area.
  ///
  /// Takes priority over the legacy [expandedColor] property.
  final Color? expandedBodyColor;

  /// Legacy property for the header's background color. Use [headerBackgroundColor] instead.
  final Color? backgroundColor;

  /// Legacy property for the expanded body's background color. Use [expandedBodyColor] instead.
  final Color? expandedColor;

  /// The color of the leading icon when using the `.iconListTile` factory.
  final Color? iconColor;

  /// The color of the trailing expand/collapse chevron icon.
  final Color? trailingIconColor;

  /// The color of the border drawn around the combined widget.
  final Color? borderColor;

  /// The shadow depth (elevation) applied to the header card.
  final double elevation;

  /// The external margin around the entire expandable widget.
  final EdgeInsetsGeometry? margin;

  /// The internal padding applied to the header container.
  final EdgeInsetsGeometry? headerPadding;

  /// The internal padding applied specifically around the title and subtitle text block.
  final EdgeInsetsGeometry? headerBodyPadding;

  /// The padding wrapped directly around the leading widget or icon.
  final EdgeInsetsGeometry? leadingPadding;

  /// The padding wrapped directly around the trailing chevron widget.
  final EdgeInsetsGeometry? trailingPadding;

  /// A strict fixed width for the header tile. Overrides [headerMinWidth] and [headerMaxWidth].
  final double? headerWidth;

  /// A strict fixed height for the header tile. Overrides [headerMinHeight] and [headerMaxHeight].
  final double? headerHeight;

  /// The minimum width the header tile can shrink to.
  final double? headerMinWidth;

  /// The maximum width the header tile can grow to.
  final double? headerMaxWidth;

  /// The minimum height of the header tile. Defaults to 60.0 internally if left null.
  final double? headerMinHeight;

  /// The maximum height the header tile can grow to.
  final double? headerMaxHeight;

  /// The alignment of the title and subtitle within the header's text column.
  /// Defaults to [Alignment.centerLeft].
  final Alignment headerContentAlignment;

  /// A multiplier applied to the size of the leading icon in the `.iconListTile` factory.
  final double? leadingSizeFactor;

  /// A custom leading widget displayed on the far left of the header.
  final Widget? leading;

  /// The icon data used for the leading icon in the `.iconListTile` factory.
  final IconData? icon;

  /// A builder function allowing you to completely define the visual layout of the header.
  ///
  /// Provides `tapAction` (to toggle state), `isExpanded` (current visual state),
  /// and `isDisabled` (current interaction state).
  final Widget Function(Function() tapAction, bool isExpanded, bool isDisabled)?
  customHeaderBuilder;

  /// The radius of the corners for both the header and the expanded body container.
  final BorderRadius borderRadius;

  /// Disables the widget.
  ///
  /// When `true`, the widget becomes semi-transparent, the trailing expansion
  /// chevron is hidden, and all tap interactions are blocked. If the widget is
  /// currently expanded when this changes to `true`, it will automatically collapse.
  final bool disabled;

  /// The alignment of the [expanded] widget within its outer container.
  final AlignmentGeometry bodyAlignment;

  /// An optional external controller to manage the expansion state programmatically.
  ///
  /// If provided, the widget will synchronize its visual state with the controller.
  final ExpandableController? controller;

  /// The final resolved background color for the header.
  final Color? _finalHeaderBackgroundColor;

  /// The final resolved background color for the expanded body.
  final Color? _finalExpandedBodyColor;

  /// If non-null, strictly constrains the trailing widget (the chevron) to this exact size.
  final Size? trailingSize;

  /// When true, the expanded content breaks out of the normal layout flow and
  /// floats above the rest of the UI using an [OverlayEntry].
  final bool _useOverlay;

  /// Creates a foundational [ExpandableListTileButton].
  ///
  /// Usually, you should use one of the named factories (`.listTile`, `.iconListTile`, etc.).
  /// Use this constructor directly only if you are manually providing a [customHeaderBuilder].
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
    this.elevation = 1,
    this.margin,
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
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.disabled = false,
    this.bodyAlignment = Alignment.center,
    this.controller,
    this.trailingSize,
    bool overlay = false,
  }) : _finalHeaderBackgroundColor = headerBackgroundColor ?? backgroundColor,
       _finalExpandedBodyColor = expandedBodyColor ?? expandedColor,
       _useOverlay = overlay,
       assert(
         customHeaderBuilder != null || title != null,
         'Either customHeaderBuilder or title must be provided for the header.',
       );

  /// Creates an [ExpandableListTileButton] that automatically builds a standard
  /// [ListTileButton] for its header.
  ///
  /// This is the most common factory, supporting a [leading] widget, a [title],
  /// and an optional [subtitle]. It automatically handles the layout, alignment,
  /// and constraints of the header.
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
    double elevation = 1,
    Widget? leading,
    EdgeInsetsGeometry? margin,
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
    AlignmentGeometry bodyAlignment = Alignment.center,
    ExpandableController? controller,
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
      elevation: elevation,
      margin: margin,
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
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      customHeaderBuilder: (toggleExpansion, isExpanded, isDisabled) =>
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
                : Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: trailingIconColor,
                  ),
            backgroundColor: Colors.transparent,
            disabled: isDisabled,
          ),
    );
  }

  /// Creates an [ExpandableListTileButton] that utilizes an [IconListTileButton]
  /// for its header, making it simple to construct menus with leading icon indicators.
  ///
  /// The [icon] parameter is required, and its size can be easily adjusted using [leadingSizeFactor].
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
    double elevation = 1,
    double? leadingSizeFactor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? headerBodyPadding,
    double? headerWidth,
    double? headerHeight,
    double? headerMinWidth,
    double? headerMaxWidth,
    double? headerMinHeight,
    double? headerMaxHeight,
    Alignment headerContentAlignment = Alignment.centerLeft,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    bool disabled = false,
    AlignmentGeometry bodyAlignment = Alignment.center,
    ExpandableController? controller,
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
      elevation: elevation,
      margin: margin,
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
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      customHeaderBuilder: (toggleExpansion, isExpanded, isDisabled) =>
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
                : Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: trailingIconColor,
                  ),
            onPressed: toggleExpansion,
            backgroundColor: Colors.transparent,
            disabled: isDisabled,
          ),
    );
  }

  /// Creates an [ExpandableListTileButton] granting complete layout control over the header.
  ///
  /// You must provide a [customHeaderBuilder] which returns the widget to be used as the header.
  /// The builder provides you with the `tapAction` required to trigger the expansion.
  factory ExpandableListTileButton.custom({
    Key? key,
    required Widget expanded,
    required Widget Function(
      Function() tapAction,
      bool isExpanded,
      bool isDisabled,
    )
    customHeaderBuilder,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor,
    Color? expandedColor,
    Color? borderColor,
    double elevation = 1,
    EdgeInsetsGeometry? margin,
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
    AlignmentGeometry bodyAlignment = Alignment.center,
    ExpandableController? controller,
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
      elevation: elevation,
      margin: margin,
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
      bodyAlignment: bodyAlignment,
      controller: controller,
    );
  }

  /// Creates a tile whose expanded content floats in an [Overlay] above other widgets.
  ///
  /// This internally uses an [OverlayEntry] and [CompositedTransformFollower] to bind
  /// the floating menu seamlessly beneath the header, functioning similarly to a native Dropdown.
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
    double elevation = 1,
    EdgeInsetsGeometry? margin,
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
    AlignmentGeometry bodyAlignment = Alignment.center,
    ExpandableController? controller,
    double leadingSizeFactor = 1,
    Size? trailingSize,
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
      elevation: elevation,
      margin: margin,
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
      bodyAlignment: bodyAlignment,
      controller: controller,
      trailingSize: trailingSize,
      overlay: true,
      customHeaderBuilder: (toggle, isExp, isDis) => ListTileButton(
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
            : (trailingSize != null
                  ? SizedBox.fromSize(
                      size: trailingSize,
                      child: Icon(
                        isExp ? Icons.expand_less : Icons.expand_more,
                        color: trailingIconColor,
                      ),
                    )
                  : Icon(
                      isExp ? Icons.expand_less : Icons.expand_more,
                      color: trailingIconColor,
                    )),
        backgroundColor: Colors.transparent,
        disabled: isDis,
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
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
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

    // Force close if it suddenly becomes disabled
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
        _headerWidth = MediaQuery.of(context).size.width;
      });
    }
  }

  void _toggleExpansion() {
    if (widget.disabled) return;

    if (widget._useOverlay) {
      if (_overlayEntry == null) {
        setState(() {
          _isExpanded = true;
        });
        _showOverlay();
        _animationController.forward();
      } else {
        _animationController.reverse().whenComplete(() {
          _removeOverlay();
          if (mounted) {
            setState(() => _isExpanded = false);
          }
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
    if (_overlayEntry != null || widget.disabled) return;
    if (_headerWidth == 0.0 || _headerHeight == 0.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_headerWidth > 0 && _headerHeight > 0 && _overlayEntry == null) {
          _showOverlay();
        }
      });
      return;
    }

    Widget actualHeaderContentForOverlay = widget.customHeaderBuilder != null
        ? widget.customHeaderBuilder!(
            _toggleExpansion,
            _isExpanded,
            widget.disabled,
          )
        : _buildDefaultHeader(context, Theme.of(context));

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        final effectiveExpandedBodyColor =
            widget._finalExpandedBodyColor ??
            theme.colorScheme.secondary.withCustomOpacity(0.1);

        return TapRegion(
          onTapOutside: (event) {
            if (_isExpanded) {
              _toggleExpansion();
            }
          },
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0.0, 0.0),
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.topLeft,
            child: Stack(
              children: [
                Positioned(
                  top: _headerHeight - widget.borderRadius.bottomLeft.y,
                  left: 0,
                  width: _headerWidth,
                  child: Material(
                    elevation: widget.elevation,
                    borderRadius: BorderRadius.only(
                      bottomLeft: widget.borderRadius.bottomLeft,
                      bottomRight: widget.borderRadius.bottomRight,
                    ),
                    color: effectiveExpandedBodyColor,
                    clipBehavior: Clip.antiAlias,
                    child: SizeTransition(
                      sizeFactor: _animation,
                      axis: Axis.vertical,
                      axisAlignment: -1.0,
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: widget.borderRadius.bottomLeft.y,
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
                Material(
                  elevation: widget.elevation,
                  color:
                      (widget._finalHeaderBackgroundColor ?? theme.cardColor),
                  shape: RemainsRoundedBorder(
                    topRadius: widget.borderRadius.topLeft.x,
                    bottomRadius: widget.borderRadius.bottomLeft.x,
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
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _syncExpansionState(bool expand) {
    if (!mounted) return;

    // Prevent expanding if disabled
    if (expand && widget.disabled) return;

    setState(() {
      _isExpanded = expand;
    });

    if (widget._useOverlay) {
      if (expand) {
        if (_overlayEntry == null) {
          _showOverlay();
        }
        _animationController.forward();
      } else {
        _animationController.reverse().whenComplete(() {
          _removeOverlay();
        });
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

    Widget actualHeaderContent = widget.customHeaderBuilder != null
        ? widget.customHeaderBuilder!(
            _toggleExpansion,
            _isExpanded,
            widget.disabled,
          )
        : _buildDefaultHeader(context, theme);

    final placeholderHeight = _headerHeight > 0 ? _headerHeight : 50.0;

    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Container(
          margin: widget.margin,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(height: placeholderHeight),
              if (!widget._useOverlay &&
                  (_isExpanded || _animationController.isAnimating))
                Padding(
                  padding: EdgeInsets.only(top: placeholderHeight / 2),
                  child: SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: -1.0,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: effectiveExpandedBodyColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: widget.borderRadius.bottomLeft,
                          bottomRight: widget.borderRadius.bottomRight,
                        ),
                      ),
                      alignment: widget.bodyAlignment,
                      padding: EdgeInsets.only(top: placeholderHeight / 2),
                      child: widget.expanded,
                    ),
                  ),
                ),
              CompositedTransformTarget(
                link: _layerLink,
                child: Material(
                  key: _headerKey,
                  elevation: widget.elevation,
                  color: effectiveHeaderBgColor,
                  shape: RemainsRoundedBorder(
                    topRadius: widget.borderRadius.topLeft.x,
                    bottomRadius: widget.borderRadius.bottomLeft.x,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderColor != null ? 1.0 : 0.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: actualHeaderContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context, ThemeData theme) {
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
        trailing: widget.disabled
            ? null
            : Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: widget.trailingIconColor,
              ),
        onPressed: _toggleExpansion,
        backgroundColor: Colors.transparent,
        disabled: widget.disabled,
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
        trailing: widget.disabled
            ? null
            : Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: widget.trailingIconColor,
              ),
        backgroundColor: Colors.transparent,
        disabled: widget.disabled,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

/// A custom [ShapeBorder] that allows specifying different top and bottom radii.
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
