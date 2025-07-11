import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import 'custom_bottom_navbar.dart';

/// A reusable segmented control for toggling between options.
/// Supports custom segments, animations, and styling.
class SegmentedControl extends StatefulWidget {
  final List<Widget> segments;
  final int initialIndex;
  final ValueChanged<int>? onSegmentSelected;

  // Animation
  final Duration duration;
  final Curve curve;

  // Track styling
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final EdgeInsets padding;

  // Indicator styling
  final Color? indicatorColor;
  final List<BoxShadow>? indicatorShadow;
  final EdgeInsets? indicatorMargin;

  // Text styling
  final TextStyle? unselectedTextStyle;
  final TextStyle? selectedTextStyle;

  const SegmentedControl({
    super.key,
    required this.segments,
    this.initialIndex = 0,
    this.onSegmentSelected,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.indicatorColor,
    this.indicatorShadow,
    this.indicatorMargin,
    this.unselectedTextStyle,
    this.selectedTextStyle,
  }) : assert(segments.length > 1, 'At least two segments required');

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
    final primary =
        widget.indicatorColor ?? Theme.of(context).colorScheme.primary;
    final backCol = widget.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final radius = widget.borderRadius ?? BorderRadius.circular(999);
    final unselectedStyle = widget.unselectedTextStyle ??
        Theme.of(context).textTheme.labelMedium!.copyWith(color: primary);
    final selectedStyle = widget.selectedTextStyle ??
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
        final indicatorWidth = (totalWidth - widget.padding.horizontal) / count;
        final innerHeight = height - widget.padding.vertical;
        final margin = widget.indicatorMargin ?? EdgeInsets.zero;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backCol,
            borderRadius: radius,
            border: widget.borderColor != null
                ? Border.all(
                    color: widget.borderColor!, width: widget.borderWidth)
                : null,
          ),
          child: Padding(
            padding: widget.padding,
            child: Stack(
              children: [
                AnimatedPositioned(
                  left: _currentIndex * indicatorWidth + margin.left,
                  top: margin.top,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Container(
                    width: indicatorWidth - margin.horizontal,
                    height: innerHeight - margin.vertical,
                    decoration: BoxDecoration(
                      color: widget.indicatorColor ?? Colors.white,
                      borderRadius: radius,
                      boxShadow: widget.indicatorShadow ??
                          [
                            BoxShadow(
                              color: Colors.black.withCustomOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
        );
      },
    );
  }
}

/// A section switcher that displays a [SegmentedControl] and changes
/// the content below it. Content height adjusts dynamically and
/// pages slide locked side-by-side in correct directions.
class SectionSwitcher extends StatefulWidget {
  final List<NavigationItem> items;
  final int initialIndex;

  // SegmentedControl customization
  final Color? segmentedBackgroundColor;
  final Color? segmentedIndicatorColor;
  final List<BoxShadow>? segmentedIndicatorShadow;
  final EdgeInsets? segmentedIndicatorMargin;
  final TextStyle? segmentedUnselectedTextStyle;
  final TextStyle? segmentedSelectedTextStyle;

  // Animation & layout
  final Duration duration;
  final Curve curve;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;

  const SectionSwitcher({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.segmentedBackgroundColor,
    this.segmentedIndicatorColor,
    this.segmentedIndicatorShadow,
    this.segmentedIndicatorMargin,
    this.segmentedUnselectedTextStyle,
    this.segmentedSelectedTextStyle,
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
    final segments = widget.items
        .map((nav) => Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [nav.icon, const SizedBox(width: 4), Text(nav.label)],
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: widget.padding,
          child: SizedBox(
            height: 40,
            child: SegmentedControl(
              segments: segments,
              initialIndex: _selectedIndex,
              onSegmentSelected: _onSegmentSelected,
              duration: widget.duration,
              curve: widget.curve,
              borderRadius: widget.borderRadius,
              borderColor: widget.borderColor,
              borderWidth: widget.borderWidth,
              backgroundColor: widget.segmentedBackgroundColor,
              indicatorColor: widget.segmentedIndicatorColor,
              indicatorShadow: widget.segmentedIndicatorShadow,
              indicatorMargin: widget.segmentedIndicatorMargin,
              unselectedTextStyle: widget.segmentedUnselectedTextStyle,
              selectedTextStyle: widget.segmentedSelectedTextStyle,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        AnimatedSwitcher(
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
            final enterOffset = _selectedIndex > _previousIndex
                ? const Offset(1, 0)
                : const Offset(-1, 0);
            final exitOffset = _selectedIndex > _previousIndex
                ? const Offset(-1, 0)
                : const Offset(1, 0);

            final tween = isIncoming
                ? Tween<Offset>(begin: enterOffset, end: Offset.zero)
                : Tween<Offset>(begin: Offset.zero, end: exitOffset);
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
      ],
    );
  }
}
