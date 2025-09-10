import 'dart:ui'; // Needed for lerpDouble

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/list_tile_button.dart';

/// A widget that provides an expandable list tile button with customizable headers and content.
///
/// The [ExpandableListTileButton] can be used to create a list tile that expands to reveal
/// additional content when tapped. It supports custom headers, icons, expanded content,
/// elevation for the combined widget, disabled state, and external control via [ExpandableController].
///
/// Uses a Stack layout to ensure the header remains fully rounded and the body expands smoothly beneath it.
/// Background colors for the header and expanded body areas are specified separately using
/// [headerBackgroundColor] and [expandedBodyColor]. For backward compatibility,
/// [backgroundColor] and [expandedColor] can also be used, but the newer names are preferred.
///
/// Example usage:
/// ```dart
/// ExpandableController _controller = ExpandableController();
/// // ...
/// ExpandableListTileButton.listTile(
///   controller: _controller,
///   title: Text('Tap to expand'),
///   expanded: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Text('Expanded content goes here.'),
///   ),
///   margin: EdgeInsets.all(8),
///   elevation: 4,
///   headerBackgroundColor: Colors.blue[100], // Preferred
///   expandedBodyColor: Colors.blue[50],    // Preferred
///   borderRadius: BorderRadius.circular(12),
/// );
/// ```
class ExpandableListTileButton extends StatefulWidget {
  /// The content to display when the tile is expanded.
  final Widget expanded;

  /// The primary content of the tile when collapsed (used by default headers).
  final Widget? title;

  /// Additional content displayed below the [title] when collapsed (used by default headers).
  final Widget? subtitle;

  /// The background color of the header area.
  /// If null, [backgroundColor] is used. If both are null, theme default is used.
  /// Using [headerBackgroundColor] is preferred for clarity.
  final Color? headerBackgroundColor;

  /// The background color of the expanded content area.
  /// If null, [expandedColor] is used. If both are null, theme default is used.
  /// Using [expandedBodyColor] is preferred for clarity.
  final Color? expandedBodyColor;

  /// An alternative way to set the header background color for backward compatibility.
  /// [headerBackgroundColor] takes priority if both are provided.
  final Color? backgroundColor;

  /// An alternative way to set the expanded body background color for backward compatibility.
  /// [expandedBodyColor] takes priority if both are provided.
  final Color? expandedColor;

  /// The color of the leading icon (used by default `.iconListTile` header).
  final Color? iconColor;

  /// The color of the trailing expand/collapse icon (used by default headers).
  final Color? trailingIconColor;

  /// The color of the border around the combined widget. Applied to the header Material shape.
  final Color? borderColor;

  /// The elevation of the header's shadow.
  final double elevation;

  /// The external margin around the widget.
  final EdgeInsetsGeometry? margin;

  /// Factor to scale the size of the leading icon (used by default `.iconListTile` header).
  final double? leadingSizeFactor;

  /// The leading widget of the tile (used by default `.listTile` header).
  final Widget? leading;

  /// The icon data for the leading icon (used by default `.iconListTile` header).
  final IconData? icon;

  /// A builder function to create a custom header widget.
  ///
  /// The function provides a `tapAction` callback, an `isExpanded` boolean,
  /// and a `isDisabled` boolean. The custom header should handle its own internal layout.
  final Widget Function(Function() tapAction, bool isExpanded, bool isDisabled)?
      customHeaderBuilder;

  /// Controls the radius of the corners for the header and the overall shape.
  final BorderRadius borderRadius;

  /// Whether the tile is interactive. If true, the tile cannot be expanded or collapsed
  /// by user tap, and its appearance is dimmed.
  final bool disabled;

  /// Alignment of the [expanded] widget within the body container.
  final AlignmentGeometry bodyAlignment;

  /// An optional controller to manage the expansion state externally.
  /// If provided, the widget's state will synchronize with the controller.
  /// If null, the widget manages its own expansion state internally.
  final ExpandableController? controller;

  /// The final resolved background color for the header, prioritizing [headerBackgroundColor].
  final Color? _finalHeaderBackgroundColor;

  /// The final resolved background color for the expanded body, prioritizing [expandedBodyColor].
  final Color? _finalExpandedBodyColor;

  /// If non-null, constrains the trailing widget to this size.
  final Size? trailingSize;

  /// When true, expanded content is shown via an OverlayEntry.
  final bool _useOverlay;

  /// Creates an [ExpandableListTileButton] with the given properties.
  ///
  /// Use this constructor when providing a [customHeaderBuilder].
  /// At least one of [customHeaderBuilder] or [title] must be non-null.
  ///
  /// Accepts both [headerBackgroundColor]/[expandedBodyColor] (preferred) and
  /// [backgroundColor]/[expandedColor] (for backward compatibility).
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
    this.leadingSizeFactor,
    this.leading,
    this.icon,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.disabled = false,
    this.bodyAlignment = Alignment.center,
    this.controller,
    this.trailingSize,
    bool overlay = false,
  })  : _finalHeaderBackgroundColor = headerBackgroundColor ?? backgroundColor,
        _finalExpandedBodyColor = expandedBodyColor ?? expandedColor,
        _useOverlay = overlay,
        assert(customHeaderBuilder != null || title != null,
            'Either customHeaderBuilder or title must be provided for the header.');

  /// Creates an [ExpandableListTileButton] with a default header based on [ListTile].
  ///
  /// Accepts both [headerBackgroundColor]/[expandedBodyColor] (preferred) and
  /// [backgroundColor]/[expandedColor] (for backward compatibility).
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
      leading: leading,
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      customHeaderBuilder: (toggleExpansion, isExpanded, isDisabled) =>
          ListTileButton(
        onPressed: toggleExpansion,
        leading: leading,
        body: title,
        subtitle: subtitle,
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: trailingIconColor,
        ),
        backgroundColor: Colors.transparent,
        disabled: isDisabled,
      ),
    );
  }

  /// Creates an [ExpandableListTileButton] with a default header using an icon on the left.
  ///
  /// Accepts both [headerBackgroundColor]/[expandedBodyColor] (preferred) and
  /// [backgroundColor]/[expandedColor] (for backward compatibility).
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
    Color? iconColor,
    Color? trailingIconColor,
    Color? borderColor,
    double elevation = 1,
    double? leadingSizeFactor,
    EdgeInsetsGeometry? margin,
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
      leadingSizeFactor: leadingSizeFactor,
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      customHeaderBuilder: (toggleExpansion, isExpanded, isDisabled) =>
          IconListTileButton(
        icon: icon,
        iconColor: iconColor,
        leadingSizeFactor: leadingSizeFactor ?? 1.0,
        leadingPadding: leadingPadding,
        title: title,
        subtitle: subtitle,
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: trailingIconColor,
        ),
        onPressed: toggleExpansion,
        backgroundColor: Colors.transparent,
        disabled: isDisabled,
      ),
    );
  }

  /// Creates an [ExpandableListTileButton] with a completely custom header provided by [customHeaderBuilder].
  ///
  /// Accepts both [headerBackgroundColor]/[expandedBodyColor] (preferred) and
  /// [backgroundColor]/[expandedColor] (for backward compatibility).
  factory ExpandableListTileButton.custom({
    Key? key,
    required Widget expanded,
    required Widget Function(
            Function() tapAction, bool isExpanded, bool isDisabled)
        customHeaderBuilder,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor,
    Color? expandedColor,
    Color? borderColor,
    double elevation = 1,
    EdgeInsetsGeometry? margin,
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
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
    );
  }

  /// Creates a tile whose expanded content floats in an [Overlay] above other widgets.
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
      borderRadius: borderRadius,
      disabled: disabled,
      bodyAlignment: bodyAlignment,
      controller: controller,
      trailingSize: trailingSize,
      overlay: true,
      customHeaderBuilder: (toggle, isExp, isDis) => ListTileButton(
        onPressed: toggle,
        leading: leading,
        leadingSizeFactor: leadingSizeFactor,
        body: title,
        subtitle: subtitle,
        trailing: trailingSize != null
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
              ),
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
  /// Tracks the logical expansion state of the tile.
  late bool _isExpanded;

  /// Controls the animation for the expand/collapse transition.
  late AnimationController _animationController;

  /// Defines the curve and value of the size animation.
  late Animation<double> _animation;

  /// Flag indicating if the expansion state is controlled externally via [widget.controller].
  bool _isStateManagedExternally = false;

  /// Key to access the header widget's context and size.
  final GlobalKey _headerKey = GlobalKey();

  /// Stores the measured height of the header.
  double _headerHeight = 0.0;
  double _headerWidth = 0.0; // Also store header width for overlay sizing

  /// Link used to connect the header (target) to the overlay (follower).
  final LayerLink _layerLink = LayerLink();

  /// The overlay entry used when [_useOverlay] is true.
  OverlayEntry? _overlayEntry;

  /// Initializes the state, animation controller, listeners, and measures header height.
  @override
  void initState() {
    super.initState();
    _isStateManagedExternally = widget.controller != null;
    _isExpanded =
        _isStateManagedExternally ? widget.controller!.expanded : false;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Initial state for animation based on _isExpanded
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    // Add listener for animation status changes
    _animationController.addStatusListener((status) {
      // Rebuild the widget when the animation completes,
      // specifically when collapsing to ensure widget removal.
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // Only trigger setState if the expansion state is not managed externally
        // AND if the current animation status does not match the _isExpanded state
        // (e.g., if it completed dismissing but _isExpanded is still true, which shouldn't happen with proper sync)
        if (!_isStateManagedExternally && mounted) {
          // A minor optimization: only call setState if it actually changes the rendering outcome
          // i.e., if we are not expanded and the animation just finished reversing.
          if (!_isExpanded && status == AnimationStatus.dismissed) {
            setState(() {
              /* Empty setState to trigger rebuild */
            });
          }
        }
      }
    });

    if (_isStateManagedExternally) {
      widget.controller!.addListener(_handleControllerChanged);
    }

    // Schedule initial header height and width measurement after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderSize());
  }

  /// Callback function invoked when the external [ExpandableController] notifies changes.
  void _handleControllerChanged() {
    if (widget.controller?.expanded != _isExpanded && mounted) {
      _syncExpansionState(widget.controller!.expanded);
    }
  }

  /// Called when the widget configuration changes. Handles controller updates and height measurement.
  @override
  void didUpdateWidget(covariant ExpandableListTileButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _isStateManagedExternally = widget.controller != null;
      if (_isStateManagedExternally) {
        widget.controller?.removeListener(_handleControllerChanged);
        widget.controller?.addListener(_handleControllerChanged);
        // Sync state if controller changed and has a different expansion state
        if (widget.controller!.expanded != _isExpanded) {
          _syncExpansionState(widget.controller!.expanded);
        }
      }
    }
    // Re-measure header size after potentially relevant changes.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderSize());
  }

  /// Cleans up resources, primarily the animation controller and controller listener.
  @override
  void dispose() {
    _removeOverlay(); // Ensure overlay is removed on dispose
    _animationController.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  /// Measures the header's height and width using its [GlobalKey].
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
        _headerHeight = 50.0; // Estimate a reasonable default
        _headerWidth =
            MediaQuery.of(context).size.width; // Fallback to screen width
      });
    }
  }

  /// Toggles the expansion state, either by telling the controller or managing internally.
  void _toggleExpansion() {
    if (widget.disabled) return;

    if (widget._useOverlay) {
      if (_overlayEntry == null) {
        // Show overlay immediately, then start animation
        setState(() {
          _isExpanded = true;
        });
        _showOverlay(); // Create and insert overlay before animation
        _animationController.forward();
      } else {
        // Reverse animation, then remove overlay when done.
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

  /// Shows the expanded content as an [OverlayEntry].
  void _showOverlay() {
    if (_overlayEntry != null) return; // Prevent duplicate overlays
    if (_headerWidth == 0.0 || _headerHeight == 0.0) {
      // Cannot show overlay if header size is not yet measured.
      // This might happen on the very first frame. A post-frame callback will retry.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_headerWidth > 0 && _headerHeight > 0 && _overlayEntry == null) {
          _showOverlay(); // Retry after measurement
        }
      });
      return;
    }

    // Re-create actualHeaderContent for the overlay, ensuring consistency
    final Widget actualHeaderContentForOverlay =
        widget.customHeaderBuilder != null
            ? widget.customHeaderBuilder!(
                _toggleExpansion, _isExpanded, widget.disabled)
            : _buildDefaultHeader(
                context, Theme.of(context)); // Pass context and theme

    _overlayEntry = OverlayEntry(builder: (context) {
      final theme = Theme.of(context);
      final effectiveExpandedBodyColor = widget._finalExpandedBodyColor ??
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
          offset: Offset(0.0, 0.0),
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
                            top: widget.borderRadius.bottomLeft.y),
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
                color: (widget._finalHeaderBackgroundColor ?? theme.cardColor),
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
    });
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Removes the current [OverlayEntry].
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Updates the internal `_isExpanded` state and triggers the animation.
  ///
  /// This is the single point of truth for changing the visual expansion state.
  void _syncExpansionState(bool expand) {
    if (!mounted) return;
    setState(() {
      _isExpanded = expand;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  /// Builds the visual structure of the widget using the revised Stack layout.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveHeaderBgColor =
        widget._finalHeaderBackgroundColor ?? theme.cardColor;
    final effectiveExpandedBodyColor = widget._finalExpandedBodyColor ??
        theme.colorScheme.secondary.withCustomOpacity(0.1);

    // The header content. This will be drawn in the overlay if _useOverlay is true.
    // In the main tree, the CompositedTransformTarget will be a placeholder.
    final Widget actualHeaderContent = widget.customHeaderBuilder != null
        ? widget.customHeaderBuilder!(
            _toggleExpansion, _isExpanded, widget.disabled)
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
              // Only render the inline expanded body if not using overlay AND
              // if it's expanded or an animation is running.
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
                  child: widget._useOverlay && _isExpanded
                      ? const SizedBox.shrink()
                      : actualHeaderContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate default header ([ListTileButton] or [IconListTileButton] style)
  /// if a [customHeaderBuilder] was not provided.
  Widget _buildDefaultHeader(BuildContext context, ThemeData theme) {
    if (widget.icon != null && widget.title != null) {
      return IconListTileButton(
        icon: widget.icon!,
        iconColor: widget.iconColor,
        leadingSizeFactor: widget.leadingSizeFactor ?? 1.0,
        title: widget.title!,
        subtitle: widget.subtitle,
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: widget.trailingIconColor,
        ),
        onPressed: _toggleExpansion,
        backgroundColor: Colors.transparent,
        disabled: widget.disabled,
      );
    } else if (widget.title != null) {
      return ListTileButton(
        onPressed: _toggleExpansion,
        leading: widget.leading,
        body: widget.title!,
        subtitle: widget.subtitle,
        trailing: Icon(
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
/// Useful for ensuring the top of a card remains rounded while the bottom
/// can be square or have separate rounding, and also correctly drawing a border.
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
          side: BorderSide.none, // We'll paint the border manually
        );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
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
