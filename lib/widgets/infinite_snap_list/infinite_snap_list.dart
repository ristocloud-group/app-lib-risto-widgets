import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

/// Controller for programmatic selection, jump, and scroll control of InfiniteSnapList.
class InfiniteSnapListController<T> extends ChangeNotifier {
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

/// A highly customizable snap-scrolling list widget with infinite, bidirectional fetching.
class InfiniteSnapList<T> extends StatefulWidget {
  final InfiniteSnapListBloc<T> bloc;
  final InfiniteSnapListController<T>? controller;
  final Widget Function(BuildContext, T, int, bool) itemBuilder;
  final void Function(T item, int index)? onItemSelected;

  final Axis scrollDirection;
  final AlignmentGeometry itemAlignment;
  final EdgeInsetsGeometry listPadding;

  // --- Sizing ---
  /// If provided, dynamically calculates the item size along the main axis so exactly
  /// this many items are visible. Overrides itemWidth (for horizontal) or itemHeight (for vertical).
  /// Allows fractional amounts like 4.5 to "peek" the next item.
  final double? visibleItemCount;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;

  // --- Edge Decorations ---
  /// Optional decoration (like a gradient shadow) applied over the start edge of the list.
  final Decoration? startEdgeDecoration;

  /// Optional decoration (like a gradient shadow) applied over the end edge of the list.
  final Decoration? endEdgeDecoration;

  /// Width (or height for vertical) of the edge decorations.
  final double edgeDecorationSize;

  // --- Overlays & Loaders ---
  final Widget Function(BuildContext, double, double)?
  selectedItemOverlayBuilder;
  final Color? selectedOverlayColor;
  final BorderRadiusGeometry? selectedOverlayBorderRadius;

  final Widget Function(BuildContext, int)? loadingShimmerListBuilder;
  final Widget Function(BuildContext, int)? loadingShimmerItemBuilder;
  final int initialItemsCountForShimmer;
  final Widget Function(BuildContext)? loadingIndicatorBuilder;
  final Widget Function(BuildContext)? emptyListBuilder;
  final Widget Function(BuildContext, Exception)? errorBuilder;

  // --- Behaviors ---
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
    this.startEdgeDecoration,
    this.endEdgeDecoration,
    this.edgeDecorationSize = 40.0,
    this.selectedItemOverlayBuilder,
    this.selectedOverlayColor,
    this.selectedOverlayBorderRadius,
    this.loadingShimmerListBuilder,
    this.loadingShimmerItemBuilder,
    this.initialItemsCountForShimmer = 7,
    this.loadingIndicatorBuilder,
    this.emptyListBuilder,
    this.errorBuilder,
    this.semanticLabelBuilder,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.snapTimerDuration = const Duration(milliseconds: 200),
    this.enableKeyboardNavigation = true,
  });

  @override
  State<InfiniteSnapList<T>> createState() => _InfiniteSnapListState<T>();
}

class _InfiniteSnapListState<T> extends State<InfiniteSnapList<T>> {
  late ScrollController _controller;
  Timer? _snapTimer;
  bool _isInitializing = true;
  bool _isSnapping = false;
  int _lastSnappedIndex = -1;
  late StreamSubscription _blocSubscription;
  final FocusNode _focusNode = FocusNode();

  double _currentActualMainAxis = 0;
  double _currentStartEndPadding = 0;

  // Dynamic dimension getters
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
      getSelectedItem: _getSelectedItem,
      getSelectedIndex: _getSelectedIndex,
    );

    _blocSubscription = widget.bloc.stream.listen((state) {
      if (state is ISLoadedState<T>) {
        if (state.prependedItemCount > 0 && _controller.hasClients) {
          final compensation =
              state.prependedItemCount *
              _totalItemSlotMainAxis(_currentActualMainAxis);
          _controller.jumpTo(_controller.offset + compensation);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _controller.hasClients &&
              state.state.items.isNotEmpty &&
              state.state.selectedItem != null) {
            final idx = state.state.items.indexOf(state.state.selectedItem!);
            if (idx != -1) _snapTo(idx, animate: true, notifyCallback: false);
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _isInitializing = false);
      });
    });
  }

  @override
  void didUpdateWidget(covariant InfiniteSnapList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._attach(
        selectItem: _selectItem,
        jumpTo: _jumpTo,
        animateTo: _animateTo,
        getSelectedItem: _getSelectedItem,
        getSelectedIndex: _getSelectedIndex,
      );
    }
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _blocSubscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectItem(T item) {
    final idx = widget.bloc.state.state.items.indexOf(item);
    if (idx != -1) _snapTo(idx, animate: true);
  }

  void _jumpTo(int index) {
    if (!_controller.hasClients) return;
    final offset = _calculateTargetOffset(index);
    _controller.jumpTo(offset);
    widget.bloc.add(SelectItemEvent<T>(widget.bloc.state.state.items[index]));
  }

  void _animateTo(int index) {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      _calculateTargetOffset(index),
      duration: widget.snapAnimationDuration,
      curve: widget.snapAnimationCurve,
    );
    widget.bloc.add(SelectItemEvent<T>(widget.bloc.state.state.items[index]));
  }

  T? _getSelectedItem() => widget.bloc.state.state.selectedItem;

  int? _getSelectedIndex() =>
      widget.bloc.state.state.items.indexOf(_getSelectedItem() as T);

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

  void _onScroll() {
    if (_isInitializing ||
        _isSnapping ||
        _currentActualMainAxis == 0 ||
        !_controller.position.hasContentDimensions) {
      return;
    }
    final items = widget.bloc.state.state.items;
    if (items.isEmpty) return;

    final listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;

    final viewportCenterInScrollExtent =
        _controller.offset +
        (_currentActualMainAxis / 2) -
        listPaddingStart -
        _currentStartEndPadding;

    double minDist = double.infinity;
    int closestIdx = 0;
    for (int i = 0; i < items.length; i++) {
      final itemContentCenterInScrollExtent =
          (i * _totalItemSlotMainAxis(_currentActualMainAxis)) +
          (widget.itemSpacing / 2) +
          (_calculatedItemMainAxisDim(_currentActualMainAxis) / 2);
      final distance =
          (itemContentCenterInScrollExtent - viewportCenterInScrollExtent)
              .abs();
      if (distance < minDist) {
        minDist = distance;
        closestIdx = i;
      }
    }
    _snapTimer?.cancel();
    _snapTimer = Timer(widget.snapTimerDuration, () => _snapTo(closestIdx));
  }

  void _snapTo(int index, {bool animate = true, bool notifyCallback = true}) {
    final items = widget.bloc.state.state.items;
    if (index < 0 ||
        index >= items.length ||
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
      if (_lastSnappedIndex != index) {
        _lastSnappedIndex = index;
        widget.bloc.add(SelectItemEvent<T>(items[index]));
        if (notifyCallback) widget.onItemSelected?.call(items[index], index);
      }
    });
  }

  /// Default overlay builder used if [selectedItemOverlayBuilder] is null.
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
    return BlocBuilder<InfiniteSnapListBloc<T>, InfiniteSnapListState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = state.state.items;
        final selected = state.state.selectedItem;
        final selectedItemIndex = items.indexOf(selected);
        final isLoading = state is ISLLoadingState<T>;
        final loadingDir = state.state.loadingDirection;

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

              if (state is ISLInitialState<T> ||
                  (isLoading && loadingDir == LoadingDirection.initial)) {
                return _buildShimmerList(
                  context,
                  widget.initialItemsCountForShimmer,
                  itemMainAxisDim,
                  itemCrossAxisDim,
                );
              }
              if (state is ISLErrorState<T>) {
                return widget.errorBuilder?.call(context, state.error) ??
                    const SizedBox.shrink();
              }
              if (items.isEmpty) {
                return widget.emptyListBuilder?.call(context) ??
                    const SizedBox.shrink();
              }

              return Stack(
                children: [
                  // --- Overlay Layer ---
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

                  // --- Main List ---
                  ListView.builder(
                    controller: _controller,
                    scrollDirection: widget.scrollDirection,
                    physics: (_isSnapping || (isLoading && items.isNotEmpty))
                        ? const NeverScrollableScrollPhysics()
                        : widget.scrollPhysics,
                    padding: widget.listPadding.add(
                      widget.scrollDirection == Axis.horizontal
                          ? EdgeInsets.symmetric(
                              horizontal: _currentStartEndPadding,
                            )
                          : EdgeInsets.symmetric(
                              vertical: _currentStartEndPadding,
                            ),
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final isSelected = i == selectedItemIndex;
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
                          child: Semantics(
                            label: widget.semanticLabelBuilder?.call(items[i]),
                            selected: isSelected,
                            child: InkWell(
                              onTap: () {
                                if (!_isSnapping && !isLoading) _snapTo(i);
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: SizedBox(
                                width: widget.scrollDirection == Axis.horizontal
                                    ? itemMainAxisDim
                                    : itemCrossAxisDim,
                                height: widget.scrollDirection == Axis.vertical
                                    ? itemMainAxisDim
                                    : itemCrossAxisDim,
                                child: widget.itemBuilder(
                                  context,
                                  items[i],
                                  i,
                                  isSelected,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // --- Edge Fades (Shadows) ---
                  if (widget.startEdgeDecoration != null)
                    Positioned(
                      left: widget.scrollDirection == Axis.horizontal ? 0 : 0,
                      right: widget.scrollDirection == Axis.horizontal
                          ? null
                          : 0,
                      top: widget.scrollDirection == Axis.vertical ? 0 : 0,
                      bottom: widget.scrollDirection == Axis.vertical
                          ? null
                          : 0,
                      width: widget.scrollDirection == Axis.horizontal
                          ? widget.edgeDecorationSize
                          : null,
                      height: widget.scrollDirection == Axis.vertical
                          ? widget.edgeDecorationSize
                          : null,
                      child: IgnorePointer(
                        child: Container(
                          decoration: widget.startEdgeDecoration,
                        ),
                      ),
                    ),
                  if (widget.endEdgeDecoration != null)
                    Positioned(
                      left: widget.scrollDirection == Axis.horizontal
                          ? null
                          : 0,
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
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerList(
    BuildContext context,
    int count,
    double mainDim,
    double crossDim,
  ) {
    if (widget.loadingShimmerListBuilder != null) {
      return widget.loadingShimmerListBuilder!(context, count);
    }
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        scrollDirection: widget.scrollDirection,
        padding: widget.listPadding.add(
          widget.scrollDirection == Axis.horizontal
              ? EdgeInsets.symmetric(horizontal: _currentStartEndPadding)
              : EdgeInsets.symmetric(vertical: _currentStartEndPadding),
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => SizedBox(
          width: widget.scrollDirection == Axis.horizontal
              ? widget.itemSpacing
              : 0,
          height: widget.scrollDirection == Axis.vertical
              ? widget.itemSpacing
              : 0,
        ),
        itemBuilder: (context, index) {
          if (widget.loadingShimmerItemBuilder != null) {
            return widget.loadingShimmerItemBuilder!(context, index);
          }
          return Container(
            width: widget.scrollDirection == Axis.horizontal
                ? mainDim
                : crossDim,
            height: widget.scrollDirection == Axis.vertical
                ? mainDim
                : crossDim,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
      ),
    );
  }
}
