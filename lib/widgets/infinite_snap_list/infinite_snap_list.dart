import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

/// Defines how the list behaves when the user swipes.
enum SnapBehavior { singleItem, freeScroll }

/// Custom physics to force the ListView to snap perfectly to individual items,
/// with clamped velocity to prevent excessive scrolling on strong swipes.
class SnapScrollPhysics extends ScrollPhysics {
  final double itemSize;
  final SnapBehavior behavior;
  @override
  final double maxFlingVelocity;

  const SnapScrollPhysics({
    required this.itemSize,
    this.behavior = SnapBehavior.singleItem,
    this.maxFlingVelocity = 2000.0,
    super.parent,
  });

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(
      itemSize: itemSize,
      behavior: behavior,
      maxFlingVelocity: maxFlingVelocity,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position.outOfRange) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    final exactIndex = position.pixels / itemSize;
    double targetIndex;

    final throttledVelocity = velocity.clamp(
      -maxFlingVelocity,
      maxFlingVelocity,
    );

    if (behavior == SnapBehavior.singleItem) {
      if (throttledVelocity.abs() < tolerance.velocity) {
        targetIndex = exactIndex.roundToDouble();
      } else if (throttledVelocity < 0.0) {
        targetIndex = exactIndex.floorToDouble();
      } else {
        targetIndex = exactIndex.ceilToDouble();
      }
    } else {
      final Simulation? naturalSimulation = super.createBallisticSimulation(
        position,
        throttledVelocity,
      );
      if (naturalSimulation != null) {
        final naturalDestination = naturalSimulation.x(double.infinity);
        targetIndex = (naturalDestination / itemSize).roundToDouble();
      } else {
        targetIndex = exactIndex.roundToDouble();
      }
    }

    final double targetPixels = (targetIndex * itemSize).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if ((targetPixels - position.pixels).abs() < tolerance.distance &&
        velocity.abs() < tolerance.velocity) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels,
      throttledVelocity,
      tolerance: tolerance,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}

/// Controller for programmatic selection, jump, and scroll control.
class SnapListController<T> extends ChangeNotifier {
  void Function(T item)? _selectItem;
  void Function(int index)? _jumpTo;
  void Function(int index)? _animateTo;
  T? Function()? _getSelectedItem;
  int? Function()? _getSelectedIndex;

  void _attach({
    required void Function(T) selectItem,
    required void Function(int) jumpTo,
    required void Function(int) animateTo,
    required T? Function() getSelectedItem,
    required int? Function() getSelectedIndex,
  }) {
    _selectItem = selectItem;
    _jumpTo = jumpTo;
    _animateTo = animateTo;
    _getSelectedItem = getSelectedItem;
    _getSelectedIndex = getSelectedIndex;
  }

  void selectItem(T item) => _selectItem?.call(item);

  void jumpTo(int index) => _jumpTo?.call(index);

  void animateTo(int index) => _animateTo?.call(index);

  T? get selectedItem => _getSelectedItem?.call();

  int? get selectedIndex => _getSelectedIndex?.call();
}

typedef InfiniteSnapListController<T> = SnapListController<T>;

/// A gracefully animated dot indicator designed for the [SnapList] footer.
class SnapListDotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const SnapListDotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.dotSize = 8.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: currentIndex == i ? dotSize * 2.0 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: currentIndex == i ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        ),
      ),
    );
  }
}

/// A highly customizable, finite snap-scrolling list.
class SnapList<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final SnapListController<T>? controller;

  final Widget Function(
    BuildContext context,
    T item,
    int index,
    bool isSelected,
    double centerProgress,
  )
  itemBuilder;
  final void Function(T item, int index)? onItemSelected;

  final Axis scrollDirection;
  final AlignmentGeometry itemAlignment;
  final EdgeInsetsGeometry listPadding;

  final double? visibleItemCount;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;

  final double focusedItemScale;
  final double unfocusedItemScale;
  final double unfocusedItemOpacity;
  final double focusRange;
  final SnapBehavior snapBehavior;
  final double maxFlingVelocity;

  final Decoration? startEdgeDecoration;
  final Decoration? endEdgeDecoration;
  final double edgeDecorationSize;

  final Widget Function(BuildContext, double, double)?
  selectedItemOverlayBuilder;
  final Color? selectedOverlayColor;
  final BorderRadiusGeometry? selectedOverlayBorderRadius;

  final Widget Function(BuildContext context, int currentIndex, int totalCount)?
  footerBuilder;

  final String Function(T item)? semanticLabelBuilder;
  final ScrollPhysics scrollPhysics;
  final Duration snapAnimationDuration;
  final Curve snapAnimationCurve;
  final bool enableKeyboardNavigation;
  final bool lockScroll;

  const SnapList({
    super.key,
    required this.items,
    this.selectedItem,
    required this.itemBuilder,
    this.controller,
    this.onItemSelected,
    this.scrollDirection = Axis.horizontal,
    this.itemAlignment = Alignment.center,
    this.listPadding = EdgeInsets.zero,
    this.visibleItemCount,
    this.itemWidth = 60,
    this.itemHeight = 80,
    this.itemSpacing = 12,
    this.focusedItemScale = 1.0,
    this.unfocusedItemScale = 1.0,
    this.unfocusedItemOpacity = 1.0,
    this.focusRange = 1.0,
    this.snapBehavior = SnapBehavior.singleItem,
    this.maxFlingVelocity = 2000.0,
    this.startEdgeDecoration,
    this.endEdgeDecoration,
    this.edgeDecorationSize = 40.0,
    this.selectedItemOverlayBuilder,
    this.selectedOverlayColor,
    this.selectedOverlayBorderRadius,
    this.footerBuilder,
    this.semanticLabelBuilder,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOutQuart,
    this.enableKeyboardNavigation = true,
    this.lockScroll = false,
  });

  factory SnapList.carousel({
    Key? key,
    required List<T> items,
    T? selectedItem,
    required Widget Function(BuildContext, T, int, bool, double) itemBuilder,
    SnapListController<T>? controller,
    void Function(T, int)? onItemSelected,
    double itemHeight = 220,
    double itemSpacing = 16,
    double visibleItemCount = 1.2,
    double focusedItemScale = 1.0,
    double unfocusedItemScale = 0.9,
    double unfocusedItemOpacity = 0.7,
    double focusRange = 1.0,
    double maxFlingVelocity = 2000.0,
    SnapBehavior snapBehavior = SnapBehavior.singleItem,
    Decoration? startEdgeDecoration,
    Decoration? endEdgeDecoration,
    EdgeInsetsGeometry listPadding = EdgeInsets.zero,
    Widget Function(BuildContext context, int currentIndex, int totalCount)?
    footerBuilder,
  }) {
    return SnapList(
      key: key,
      items: items,
      selectedItem: selectedItem,
      itemBuilder: itemBuilder,
      controller: controller,
      onItemSelected: onItemSelected,
      visibleItemCount: visibleItemCount,
      itemHeight: itemHeight,
      itemSpacing: itemSpacing,
      focusedItemScale: focusedItemScale,
      unfocusedItemScale: unfocusedItemScale,
      unfocusedItemOpacity: unfocusedItemOpacity,
      focusRange: focusRange,
      snapBehavior: snapBehavior,
      maxFlingVelocity: maxFlingVelocity,
      startEdgeDecoration: startEdgeDecoration,
      endEdgeDecoration: endEdgeDecoration,
      listPadding: listPadding,
      footerBuilder: footerBuilder,
    );
  }

  factory SnapList.picker({
    Key? key,
    required List<T> items,
    T? selectedItem,
    required Widget Function(BuildContext, T, int, bool, double) itemBuilder,
    SnapListController<T>? controller,
    void Function(T, int)? onItemSelected,
    double itemWidth = 150,
    double visibleItemCount = 3.0,
    double focusedItemScale = 1.1,
    double unfocusedItemScale = 0.8,
    double unfocusedItemOpacity = 0.4,
    double focusRange = 1.0,
    double maxFlingVelocity = 1500.0,
    SnapBehavior snapBehavior = SnapBehavior.freeScroll,
    Widget Function(BuildContext, double, double)? selectedItemOverlayBuilder,
  }) {
    return SnapList(
      key: key,
      items: items,
      selectedItem: selectedItem,
      itemBuilder: itemBuilder,
      controller: controller,
      onItemSelected: onItemSelected,
      scrollDirection: Axis.vertical,
      visibleItemCount: visibleItemCount,
      itemWidth: itemWidth,
      itemSpacing: 0,
      focusedItemScale: focusedItemScale,
      unfocusedItemScale: unfocusedItemScale,
      unfocusedItemOpacity: unfocusedItemOpacity,
      focusRange: focusRange,
      snapBehavior: snapBehavior,
      maxFlingVelocity: maxFlingVelocity,
      selectedItemOverlayBuilder: selectedItemOverlayBuilder,
    );
  }

  @override
  State<SnapList<T>> createState() => _SnapListState<T>();
}

class _SnapListState<T> extends State<SnapList<T>> {
  late ScrollController _controller;
  bool _isInitializing = true;
  bool _isSnapping = false;
  int _lastReportedIndex = -1;
  final FocusNode _focusNode = FocusNode();

  double _currentMainAxisDim = 0;
  double _currentSlotSize = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _setupController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isInitializing = false);
        _jumpToSelectedItem();
      }
    });
  }

  void _setupController() {
    widget.controller?._attach(
      selectItem: _selectItem,
      jumpTo: _jumpTo,
      animateTo: _animateTo,
      getSelectedItem: () => widget.selectedItem,
      getSelectedIndex: () => widget.items.indexOf(widget.selectedItem as T),
    );
  }

  @override
  void didUpdateWidget(covariant SnapList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _setupController();
    }

    if (oldWidget.items != widget.items && widget.selectedItem != null) {
      final oldIndex = oldWidget.items.indexOf(widget.selectedItem as T);
      final newIndex = widget.items.indexOf(widget.selectedItem as T);

      if (oldIndex != -1 &&
          newIndex != -1 &&
          oldIndex != newIndex &&
          !_isSnapping) {
        if (_controller.hasClients) {
          final diff = newIndex - oldIndex;
          _controller.jumpTo(_controller.offset + (diff * _currentSlotSize));
        }
      } else if (oldWidget.selectedItem != widget.selectedItem &&
          !_isSnapping) {
        _animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _jumpToSelectedItem() {
    if (widget.selectedItem != null &&
        _controller.hasClients &&
        _currentSlotSize > 0) {
      final idx = widget.items.indexOf(widget.selectedItem as T);
      if (idx != -1) _controller.jumpTo(idx * _currentSlotSize);
    }
  }

  void _selectItem(T item) {
    final idx = widget.items.indexOf(item);
    if (idx != -1) _animateTo(idx);
  }

  void _jumpTo(int index) {
    if (!_controller.hasClients || index < 0 || index >= widget.items.length) {
      return;
    }
    _controller.jumpTo(index * _currentSlotSize);
  }

  void _animateTo(int index) {
    if (!_controller.hasClients || index < 0 || index >= widget.items.length) {
      return;
    }
    _isSnapping = true;
    _controller
        .animateTo(
          index * _currentSlotSize,
          duration: widget.snapAnimationDuration,
          curve: widget.snapAnimationCurve,
        )
        .whenComplete(() {
          _isSnapping = false;
        });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (_isInitializing || _currentSlotSize == 0 || widget.items.isEmpty) {
      return false;
    }

    if (notification is ScrollEndNotification) {
      final index = (_controller.offset / _currentSlotSize).round().clamp(
        0,
        widget.items.length - 1,
      );
      if (index != _lastReportedIndex && !_isSnapping) {
        _lastReportedIndex = index;
        widget.onItemSelected?.call(widget.items[index], index);
      }
    }
    return false;
  }

  Widget _defaultSelectedItemOverlayBuilder(
    BuildContext context,
    double w,
    double h,
  ) {
    final overlayColor =
        widget.selectedOverlayColor ??
        Theme.of(context).colorScheme.secondary.withCustomOpacity(0.2);
    final borderRadius =
        widget.selectedOverlayBorderRadius ?? BorderRadius.circular(8.0);
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: borderRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final selectedItemIndex = widget.items.indexOf(widget.selectedItem as T);

    return Focus(
      focusNode: widget.enableKeyboardNavigation ? _focusNode : null,
      autofocus: widget.enableKeyboardNavigation,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mainAxisLength = widget.scrollDirection == Axis.horizontal
              ? constraints.maxWidth
              : constraints.maxHeight;

          _currentMainAxisDim =
              widget.visibleItemCount != null && widget.visibleItemCount! > 0
              ? (mainAxisLength / widget.visibleItemCount!) - widget.itemSpacing
              : (widget.scrollDirection == Axis.horizontal
                    ? widget.itemWidth
                    : widget.itemHeight);

          final crossAxisDim = widget.scrollDirection == Axis.horizontal
              ? widget.itemHeight
              : widget.itemWidth;

          _currentSlotSize = _currentMainAxisDim + widget.itemSpacing;

          final startEndPadding = max(
            0.0,
            (mainAxisLength / 2) - (_currentSlotSize / 2),
          );

          final mainStack = Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: widget.itemAlignment,
                child:
                    widget.selectedItemOverlayBuilder?.call(
                      context,
                      widget.scrollDirection == Axis.horizontal
                          ? _currentMainAxisDim
                          : crossAxisDim,
                      widget.scrollDirection == Axis.horizontal
                          ? crossAxisDim
                          : _currentMainAxisDim,
                    ) ??
                    _defaultSelectedItemOverlayBuilder(
                      context,
                      widget.scrollDirection == Axis.horizontal
                          ? _currentMainAxisDim
                          : crossAxisDim,
                      widget.scrollDirection == Axis.horizontal
                          ? crossAxisDim
                          : _currentMainAxisDim,
                    ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: _onScrollNotification,
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: widget.scrollDirection,
                  physics: widget.lockScroll
                      ? const NeverScrollableScrollPhysics()
                      : SnapScrollPhysics(
                          itemSize: _currentSlotSize,
                          behavior: widget.snapBehavior,
                          maxFlingVelocity: widget.maxFlingVelocity,
                          parent: widget.scrollPhysics,
                        ),
                  padding: widget.listPadding.add(
                    widget.scrollDirection == Axis.horizontal
                        ? EdgeInsets.symmetric(horizontal: startEndPadding)
                        : EdgeInsets.symmetric(vertical: startEndPadding),
                  ),
                  itemCount: widget.items.length,
                  itemBuilder: (context, i) {
                    final isSelected = i == selectedItemIndex;

                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double progress = 0.0;
                        if (_controller.hasClients && _currentSlotSize > 0) {
                          final distance =
                              (_controller.offset - (i * _currentSlotSize))
                                  .abs();
                          final distanceInSlots = distance / _currentSlotSize;
                          progress =
                              1.0 -
                              (distanceInSlots / widget.focusRange).clamp(
                                0.0,
                                1.0,
                              );
                        } else {
                          progress = isSelected ? 1.0 : 0.0;
                        }

                        final currentScale = lerpDouble(
                          widget.unfocusedItemScale,
                          widget.focusedItemScale,
                          progress,
                        )!;
                        final currentOpacity = lerpDouble(
                          widget.unfocusedItemOpacity,
                          1.0,
                          progress,
                        )!;

                        return SizedBox(
                          width: widget.scrollDirection == Axis.horizontal
                              ? _currentSlotSize
                              : crossAxisDim,
                          height: widget.scrollDirection == Axis.vertical
                              ? _currentSlotSize
                              : crossAxisDim,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  widget.scrollDirection == Axis.horizontal
                                  ? widget.itemSpacing / 2
                                  : 0,
                              vertical: widget.scrollDirection == Axis.vertical
                                  ? widget.itemSpacing / 2
                                  : 0,
                            ),
                            child: Transform.scale(
                              scale: currentScale,
                              child: Opacity(
                                opacity: currentOpacity,
                                child: Semantics(
                                  label: widget.semanticLabelBuilder?.call(
                                    widget.items[i],
                                  ),
                                  selected: isSelected,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      if (!_isSnapping && !widget.lockScroll) {
                                        _animateTo(i);
                                      }
                                    },
                                    child: SizedBox(
                                      width:
                                          widget.scrollDirection ==
                                              Axis.horizontal
                                          ? _currentMainAxisDim
                                          : crossAxisDim,
                                      height:
                                          widget.scrollDirection ==
                                              Axis.vertical
                                          ? _currentMainAxisDim
                                          : crossAxisDim,
                                      child: widget.itemBuilder(
                                        context,
                                        widget.items[i],
                                        i,
                                        isSelected,
                                        progress,
                                      ),
                                    ),
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
              ),
              if (widget.startEdgeDecoration != null)
                Positioned(
                  left: widget.scrollDirection == Axis.horizontal ? 0 : null,
                  right: widget.scrollDirection == Axis.horizontal ? null : 0,
                  top: widget.scrollDirection == Axis.vertical ? 0 : null,
                  bottom: widget.scrollDirection == Axis.vertical ? null : 0,
                  width: widget.scrollDirection == Axis.horizontal
                      ? widget.edgeDecorationSize
                      : double.infinity,
                  height: widget.scrollDirection == Axis.vertical
                      ? widget.edgeDecorationSize
                      : double.infinity,
                  child: IgnorePointer(
                    child: Container(decoration: widget.startEdgeDecoration),
                  ),
                ),
              if (widget.endEdgeDecoration != null)
                Positioned(
                  left: widget.scrollDirection == Axis.horizontal ? null : 0,
                  right: widget.scrollDirection == Axis.horizontal ? 0 : null,
                  top: widget.scrollDirection == Axis.vertical ? null : 0,
                  bottom: widget.scrollDirection == Axis.vertical ? 0 : null,
                  width: widget.scrollDirection == Axis.horizontal
                      ? widget.edgeDecorationSize
                      : double.infinity,
                  height: widget.scrollDirection == Axis.vertical
                      ? widget.edgeDecorationSize
                      : double.infinity,
                  child: IgnorePointer(
                    child: Container(decoration: widget.endEdgeDecoration),
                  ),
                ),
            ],
          );

          if (widget.footerBuilder != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: mainStack),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final currentIndex = _controller.hasClients
                        ? (_controller.offset / _currentSlotSize).round().clamp(
                            0,
                            widget.items.length - 1,
                          )
                        : 0;
                    return widget.footerBuilder!(
                      context,
                      currentIndex,
                      widget.items.length,
                    );
                  },
                ),
              ],
            );
          }

          return mainStack;
        },
      ),
    );
  }
}

// ===========================================================================
// 3. INFINITE SNAP LIST (WRAPPER)
// ===========================================================================

/// A smart wrapper that attaches an [InfiniteSnapListBloc] to a [SnapList]
/// to provide seamless, bidirectional infinite scrolling.
class InfiniteSnapList<T> extends StatelessWidget {
  final InfiniteSnapListBloc<T> bloc;
  final InfiniteSnapListController<T>? controller;

  final Widget Function(
    BuildContext context,
    T item,
    int index,
    bool isSelected,
    double centerProgress,
  )
  itemBuilder;
  final void Function(T item, int index)? onItemSelected;

  final Axis scrollDirection;
  final AlignmentGeometry itemAlignment;
  final EdgeInsetsGeometry listPadding;

  final double? visibleItemCount;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;

  final double focusedItemScale;
  final double unfocusedItemScale;
  final double unfocusedItemOpacity;
  final double focusRange;
  final SnapBehavior snapBehavior;
  final double maxFlingVelocity;

  final Decoration? startEdgeDecoration;
  final Decoration? endEdgeDecoration;
  final double edgeDecorationSize;

  final Widget Function(BuildContext, double, double)?
  selectedItemOverlayBuilder;
  final Color? selectedOverlayColor;
  final BorderRadiusGeometry? selectedOverlayBorderRadius;

  final Widget Function(BuildContext context, int currentIndex, int totalCount)?
  footerBuilder;

  final Widget Function(BuildContext context, double width, double height)?
  loadingItemBuilder;

  final int initialItemsCountForShimmer;
  final Widget Function(BuildContext)? loadingIndicatorBuilder;
  final Widget Function(BuildContext)? emptyListBuilder;
  final Widget Function(BuildContext, Exception)? errorBuilder;

  final String Function(T item)? semanticLabelBuilder;
  final ScrollPhysics scrollPhysics;
  final Duration snapAnimationDuration;
  final Curve snapAnimationCurve;
  final bool enableKeyboardNavigation;

  const InfiniteSnapList({
    super.key,
    required this.bloc,
    required this.itemBuilder,
    this.controller,
    this.onItemSelected,
    this.scrollDirection = Axis.horizontal,
    this.itemAlignment = Alignment.center,
    this.listPadding = EdgeInsets.zero,
    this.visibleItemCount,
    this.itemWidth = 60,
    this.itemHeight = 80,
    this.itemSpacing = 12,
    this.focusedItemScale = 1.0,
    this.unfocusedItemScale = 1.0,
    this.unfocusedItemOpacity = 1.0,
    this.focusRange = 1.0,
    this.snapBehavior = SnapBehavior.freeScroll,
    this.maxFlingVelocity = 2000.0,
    this.startEdgeDecoration,
    this.endEdgeDecoration,
    this.edgeDecorationSize = 40.0,
    this.selectedItemOverlayBuilder,
    this.selectedOverlayColor,
    this.selectedOverlayBorderRadius,
    this.footerBuilder,
    this.loadingItemBuilder,
    this.initialItemsCountForShimmer = 7,
    this.loadingIndicatorBuilder,
    this.emptyListBuilder,
    this.errorBuilder,
    this.semanticLabelBuilder,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOutQuart,
    this.enableKeyboardNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfiniteSnapListBloc<T>, InfiniteSnapListState<T>>(
      bloc: bloc,
      builder: (context, state) {
        final items = state.state.items;
        final selected = state.state.selectedItem;
        final isLoading = state is ISLLoadingState<T>;
        final loadingDir = state.state.loadingDirection;

        return LayoutBuilder(
          builder: (context, constraints) {
            final mainAxis = scrollDirection == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;
            final crossAxis = scrollDirection == Axis.horizontal
                ? itemHeight
                : itemWidth;
            double mainDim = itemWidth;

            if (visibleItemCount != null && visibleItemCount! > 0) {
              mainDim = (mainAxis / visibleItemCount!) - itemSpacing;
            }

            final slotSize = mainDim + itemSpacing;
            final startEndPadding = max(0.0, (mainAxis / 2) - (slotSize / 2));

            if (state is ISLInitialState<T> ||
                (isLoading && loadingDir == LoadingDirection.initial)) {
              return _buildShimmerList(
                context,
                initialItemsCountForShimmer,
                mainDim,
                crossAxis,
                slotSize,
                startEndPadding,
              );
            }

            if (state is ISLErrorState<T>) {
              return errorBuilder?.call(context, state.error) ??
                  const SizedBox.shrink();
            }
            if (items.isEmpty) {
              return emptyListBuilder?.call(context) ?? const SizedBox.shrink();
            }

            return Stack(
              children: [
                SnapList<T>(
                  items: items,
                  selectedItem: selected,
                  controller: controller,
                  itemBuilder: itemBuilder,
                  onItemSelected: (item, index) {
                    bloc.add(SelectItemEvent<T>(item));
                    onItemSelected?.call(item, index);
                  },
                  scrollDirection: scrollDirection,
                  itemAlignment: itemAlignment,
                  listPadding: listPadding,
                  visibleItemCount: visibleItemCount,
                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                  itemSpacing: itemSpacing,
                  focusedItemScale: focusedItemScale,
                  unfocusedItemScale: unfocusedItemScale,
                  unfocusedItemOpacity: unfocusedItemOpacity,
                  focusRange: focusRange,
                  snapBehavior: snapBehavior,
                  maxFlingVelocity: maxFlingVelocity,
                  startEdgeDecoration: startEdgeDecoration,
                  endEdgeDecoration: endEdgeDecoration,
                  edgeDecorationSize: edgeDecorationSize,
                  selectedItemOverlayBuilder: selectedItemOverlayBuilder,
                  selectedOverlayColor: selectedOverlayColor,
                  selectedOverlayBorderRadius: selectedOverlayBorderRadius,
                  footerBuilder: footerBuilder,
                  semanticLabelBuilder: semanticLabelBuilder,
                  scrollPhysics: scrollPhysics,
                  snapAnimationDuration: snapAnimationDuration,
                  snapAnimationCurve: snapAnimationCurve,
                  enableKeyboardNavigation: enableKeyboardNavigation,
                  lockScroll: false,
                ),
                if (isLoading && items.isNotEmpty && loadingDir != null)
                  Positioned(
                    left:
                        scrollDirection == Axis.horizontal &&
                            loadingDir == LoadingDirection.left
                        ? 0
                        : null,
                    right:
                        scrollDirection == Axis.horizontal &&
                            loadingDir == LoadingDirection.right
                        ? 0
                        : null,
                    top: scrollDirection == Axis.horizontal
                        ? 0
                        : (loadingDir == LoadingDirection.left ? 0 : null),
                    bottom: scrollDirection == Axis.horizontal
                        ? 0
                        : (loadingDir == LoadingDirection.right ? 0 : null),
                    child: SizedBox(
                      width: scrollDirection == Axis.horizontal
                          ? startEndPadding
                          : double.infinity,
                      height: scrollDirection == Axis.vertical
                          ? startEndPadding
                          : double.infinity,
                      child: Center(
                        child:
                            loadingIndicatorBuilder?.call(context) ??
                            const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerList(
    BuildContext context,
    int count,
    double mainDim,
    double crossDim,
    double slotSize,
    double startEndPadding,
  ) {
    final initialOffset = ((count - 1) / 2) * slotSize;

    final list = ListView.builder(
      controller: ScrollController(initialScrollOffset: initialOffset),
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      padding: listPadding.add(
        scrollDirection == Axis.horizontal
            ? EdgeInsets.symmetric(horizontal: startEndPadding)
            : EdgeInsets.symmetric(vertical: startEndPadding),
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final width = scrollDirection == Axis.horizontal ? mainDim : crossDim;
        final height = scrollDirection == Axis.vertical ? mainDim : crossDim;

        final core = loadingItemBuilder != null
            ? loadingItemBuilder!(context, width, height)
            : Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              );

        return SizedBox(
          width: scrollDirection == Axis.horizontal ? slotSize : crossDim,
          height: scrollDirection == Axis.vertical ? slotSize : crossDim,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: scrollDirection == Axis.horizontal
                  ? itemSpacing / 2
                  : 0,
              vertical: scrollDirection == Axis.vertical ? itemSpacing / 2 : 0,
            ),
            child: core,
          ),
        );
      },
    );

    if (loadingItemBuilder != null) return list;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: list,
    );
  }
}
