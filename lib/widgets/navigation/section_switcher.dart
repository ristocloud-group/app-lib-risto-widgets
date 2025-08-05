import 'package:flutter/material.dart';

import 'custom_bottom_navbar.dart';

// -----------------------------------------------------------------------------
// Style Class
// -----------------------------------------------------------------------------

/// Defines the visual configuration for a [SegmentedControl] widget.
///
/// This class encapsulates all styling properties, allowing for a clean separation
/// between the widget's logic and its appearance. An instance of this class
/// can be passed to the [SegmentedControl.style] property.
///
/// For a convenient way to create a style, use the [SegmentedControl.styleFrom]
/// static method.
class SegmentedControlStyle {
  /// The border radius for the outer track and the inner sliding indicator.
  ///
  /// If null, defaults to a circular shape.
  final BorderRadius? borderRadius;

  /// The color of the border around the track.
  ///
  /// If null, no border is drawn.
  final Color? borderColor;

  /// The width of the border around the track.
  ///
  /// Defaults to `1.0`.
  final double borderWidth;

  /// The background color of the main track.
  ///
  /// Defaults to `Theme.of(context).colorScheme.surfaceContainerHighest`.
  final Color? backgroundColor;

  /// The inner padding of the track, creating space between the border
  /// and the segments area.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 4, vertical: 2)`.
  final EdgeInsets padding;

  /// The elevation of the main track, used to cast a shadow.
  ///
  /// Defaults to `0.0`.
  final double elevation;

  /// The background color of the sliding indicator.
  ///
  /// Defaults to `Colors.white`.
  final Color? indicatorColor;

  /// The margin around the sliding indicator, creating a gap between it and
  /// the track.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets? indicatorMargin;

  /// The elevation of the sliding indicator, used to cast a shadow.
  ///
  /// Defaults to `0.0`.
  final double indicatorElevation;

  /// The text style for the segments that are not currently selected.
  ///
  /// Defaults to a style derived from the theme's `labelMedium`.
  final TextStyle? unselectedTextStyle;

  /// The text style for the currently selected segment.
  ///
  /// Defaults to a bold style derived from the theme's `labelMedium`.
  final TextStyle? selectedTextStyle;

  /// Creates a style object for the [SegmentedControl].
  const SegmentedControlStyle({
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.elevation = 0.0,
    this.indicatorColor,
    this.indicatorMargin,
    this.indicatorElevation = 0.0,
    this.unselectedTextStyle,
    this.selectedTextStyle,
  });
}

// -----------------------------------------------------------------------------
// Segmented Control Widget
// -----------------------------------------------------------------------------

/// A highly customizable animated segmented control widget.
///
/// This widget displays a horizontal row of segments and animates a selection
/// indicator between them. It is fully configurable through the [style]
/// property, which takes a [SegmentedControlStyle] object.
///
/// {@tool snippet}
/// Basic usage:
///
/// ```dart
/// SegmentedControl(
///   segments: const [
///     Text('First'),
///     Text('Second'),
///   ],
///   onSegmentSelected: (index) {
///     // Handle selection change
///   },
///   style: SegmentedControl.styleFrom(
///     backgroundColor: Colors.grey.shade300,
///     indicatorColor: Colors.orange,
///     indicatorElevation: 2,
///   ),
/// )
/// ```
/// {@end-tool}
class SegmentedControl extends StatefulWidget {
  /// The list of widgets to display as the segments.
  ///
  /// Typically a list of [Text], [Icon], or [Row] widgets.
  final List<Widget> segments;

  /// The index of the segment that is selected by default.
  ///
  /// Defaults to `0`.
  final int initialIndex;

  /// A callback that is invoked when a new segment is tapped and selected.
  ///
  /// The callback receives the index of the newly selected segment.
  final ValueChanged<int>? onSegmentSelected;

  /// The duration of the animation when sliding the indicator between segments.
  ///
  /// Defaults to `300 milliseconds`.
  final Duration duration;

  /// The curve to use for the indicator's sliding animation.
  ///
  /// Defaults to [Curves.easeInOut].
  final Curve curve;

  /// The visual style configuration for the control.
  ///
  /// Use [SegmentedControlStyle] to define the appearance. For convenience,
  /// create a style using the [SegmentedControl.styleFrom] static method.
  final SegmentedControlStyle style;

  /// Creates a customizable animated segmented control.
  const SegmentedControl({
    super.key,
    required this.segments,
    this.initialIndex = 0,
    this.onSegmentSelected,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.style = const SegmentedControlStyle(),
  }) : assert(segments.length > 1, 'At least two segments required');

  /// A helper method to create a [SegmentedControlStyle] from a set of
  /// individual properties, similar to [ElevatedButton.styleFrom].
  ///
  /// This is a convenient way to customize the control's appearance without
  /// instantiating a [SegmentedControlStyle] object directly.
  static SegmentedControlStyle styleFrom({
    // Track styling
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    EdgeInsets? padding,
    double? elevation,
    // Indicator styling
    Color? indicatorColor,
    EdgeInsets? indicatorMargin,
    double? indicatorElevation,
    // Text styling
    TextStyle? unselectedTextStyle,
    TextStyle? selectedTextStyle,
  }) {
    return SegmentedControlStyle(
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth ?? 1.0,
      backgroundColor: backgroundColor,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      elevation: elevation ?? 0.0,
      indicatorColor: indicatorColor,
      indicatorMargin: indicatorMargin,
      indicatorElevation: indicatorElevation ?? 0.0,
      unselectedTextStyle: unselectedTextStyle,
      selectedTextStyle: selectedTextStyle,
    );
  }

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant SegmentedControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      widget.onSegmentSelected?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final primary =
        style.indicatorColor ?? Theme.of(context).colorScheme.primary;
    final backCol = style.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final radius = style.borderRadius ?? BorderRadius.circular(999);
    final unselectedStyle = style.unselectedTextStyle ??
        Theme.of(context).textTheme.labelMedium!.copyWith(color: primary);
    final selectedStyle = style.selectedTextStyle ??
        Theme.of(context).textTheme.labelMedium!.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            );

    return LayoutBuilder(
      builder: (context, constraints) {
        final height =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 40.0;
        final totalWidth = constraints.maxWidth;
        final count = widget.segments.length;
        final indicatorWidth = (totalWidth - style.padding.horizontal) / count;
        final innerHeight = height - style.padding.vertical;
        final margin = style.indicatorMargin ?? EdgeInsets.zero;

        return Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          elevation: style.elevation,
          color: backCol,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: style.borderColor != null
                ? BorderSide(
                    color: style.borderColor!, width: style.borderWidth)
                : BorderSide.none,
          ),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: style.padding,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: _currentIndex * indicatorWidth + margin.left,
                    top: margin.top,
                    duration: widget.duration,
                    curve: widget.curve,
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: style.indicatorElevation,
                      color: style.indicatorColor ?? Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: radius),
                      child: SizedBox(
                        width: indicatorWidth - margin.horizontal,
                        height: innerHeight - margin.vertical,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(count, (index) {
                      return Expanded(
                        child: InkWell(
                          borderRadius: radius,
                          onTap: () => _onTap(index),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: widget.duration,
                              style: _currentIndex == index
                                  ? selectedStyle
                                  : unselectedStyle,
                              child: widget.segments[index],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Section Switcher Widget
// -----------------------------------------------------------------------------

/// A composite widget that combines a [SegmentedControl] with an
/// [AnimatedSwitcher] to create a seamless, tab-like interface.
///
/// It takes a list of [NavigationItem]s and manages the state for displaying
/// the correct page content when a segment is selected.
///
/// {@tool snippet}
/// An example of creating a `SectionSwitcher` with three items.
///
/// ```dart
/// final _items = [
///   NavigationItem(
///     page: Center(child: Text('Home Page')),
///     icon: Icon(Icons.home),
///     label: 'Home',
///   ),
///   NavigationItem(
///     page: Center(child: Text('Search Page')),
///     icon: Icon(Icons.search),
///     label: 'Search',
///   ),
///   NavigationItem(
///     page: Center(child: Text('Profile Page')),
///     icon: Icon(Icons.person),
///     label: 'Profile',
///   ),
/// ];
///
/// SectionSwitcher(
///   items: _items,
///   segmentedControlStyle: SegmentedControl.styleFrom(
///     backgroundColor: Colors.grey.shade200,
///     indicatorColor: Colors.white,
///   ),
/// )
/// ```
/// {@end-tool}
class SectionSwitcher extends StatefulWidget {
  /// A list of [NavigationItem] objects, each defining a page and its
  /// corresponding segment appearance (icon and label).
  final List<NavigationItem> items;

  /// The index of the item and page to display initially. Defaults to `0`.
  final int initialIndex;

  /// The height of the [SegmentedControl] bar. Defaults to `40.0`.
  final double segmentedHeight;

  /// The horizontal spacing between the icon and label within each segment.
  /// Defaults to `4.0`.
  final double segmentedItemSpacing;

  /// The padding applied around the page content area, below the control bar.
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets contentPadding;

  /// The outer margin surrounding the [SegmentedControl] bar. Defaults to
  /// `EdgeInsets.zero`.
  final EdgeInsets segmentedMargin;

  /// The style to apply to the [SegmentedControl].
  ///
  /// Use [SegmentedControl.styleFrom] for convenient customization. If null,
  /// the default style of [SegmentedControl] is used.
  final SegmentedControlStyle? segmentedControlStyle;

  /// The duration for all animations, including the indicator slide and the
  /// page cross-fade. Defaults to `300 milliseconds`.
  final Duration duration;

  /// The animation curve used for all transitions. Defaults to [Curves.easeInOut].
  final Curve curve;

  /// Creates a section switcher widget.
  const SectionSwitcher({
    super.key,
    required this.items,
    this.initialIndex = 0,
    // Layout
    this.segmentedHeight = 40.0,
    this.segmentedItemSpacing = 4.0,
    this.contentPadding = EdgeInsets.zero,
    this.segmentedMargin = EdgeInsets.zero,
    // Style
    this.segmentedControlStyle,
    // Animation
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : assert(items.length > 1, 'At least two items required');

  @override
  State<SectionSwitcher> createState() => _SectionSwitcherState();
}

class _SectionSwitcherState extends State<SectionSwitcher> {
  late int _selectedIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _previousIndex = widget.initialIndex;
  }

  void _onSegmentSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.items.map((nav) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nav.icon,
          SizedBox(width: widget.segmentedItemSpacing),
          Text(nav.label),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: widget.segmentedMargin,
          height: widget.segmentedHeight,
          child: SegmentedControl(
            segments: segments,
            initialIndex: _selectedIndex,
            onSegmentSelected: _onSegmentSelected,
            duration: widget.duration,
            curve: widget.curve,
            style:
                widget.segmentedControlStyle ?? const SegmentedControlStyle(),
          ),
        ),
        Padding(
          padding: widget.contentPadding,
          child: AnimatedSwitcher(
            duration: widget.duration,
            switchInCurve: widget.curve,
            switchOutCurve: widget.curve,
            layoutBuilder: (current, previous) => Stack(
              clipBehavior: Clip.none,
              children: [
                if (current != null) current,
                ...previous,
              ],
            ),
            transitionBuilder: (child, animation) {
              final isIncoming = child.key == ValueKey<int>(_selectedIndex);
              final enter = _selectedIndex > _previousIndex
                  ? const Offset(1, 0)
                  : const Offset(-1, 0);
              final exit = _selectedIndex > _previousIndex
                  ? const Offset(-1, 0)
                  : const Offset(1, 0);
              final tween = isIncoming
                  ? Tween<Offset>(begin: enter, end: Offset.zero)
                  : Tween<Offset>(begin: Offset.zero, end: exit);
              final anim = isIncoming ? animation : ReverseAnimation(animation);

              return SlideTransition(
                position:
                    anim.drive(tween.chain(CurveTween(curve: widget.curve))),
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_selectedIndex),
              child: widget.items[_selectedIndex].page,
            ),
          ),
        ),
      ],
    );
  }
}
