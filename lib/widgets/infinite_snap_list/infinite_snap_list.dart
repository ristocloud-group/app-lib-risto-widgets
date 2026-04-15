import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

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
  final Duration snapTimerDuration;
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
    this.snapTimerDuration = const Duration(milliseconds: 150),
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
      selectedItemOverlayBuilder: selectedItemOverlayBuilder,
    );
  }

  @override
  State<SnapList<T>> createState() => _SnapListState<T>();
}

class _SnapListState<T> extends State<SnapList<T>> {
  late ScrollController _controller;
  Timer? _snapTimer;
  bool _isInitializing = true;
  bool _isSnapping = false;
  final FocusNode _focusNode = FocusNode();

  double _currentActualMainAxis = 0;
  double _currentStartEndPadding = 0;

  double _calculatedItemMainAxisDim(double constraintsMainAxis) {
    if (widget.visibleItemCount != null && widget.visibleItemCount! > 0) {
      return (constraintsMainAxis / widget.visibleItemCount!) -
          widget.itemSpacing;
    }
    return widget.scrollDirection == Axis.horizontal
        ? widget.itemWidth
        : widget.itemHeight;
  }

  double _calculatedItemCrossAxisDim() {
    return widget.scrollDirection == Axis.horizontal
        ? widget.itemHeight
        : widget.itemWidth;
  }

  double _totalItemSlotMainAxis(double constraintsMainAxis) =>
      _calculatedItemMainAxisDim(constraintsMainAxis) + widget.itemSpacing;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
    widget.controller?._attach(
      selectItem: _selectItem,
      jumpTo: _jumpTo,
      animateTo: _animateTo,
      getSelectedItem: () => widget.selectedItem,
      getSelectedIndex: () => widget.items.indexOf(widget.selectedItem as T),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isInitializing = false);
        _jumpToSelectedItem();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SnapList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._attach(
        selectItem: _selectItem,
        jumpTo: _jumpTo,
        animateTo: _animateTo,
        getSelectedItem: () => widget.selectedItem,
        getSelectedIndex: () => widget.items.indexOf(widget.selectedItem as T),
      );
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
          _controller.jumpTo(
            _controller.offset +
                (diff * _totalItemSlotMainAxis(_currentActualMainAxis)),
          );
        }
      } else if (oldWidget.selectedItem != widget.selectedItem &&
          !_isSnapping) {
        _animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _jumpToSelectedItem() {
    if (widget.selectedItem != null && _controller.hasClients) {
      final idx = widget.items.indexOf(widget.selectedItem as T);
      if (idx != -1) _jumpTo(idx);
    }
  }

  void _selectItem(T item) {
    final idx = widget.items.indexOf(item);
    if (idx != -1) _snapTo(idx, animate: true);
  }

  void _jumpTo(int index) {
    if (!_controller.hasClients || index < 0 || index >= widget.items.length) {
      return;
    }
    _controller.jumpTo(_calculateTargetOffset(index));
  }

  void _animateTo(int index) {
    if (!_controller.hasClients || index < 0 || index >= widget.items.length) {
      return;
    }
    _controller.animateTo(
      _calculateTargetOffset(index),
      duration: widget.snapAnimationDuration,
      curve: widget.snapAnimationCurve,
    );
  }

  double _calculateTargetOffset(int index) {
    final listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;
    return listPaddingStart +
        _currentStartEndPadding +
        (index * _totalItemSlotMainAxis(_currentActualMainAxis)) +
        (widget.itemSpacing / 2) +
        (_calculatedItemMainAxisDim(_currentActualMainAxis) / 2) -
        (_currentActualMainAxis / 2);
  }

  int _getClosestIndex(double mainAxis) {
    if (!_controller.hasClients || mainAxis == 0 || widget.items.isEmpty) {
      return widget.items
          .indexOf(widget.selectedItem as T)
          .clamp(0, max(0, widget.items.length - 1));
    }
    final listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;
    final viewportCenterInScrollExtent =
        _controller.offset +
        (mainAxis / 2) -
        listPaddingStart -
        _currentStartEndPadding;

    double minDist = double.infinity;
    int closestIdx = 0;
    for (int i = 0; i < widget.items.length; i++) {
      final itemCenter =
          (i * _totalItemSlotMainAxis(mainAxis)) +
          (widget.itemSpacing / 2) +
          (_calculatedItemMainAxisDim(mainAxis) / 2);
      final distance = (itemCenter - viewportCenterInScrollExtent).abs();
      if (distance < minDist) {
        minDist = distance;
        closestIdx = i;
      }
    }
    return closestIdx;
  }

  void _onScroll() {
    if (_isInitializing ||
        _isSnapping ||
        _currentActualMainAxis == 0 ||
        !_controller.position.hasContentDimensions) {
      return;
    }
    if (widget.items.isEmpty) return;

    final closestIdx = _getClosestIndex(_currentActualMainAxis);
    _snapTimer?.cancel();
    _snapTimer = Timer(widget.snapTimerDuration, () => _snapTo(closestIdx));
  }

  void _snapTo(int index, {bool animate = true}) {
    if (index < 0 ||
        index >= widget.items.length ||
        !_controller.hasClients ||
        _currentActualMainAxis == 0) {
      return;
    }

    final clampedTarget = _calculateTargetOffset(
      index,
    ).clamp(0.0, _controller.position.maxScrollExtent);

    _isSnapping = true;
    final snapFuture = animate
        ? _controller.animateTo(
            clampedTarget,
            duration: widget.snapAnimationDuration,
            curve: widget.snapAnimationCurve,
          )
        : Future(() => _controller.jumpTo(clampedTarget));

    snapFuture.whenComplete(() {
      _isSnapping = false;
      widget.onItemSelected?.call(widget.items[index], index);
    });
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
          _currentActualMainAxis = widget.scrollDirection == Axis.horizontal
              ? constraints.maxWidth
              : constraints.maxHeight;
          final itemMainAxisDim = _calculatedItemMainAxisDim(
            _currentActualMainAxis,
          );
          final itemCrossAxisDim = _calculatedItemCrossAxisDim();

          _currentStartEndPadding = max(
            0.0,
            (_currentActualMainAxis / 2) -
                (_totalItemSlotMainAxis(_currentActualMainAxis) / 2),
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
                          ? itemMainAxisDim
                          : itemCrossAxisDim,
                      widget.scrollDirection == Axis.horizontal
                          ? itemCrossAxisDim
                          : itemMainAxisDim,
                    ) ??
                    _defaultSelectedItemOverlayBuilder(
                      context,
                      widget.scrollDirection == Axis.horizontal
                          ? itemMainAxisDim
                          : itemCrossAxisDim,
                      widget.scrollDirection == Axis.horizontal
                          ? itemCrossAxisDim
                          : itemMainAxisDim,
                    ),
              ),

              ListView.builder(
                controller: _controller,
                scrollDirection: widget.scrollDirection,
                physics: (_isSnapping || widget.lockScroll)
                    ? const NeverScrollableScrollPhysics()
                    : widget.scrollPhysics,
                padding: widget.listPadding.add(
                  widget.scrollDirection == Axis.horizontal
                      ? EdgeInsets.symmetric(
                          horizontal: _currentStartEndPadding,
                        )
                      : EdgeInsets.symmetric(vertical: _currentStartEndPadding),
                ),
                itemCount: widget.items.length,
                itemBuilder: (context, i) {
                  final isSelected = i == selectedItemIndex;

                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double progress = 0.0;
                      if (_controller.hasClients &&
                          _currentActualMainAxis > 0) {
                        final itemOffset = _calculateTargetOffset(i);
                        final distance = (_controller.offset - itemOffset)
                            .abs();
                        final slotSize = _totalItemSlotMainAxis(
                          _currentActualMainAxis,
                        );
                        progress = 1.0 - (distance / slotSize).clamp(0.0, 1.0);
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
                            ? _totalItemSlotMainAxis(_currentActualMainAxis)
                            : itemCrossAxisDim,
                        height: widget.scrollDirection == Axis.vertical
                            ? _totalItemSlotMainAxis(_currentActualMainAxis)
                            : itemCrossAxisDim,
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
                                      _snapTo(i);
                                    }
                                  },
                                  child: SizedBox(
                                    width:
                                        widget.scrollDirection ==
                                            Axis.horizontal
                                        ? itemMainAxisDim
                                        : itemCrossAxisDim,
                                    height:
                                        widget.scrollDirection == Axis.vertical
                                        ? itemMainAxisDim
                                        : itemCrossAxisDim,
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

              if (widget.startEdgeDecoration != null)
                Positioned(
                  left: widget.scrollDirection == Axis.horizontal ? 0 : 0,
                  right: widget.scrollDirection == Axis.horizontal ? null : 0,
                  top: widget.scrollDirection == Axis.vertical ? 0 : 0,
                  bottom: widget.scrollDirection == Axis.vertical ? null : 0,
                  width: widget.scrollDirection == Axis.horizontal
                      ? widget.edgeDecorationSize
                      : null,
                  height: widget.scrollDirection == Axis.vertical
                      ? widget.edgeDecorationSize
                      : null,
                  child: IgnorePointer(
                    child: Container(decoration: widget.startEdgeDecoration),
                  ),
                ),
              if (widget.endEdgeDecoration != null)
                Positioned(
                  left: widget.scrollDirection == Axis.horizontal ? null : 0,
                  right: widget.scrollDirection == Axis.horizontal ? 0 : 0,
                  top: widget.scrollDirection == Axis.vertical ? null : 0,
                  bottom: widget.scrollDirection == Axis.vertical ? 0 : 0,
                  width: widget.scrollDirection == Axis.horizontal
                      ? widget.edgeDecorationSize
                      : null,
                  height: widget.scrollDirection == Axis.vertical
                      ? widget.edgeDecorationSize
                      : null,
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
                    final currentIndex = _getClosestIndex(
                      _currentActualMainAxis,
                    );
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

  final Decoration? startEdgeDecoration;
  final Decoration? endEdgeDecoration;
  final double edgeDecorationSize;

  final Widget Function(BuildContext, double, double)?
  selectedItemOverlayBuilder;
  final Color? selectedOverlayColor;
  final BorderRadiusGeometry? selectedOverlayBorderRadius;

  final Widget Function(BuildContext context, int currentIndex, int totalCount)?
  footerBuilder;

  /// A builder for providing an individual loading/shimmer element.
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
  final Duration snapTimerDuration;
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
    this.snapTimerDuration = const Duration(milliseconds: 150),
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

        if (state is ISLInitialState<T> ||
            (isLoading && loadingDir == LoadingDirection.initial)) {
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

              final startEndPadding = max(
                0.0,
                (mainAxis / 2) - ((mainDim + itemSpacing) / 2),
              );

              return _buildShimmerList(
                context,
                initialItemsCountForShimmer,
                mainDim,
                crossAxis,
                startEndPadding,
              );
            },
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
              snapTimerDuration: snapTimerDuration,
              enableKeyboardNavigation: enableKeyboardNavigation,
              lockScroll: isLoading && items.isNotEmpty,
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
                child: Container(
                  width: scrollDirection == Axis.horizontal
                      ? edgeDecorationSize
                      : null,
                  height: scrollDirection == Axis.vertical
                      ? edgeDecorationSize
                      : null,
                  alignment: Alignment.center,
                  child:
                      loadingIndicatorBuilder?.call(context) ??
                      const CircularProgressIndicator.adaptive(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerList(
    BuildContext context,
    int count,
    double mainDim,
    double crossDim,
    double startEndPadding,
  ) {
    final width = scrollDirection == Axis.horizontal ? mainDim : crossDim;
    final height = scrollDirection == Axis.vertical ? mainDim : crossDim;

    final list = ListView.separated(
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      padding: listPadding.add(
        scrollDirection == Axis.horizontal
            ? EdgeInsets.symmetric(horizontal: startEndPadding)
            : EdgeInsets.symmetric(vertical: startEndPadding),
      ),
      itemCount: count,
      separatorBuilder: (_, _) => SizedBox(
        width: scrollDirection == Axis.horizontal ? itemSpacing : 0,
        height: scrollDirection == Axis.vertical ? itemSpacing : 0,
      ),
      itemBuilder: (context, index) {
        if (loadingItemBuilder != null) {
          return loadingItemBuilder!(context, width, height);
        }
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );

    if (loadingItemBuilder != null) {
      return list;
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: list,
    );
  }
}
