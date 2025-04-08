import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

// Assuming ListTileButton and IconListTileButton are imported correctly below
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

  // Internal fields to store the resolved background colors, prioritizing new parameters.
  final Color? _finalHeaderBackgroundColor;
  final Color? _finalExpandedBodyColor;

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
    this.backgroundColor, // Kept for backward compatibility
    this.expandedColor, // Kept for backward compatibility
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
  })  : _finalHeaderBackgroundColor = headerBackgroundColor ?? backgroundColor,
        // Prioritize new name
        _finalExpandedBodyColor = expandedBodyColor ?? expandedColor,
        // Prioritize new name
        assert(customHeaderBuilder != null || title != null,
            'Either customHeaderBuilder or title must be provided for the header.');

  /// Creates an [ExpandableListTileButton] with a default header based on [ListTile].
  /// Accepts both [headerBackgroundColor]/[expandedBodyColor] (preferred) and
  /// [backgroundColor]/[expandedColor] (for backward compatibility).
  factory ExpandableListTileButton.listTile({
    Key? key,
    required Widget expanded,
    required Widget title,
    Widget? subtitle,
    Color? headerBackgroundColor,
    Color? expandedBodyColor,
    Color? backgroundColor, // Kept for backward compatibility
    Color? expandedColor, // Kept for backward compatibility
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
    Color? backgroundColor, // Kept for backward compatibility
    Color? expandedColor, // Kept for backward compatibility
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
    Color? backgroundColor, // Kept for backward compatibility
    Color? expandedColor, // Kept for backward compatibility
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
  double _headerHeight = 0.0; // Default height, updated after first frame

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

    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    if (_isStateManagedExternally) {
      widget.controller!.addListener(_handleControllerChanged);
    }

    // Measure header height after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderHeight());
  }

  /// Callback function invoked when the external [ExpandableController] notifies changes.
  void _handleControllerChanged() {
    if (widget.controller?.expanded != _isExpanded && mounted) {
      _syncExpansionState(widget.controller!.expanded);
    }
  }

  /// Called when the widget configuration changes. Handles controller updates and header height measurement.
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
    // Re-measure header height after potentially relevant changes.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderHeight());
  }

  /// Cleans up resources, primarily the animation controller and controller listener.
  @override
  void dispose() {
    _animationController.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  /// Measures the header's height using its GlobalKey.
  void _updateHeaderHeight() {
    final RenderBox? renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final currentHeight = renderBox.size.height;
      if (_headerHeight != currentHeight && mounted) {
        // Use a minimal height if measured height is too small,
        // e.g., during initial layout phases.
        // Also consider adding a small buffer if needed.
        setState(() {
          _headerHeight = currentHeight > 10
              ? currentHeight
              : 50.0; // Example fallback/minimum
        });
      }
    } else if (_headerHeight == 0.0 && mounted) {
      // Fallback if measurement fails initially
      setState(() {
        _headerHeight = 50.0; // Estimate a reasonable default
      });
    }
  }

  /// Toggles the expansion state, either by telling the controller or managing internally.
  void _toggleExpansion() {
    if (widget.disabled) return;

    if (_isStateManagedExternally) {
      widget.controller!.toggle();
    } else {
      _syncExpansionState(!_isExpanded);
    }
  }

  /// Updates the internal `_isExpanded` state and triggers the animation.
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
    // Use the resolved background colors stored in the final fields
    final effectiveHeaderBgColor =
        widget._finalHeaderBackgroundColor ?? theme.cardColor;
    final effectiveExpandedBodyColor = widget._finalExpandedBodyColor ??
        theme.colorScheme.secondary.withCustomOpacity(0.1);

    final headerWidget = widget.customHeaderBuilder != null
        ? widget.customHeaderBuilder!(
            _toggleExpansion, _isExpanded, widget.disabled)
        : _buildDefaultHeader(context, theme);

    // Calculate padding values, potentially adjusting for border radius
    // Using half height might be a good starting point as per original logic.
    // Experiment with this value if the visual gap persists.
    final double topPaddingValue = _headerHeight / 2.0;
    // final double overlap = widget.borderRadius.bottomLeft.y / 2.0; // Alternative idea
    // final double topPaddingValue = _headerHeight - overlap; // Alternative idea

    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Container(
          margin: widget.margin,
          // No outer Material needed, header and body handle their appearance.
          child: Stack(
            children: [
              // --- Body Section (Animated & Padded) ---
              // Pad the SizeTransition down to position it below the header area
              Padding(
                padding: EdgeInsets.only(top: topPaddingValue),
                // Position below header center-line
                child: SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  // axisAlignment: 1.0, // Try original alignment?
                  axisAlignment: -1.0, // Animate from its top edge
                  child: Container(
                    // Body Container
                    clipBehavior: Clip.antiAlias,
                    // Clip internal content if needed
                    decoration: BoxDecoration(
                      color: effectiveExpandedBodyColor,
                      // Body needs bottom corners rounded to match overall shape
                      borderRadius: BorderRadius.only(
                        bottomLeft: widget.borderRadius.bottomLeft,
                        bottomRight: widget.borderRadius.bottomRight,
                      ),
                    ),
                    alignment: widget.bodyAlignment,
                    // Add internal padding to push content below header visually
                    padding: EdgeInsets.only(top: topPaddingValue),
                    // Push content down
                    child: widget.expanded, // Body content
                  ),
                ),
              ),
              // --- Header Section (Always Visible & Rounded) ---
              // Use Material for header's shape, elevation, and color
              Material(
                key: _headerKey,
                // Assign key to measure height
                elevation: widget.elevation,
                color: effectiveHeaderBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.borderRadius, // Always fully rounded
                  side: widget.borderColor != null
                      ? BorderSide(color: widget.borderColor!)
                      : BorderSide.none,
                ),
                clipBehavior: Clip.antiAlias,
                child: headerWidget, // The actual header widget
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate default header (ListTile or IconListTile style)
  /// if a [customHeaderBuilder] was not provided.
  Widget _buildDefaultHeader(BuildContext context, ThemeData theme) {
    // Ensure you have imported ListTileButton and IconListTileButton correctly
    if (widget.icon != null && widget.title != null) {
      // Build IconListTile style header
      return IconListTileButton(
        // Assuming IconListTileButton is imported
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
        // Background is handled by the Material wrapping this header
        backgroundColor: Colors.transparent,
        // Pass disabled state down
        disabled: widget.disabled,
        // Ensure internal elements like ListTile handle disabled state if needed
      );
    } else if (widget.title != null) {
      // Build ListTile style header
      return ListTileButton(
        // Assuming ListTileButton is imported
        onPressed: _toggleExpansion,
        leading: widget.leading,
        body: widget.title,
        subtitle: widget.subtitle,
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: widget.trailingIconColor,
        ),
        // Background is handled by the Material wrapping this header
        backgroundColor: Colors.transparent,
        // Pass disabled state down
        disabled: widget.disabled,
        // Ensure internal elements like ListTile handle disabled state if needed
      );
    } else {
      // Fallback (should not be reached due to assertion)
      return const SizedBox.shrink();
    }
  }
}
