import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/list_tile_button.dart';

/// A widget that provides an expandable list tile button with customizable headers and content.
///
/// The [ExpandableListTileButton] can be used to create a list tile that expands to reveal additional content when tapped.
/// It supports custom headers, icons, and expanded content.
///
/// Example usage:
/// ```dart
/// ExpandableListTileButton.listTile(
///   title: Text('Tap to expand'),
///   expanded: Text('Expanded content here'),
/// );
/// ```
class ExpandableListTileButton extends StatefulWidget {
  /// The content to display when the tile is expanded.
  final Widget expanded;

  /// The primary content of the tile when collapsed.
  final Widget? title;

  /// Additional content displayed below the [title] when collapsed.
  final Widget? subtitle;

  /// The background color of the tile when collapsed.
  final Color? backgroundColor;

  /// The background color of the expanded content.
  final Color? expandedColor;

  /// The color of the leading icon.
  final Color? iconColor;

  /// The color of the trailing expand/collapse icon.
  final Color? trailingIconColor;

  /// The color of the border around the tile.
  final Color? borderColor;

  /// The elevation of the tile's shadow.
  final double elevation;

  /// The leading widget of the tile, typically an icon or avatar.
  final Widget? leading;

  /// The icon data for the leading icon.
  final IconData? icon;

  /// A builder function to create a custom header widget.
  ///
  /// The function provides a [tapAction] callback and a [isExpanded] boolean to control the expansion state.
  final Widget Function(Function tapAction, bool isExpanded)? customHeader;

  /// Creates an [ExpandableListTileButton] with the given properties.
  const ExpandableListTileButton({
    super.key,
    required this.expanded,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.expandedColor,
    this.iconColor,
    this.trailingIconColor,
    this.borderColor,
    this.elevation = 4.0,
    this.leading,
    this.icon,
    this.customHeader,
  });

  /// Creates an [ExpandableListTileButton] with a default [ListTileButton] header.
  ///
  /// Example usage:
  /// ```dart
  /// ExpandableListTileButton.listTile(
  ///   title: Text('Tap to expand'),
  ///   expanded: Text('Expanded content here'),
  /// );
  /// ```
  factory ExpandableListTileButton.listTile({
    required Widget expanded,
    required Widget title,
    Widget? subtitle,
    Color? backgroundColor,
    Color? expandedColor,
    Color? trailingIconColor,
    Color? borderColor,
    double elevation = 4.0,
    Widget? leading,
  }) {
    return ExpandableListTileButton(
      expanded: expanded,
      title: title,
      subtitle: subtitle,
      backgroundColor: backgroundColor,
      expandedColor: expandedColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      elevation: elevation,
      leading: leading,
      customHeader: (toggleExpansion, isExpanded) => ListTileButton(
        onPressed: () => toggleExpansion.call(),
        leading: leading,
        body: title,
        subtitle: subtitle,
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: trailingIconColor,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Creates an [ExpandableListTileButton] with a default [IconListTileButton] header.
  ///
  /// Example usage:
  /// ```dart
  /// ExpandableListTileButton.iconListTile(
  ///   icon: Icons.info,
  ///   title: Text('Tap to expand'),
  ///   expanded: Text('Expanded content here'),
  /// );
  /// ```
  factory ExpandableListTileButton.iconListTile({
    required Widget expanded,
    required IconData icon,
    required Widget title,
    Widget? subtitle,
    Color? backgroundColor,
    Color? expandedColor,
    Color? iconColor,
    Color? trailingIconColor,
    Color? borderColor,
    double elevation = 4.0,
    double sizeFactor = 1.0,
  }) {
    return ExpandableListTileButton(
      expanded: expanded,
      title: title,
      subtitle: subtitle,
      backgroundColor: backgroundColor,
      expandedColor: expandedColor,
      icon: icon,
      iconColor: iconColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      elevation: elevation,
      customHeader: (toggleExpansion, isExpanded) => IconListTileButton(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: trailingIconColor,
        ),
        onPressed: () => toggleExpansion.call(),
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        leadingSizeFactor: sizeFactor,
      ),
    );
  }

  /// Creates an [ExpandableListTileButton] with a custom header.
  ///
  /// The [customHeader] builder function is used to create the header widget.
  ///
  /// Example usage:
  /// ```dart
  /// ExpandableListTileButton.custom(
  ///   expanded: Text('Expanded content here'),
  ///   customHeader: (toggleExpansion, isExpanded) => YourCustomHeaderWidget(),
  /// );
  /// ```
  factory ExpandableListTileButton.custom({
    required Widget expanded,
    required Widget Function(Function tapAction, bool isExpanded) customHeader,
    Color? backgroundColor,
    Color? expandedColor,
    Color? iconColor,
    Color? trailingIconColor,
    Color? borderColor,
    double elevation = 4.0,
  }) {
    return ExpandableListTileButton(
      expanded: expanded,
      backgroundColor: backgroundColor,
      expandedColor: expandedColor,
      iconColor: iconColor,
      trailingIconColor: trailingIconColor,
      borderColor: borderColor,
      elevation: elevation,
      customHeader: customHeader,
    );
  }

  @override
  State<ExpandableListTileButton> createState() =>
      _ExpandableListTileButtonState();
}

class _ExpandableListTileButtonState extends State<ExpandableListTileButton>
    with SingleTickerProviderStateMixin {
  /// Tracks the expansion state of the tile.
  bool _isExpanded = false;

  /// Controls the animation for expanding and collapsing.
  late AnimationController _controller;

  /// The animation for size transition.
  late Animation<double> _animation;

  /// The widget displayed in the expanded area.
  late Widget _bodyWidget;

  /// The height of the header widget.
  double _headerHeight = 0.0;

  /// A key to identify the header widget and measure its size.
  final GlobalKey _headerKey = GlobalKey();

  /// Initializes the state of the widget, sets up the animation controller, and measures the header height.
  @override
  void initState() {
    super.initState();
    _bodyWidget = const SizedBox();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _bodyWidget = const SizedBox();
        });
      } else if (status == AnimationStatus.forward ||
          status == AnimationStatus.completed) {
        setState(() {
          _bodyWidget = widget.expanded;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHeaderHeight();
    });
  }

  /// Updates the height of the header widget.
  void _updateHeaderHeight() {
    final RenderBox? renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      if (_headerHeight != height) {
        setState(() {
          _headerHeight = height;
        });
      }
    }
  }

  /// Called whenever the widget configuration changes.
  @override
  void didUpdateWidget(covariant ExpandableListTileButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHeaderHeight();
    });
  }

  /// Disposes the animation controller.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the expansion state of the tile and triggers the animation.
  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  /// Builds the widget tree.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: _headerHeight / 2),
          child: SizeTransition(
            sizeFactor: _animation,
            axisAlignment: 1.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.expandedColor ??
                    theme.colorScheme.secondary.withCustomOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border.all(
                  color: widget.borderColor ?? Colors.transparent,
                ),
              ),
              padding: EdgeInsets.only(top: _headerHeight / 2),
              child: _bodyWidget,
            ),
          ),
        ),
        Container(
          key: _headerKey,
          child: widget.customHeader != null
              ? widget.customHeader!(_toggleExpansion, _isExpanded)
              : _buildDefaultHeader(context, theme),
        ),
      ],
    );
  }

  /// Builds the default header if [customHeader] is not provided.
  Widget _buildDefaultHeader(BuildContext context, ThemeData theme) {
    return widget.icon != null
        ? IconListTileButton(
            icon: widget.icon!,
            iconColor: widget.iconColor ?? theme.iconTheme.color,
            title: widget.title!,
            subtitle: widget.subtitle,
            onPressed: _toggleExpansion,
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: widget.trailingIconColor ?? theme.iconTheme.color,
            ),
            backgroundColor: widget.backgroundColor ?? theme.cardColor,
          )
        : ListTileButton(
            onPressed: _toggleExpansion,
            leading: widget.leading,
            body: widget.title,
            subtitle: widget.subtitle,
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: widget.trailingIconColor ?? theme.iconTheme.color,
            ),
            backgroundColor: widget.backgroundColor ?? theme.cardColor,
          );
  }
}
