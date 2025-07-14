import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

/// Controller for programmatic selection, jump, and scroll control of InfiniteSnapList.
/// Attach this to the widget to interact from the outside (select, jump, animate).
class InfiniteSnapListController<T> extends ChangeNotifier {
  void Function(T item)? _selectItem;
  void Function(int index)? _jumpTo;
  void Function(int index)? _animateTo;

  T? Function()? _getSelectedItem;
  int? Function()? _getSelectedIndex;

  /// Internal: Attach methods from the InfiniteSnapList widget.
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

  /// Programmatically select an item by value (will snap and scroll to it).
  void selectItem(T item) => _selectItem?.call(item);

  /// Jump directly to an index (no animation).
  void jumpTo(int index) => _jumpTo?.call(index);

  /// Animate scrolling to a specific index.
  void animateTo(int index) => _animateTo?.call(index);

  /// Get the currently selected item (if available).
  T? get selectedItem => _getSelectedItem?.call();

  /// Get the currently selected index (if available).
  int? get selectedIndex => _getSelectedIndex?.call();
}

/// A snap-scrolling list widget with infinite, bidirectional fetch, external control, and accessibility.
/// Highly customizable for item rendering, overlays, loading, empty/error state, and more.
class InfiniteSnapList<T> extends StatefulWidget {
  /// The BLoC instance that manages state and data loading.
  final InfiniteSnapListBloc<T> bloc;

  /// Optional controller for programmatic interaction.
  final InfiniteSnapListController<T>? controller;

  /// Builder for each item; provides context, item value, index, and isSelected.
  final Widget Function(BuildContext, T, int, bool) itemBuilder;

  // --- Callbacks ---
  /// Called when a new item is selected (via tap, swipe, or controller).
  final void Function(T item, int index)? onItemSelected;

  /// Optional: called when scroll starts.
  final VoidCallback? onScrollStart;

  /// Optional: called when scroll ends.
  final VoidCallback? onScrollEnd;

  // --- Layout ---
  /// Scroll direction (Axis.horizontal or Axis.vertical). Default: horizontal.
  final Axis scrollDirection;

  /// How the selected item/overlay is aligned in the viewport.
  final AlignmentGeometry itemAlignment;

  /// Padding for the list as a whole.
  final EdgeInsetsGeometry listPadding;

  // --- Loading/Empty/Error/Loader ---
  /// Optional: custom builder for shimmer (loading placeholder) items.
  final Widget Function(BuildContext, int)? loadingShimmerItemBuilder;

  /// How many shimmer items to display during initial loading.
  final int initialItemsCountForShimmer;

  /// Optional: custom builder for the loader indicator when fetching more items.
  final Widget Function(BuildContext)? loadingIndicatorBuilder;

  /// Optional: custom builder for the empty state.
  final Widget Function(BuildContext)? emptyListBuilder;

  /// Optional: custom builder for the error state.
  final Widget Function(BuildContext, Exception)? errorBuilder;

  /// Default/fallback message for empty list state.
  final String emptyListMessage;

  /// Optional: text style for the empty message.
  final TextStyle? emptyListTextStyle;

  /// Optional: padding for the empty message.
  final EdgeInsetsGeometry? emptyListPadding;

  /// Optional: text style for error messages.
  final TextStyle? errorTextStyle;

  /// Optional: padding for error messages.
  final EdgeInsetsGeometry? errorPadding;

  // --- Overlay ---
  /// Optional: custom overlay builder for selected item highlight.
  final Widget Function(BuildContext, double, double)?
      selectedItemOverlayBuilder;

  /// Default color for the selected item overlay.
  final Color? selectedOverlayColor;

  /// Default border radius for the selected item overlay.
  final BorderRadius? selectedOverlayBorderRadius;

  // --- Item Size & Style ---
  /// Width of each item.
  final double itemWidth;

  /// Height of each item.
  final double itemHeight;

  /// Spacing between items.
  final double itemSpacing;

  /// Border radius for InkWell effects on items.
  final BorderRadius? itemInkWellBorderRadius;

  /// Duration for fade-in/out when selection changes.
  final Duration itemFadeAnimationDuration;

  // --- Scroll/Snap ---
  /// Scroll physics for the list (e.g. BouncingScrollPhysics).
  final ScrollPhysics scrollPhysics;

  /// Duration of the snap animation.
  final Duration snapAnimationDuration;

  /// Curve of the snap animation.
  final Curve snapAnimationCurve;

  /// Timer duration before snapping after scroll.
  final Duration snapTimerDuration;

  // --- Shimmer Colors ---
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final BorderRadius? shimmerBorderRadius;

  // --- Loader Colors ---
  final double? loadingIndicatorStrokeWidth;
  final Color? loadingIndicatorColor;

  // --- InkWell Colors ---
  final Color? inkWellSplashColor;
  final Color? inkWellHighlightColor;

  // --- Accessibility ---
  /// Builder for semantic labels for each item, for screen readers.
  final String Function(T item)? semanticLabelBuilder;

  // --- Focus/Keyboard Navigation ---
  /// If true, enables keyboard navigation (arrow keys to change selection).
  final bool enableKeyboardNavigation;

  /// Constructor for InfiniteSnapList. All parameters are optional except bloc and itemBuilder.
  const InfiniteSnapList({
    super.key,
    required this.bloc,
    required this.itemBuilder,
    this.controller,
    this.onItemSelected,
    this.onScrollStart,
    this.onScrollEnd,
    this.scrollDirection = Axis.horizontal,
    this.itemAlignment = Alignment.center,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.loadingShimmerItemBuilder,
    this.initialItemsCountForShimmer = 7,
    this.loadingIndicatorBuilder,
    this.emptyListBuilder,
    this.errorBuilder,
    this.emptyListMessage = 'No items available.',
    this.emptyListTextStyle,
    this.emptyListPadding,
    this.errorTextStyle,
    this.errorPadding,
    this.selectedItemOverlayBuilder,
    this.selectedOverlayColor,
    this.selectedOverlayBorderRadius,
    this.itemWidth = 60,
    this.itemHeight = 80,
    this.itemSpacing = 12,
    this.itemInkWellBorderRadius,
    this.itemFadeAnimationDuration = const Duration(milliseconds: 300),
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.snapTimerDuration = const Duration(milliseconds: 200),
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerBorderRadius,
    this.loadingIndicatorStrokeWidth,
    this.loadingIndicatorColor,
    this.inkWellSplashColor,
    this.inkWellHighlightColor,
    this.semanticLabelBuilder,
    this.enableKeyboardNavigation = true,
  });

  @override
  State<InfiniteSnapList<T>> createState() => _InfiniteSnapListState<T>();
}

class _InfiniteSnapListState<T> extends State<InfiniteSnapList<T>> {
  late ScrollController _controller; // No longer 'final' as it's re-initialized
  Timer? _snapTimer;
  bool _isInitializing = true;
  bool _isSnapping = false;
  int _lastSnappedIndex = -1;
  late StreamSubscription _blocSubscription;
  final FocusNode _focusNode = FocusNode();

  double _currentActualMainAxis = 0; // Current viewport width or height
  double _currentStartEndPadding = 0;

  /// Calculates the total size (main axis) for each item including spacing.
  double get _totalItemSlotMainAxis =>
      (widget.scrollDirection == Axis.horizontal
          ? widget.itemWidth
          : widget.itemHeight) +
      widget.itemSpacing;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);

    // Attach methods to the controller for programmatic access.
    widget.controller?._attach(
      selectItem: _selectItem,
      jumpTo: _jumpTo,
      animateTo: _animateTo,
      getSelectedItem: _getSelectedItem,
      getSelectedIndex: _getSelectedIndex,
    );

    // Listen to BLoC stream to handle fetch and item selection.
    _blocSubscription = widget.bloc.stream.listen((state) {
      if (state is LoadedState<T>) {
        // Compensate for newly prepended items so scroll position is visually consistent.
        if (state.prependedItemCount > 0 && _controller.hasClients) {
          final compensation =
              state.prependedItemCount * _totalItemSlotMainAxis;
          _controller.jumpTo(_controller.offset + compensation);
        }
        // Snap to the currently selected item after any new fetch.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _controller.hasClients &&
              _controller.position.hasContentDimensions &&
              state.state.items.isNotEmpty &&
              state.state.selectedItem != null) {
            final idx = state.state.items.indexOf(state.state.selectedItem!);
            if (idx != -1) {
              _snapTo(idx, animate: true, notifyCallback: false);
            }
          }
        });
      }
    });

    // Delay initialization for correct layout measurement.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _isInitializing = false);
      });
    });
  }

  @override
  void didUpdateWidget(covariant InfiniteSnapList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If scroll direction or item dimensions change, re-initialize the controller
    // to ensure layout metrics are recalculated.
    final bool layoutConfigChanged =
        oldWidget.scrollDirection != widget.scrollDirection ||
            oldWidget.itemWidth != widget.itemWidth ||
            oldWidget.itemHeight != widget.itemHeight ||
            oldWidget.itemSpacing != widget.itemSpacing;

    if (layoutConfigChanged) {
      // Dispose the old controller
      _controller.removeListener(_onScroll);
      _controller.dispose();

      // Create a new controller
      _controller = ScrollController();
      _controller.addListener(_onScroll);

      // Re-attach the external controller to ensure it points to the new internal controller
      widget.controller?._attach(
        selectItem: _selectItem,
        jumpTo: _jumpTo,
        animateTo: _animateTo,
        getSelectedItem: _getSelectedItem,
        getSelectedIndex: _getSelectedIndex,
      );

      // Schedule the snap to the selected item in the next frame
      // AFTER the layout has had a chance to rebuild with new dimensions.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure widget is still mounted and controller is ready
        if (mounted &&
            _controller.hasClients &&
            _controller.position.hasContentDimensions &&
            widget.bloc.state.state.items.isNotEmpty &&
            widget.bloc.state.state.selectedItem != null) {
          final idx = widget.bloc.state.state.items
              .indexOf(widget.bloc.state.state.selectedItem!);
          if (idx != -1) {
            _snapTo(idx,
                animate: false,
                notifyCallback:
                    false); // Use jumpTo (animate: false) for immediate repositioning
          }
        }
      });
    } else if (oldWidget.controller != widget.controller) {
      // Only re-attach if the controller instance itself changes
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

  // ===== CONTROLLER API (internal methods exposed to controller) =====

  /// Selects an item by value, animating to it if present.
  void _selectItem(T item) {
    final idx = widget.bloc.state.state.items.indexOf(item);
    if (idx != -1) _snapTo(idx, animate: true);
  }

  /// Jumps instantly to an index in the list.
  void _jumpTo(int index) {
    if (!_controller.hasClients || !_controller.position.hasContentDimensions) {
      return;
    }
    final double itemContentMainAxisDim =
        widget.scrollDirection == Axis.horizontal
            ? widget.itemWidth
            : widget.itemHeight;
    final double listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;
    final double offset = listPaddingStart +
        _currentStartEndPadding +
        (index * _totalItemSlotMainAxis) +
        (widget.itemSpacing / 2) +
        (itemContentMainAxisDim / 2) -
        (_currentActualMainAxis / 2);

    _controller.jumpTo(offset);
    widget.bloc.add(SelectItemEvent<T>(widget.bloc.state.state.items[index]));
  }

  /// Animates scroll to a specific index.
  void _animateTo(int index) {
    if (!_controller.hasClients || !_controller.position.hasContentDimensions) {
      return;
    }
    final double itemContentMainAxisDim =
        widget.scrollDirection == Axis.horizontal
            ? widget.itemWidth
            : widget.itemHeight;
    final double listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;
    final double offset = listPaddingStart +
        _currentStartEndPadding +
        (index * _totalItemSlotMainAxis) +
        (widget.itemSpacing / 2) +
        (itemContentMainAxisDim / 2) -
        (_currentActualMainAxis / 2);

    _controller.animateTo(
      offset,
      duration: widget.snapAnimationDuration,
      curve: widget.snapAnimationCurve,
    );
    widget.bloc.add(SelectItemEvent<T>(widget.bloc.state.state.items[index]));
  }

  /// Returns the currently selected item, if available.
  T? _getSelectedItem() => widget.bloc.state.state.selectedItem;

  /// Returns the index of the currently selected item.
  int? _getSelectedIndex() =>
      widget.bloc.state.state.items.indexOf(_getSelectedItem() as T);

  // ===== SNAP/SCROLL LOGIC =====

  /// Called on scroll updates; schedules snapping to the nearest item after a delay.
  void _onScroll() {
    if (_isInitializing ||
        _isSnapping ||
        _currentActualMainAxis == 0 ||
        !_controller.position.hasContentDimensions) {
      return;
    }
    final items = widget.bloc.state.state.items;
    if (items.isEmpty) {
      return;
    }

    final double itemContentMainAxisDim =
        widget.scrollDirection == Axis.horizontal
            ? widget.itemWidth
            : widget.itemHeight;
    final double listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;

    final double viewportCenterInScrollExtent = _controller.offset +
        (_currentActualMainAxis / 2) -
        listPaddingStart -
        _currentStartEndPadding;

    double minDist = double.infinity;
    int closestIdx = 0;
    for (int i = 0; i < items.length; i++) {
      // Calcola il centro del CONTENUTO dell'elemento rispetto all'inizio del Content Size Box della ListView.
      final double itemContentCenterInScrollExtent =
          (i * _totalItemSlotMainAxis) +
              (widget.itemSpacing / 2) +
              (itemContentMainAxisDim / 2);

      final double distance =
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

  /// Animates or jumps to the given item index. Calls onItemSelected if appropriate.
  void _snapTo(int index, {bool animate = true, bool notifyCallback = true}) {
    final items = widget.bloc.state.state.items;
    if (index < 0 ||
        index >= items.length ||
        !_controller.hasClients ||
        !_controller.position.hasContentDimensions ||
        _currentActualMainAxis == 0) {
      return;
    }

    final double itemContentMainAxisDim =
        widget.scrollDirection == Axis.horizontal
            ? widget.itemWidth
            : widget.itemHeight;
    final double listPaddingStart = widget.scrollDirection == Axis.horizontal
        ? widget.listPadding.horizontal / 2
        : widget.listPadding.vertical / 2;

    final double targetOffset = listPaddingStart +
        _currentStartEndPadding +
        (index * _totalItemSlotMainAxis) +
        (widget.itemSpacing / 2) +
        (itemContentMainAxisDim / 2) -
        (_currentActualMainAxis / 2);

    final maxExtent = _controller.position.maxScrollExtent;
    final clampedTarget = targetOffset.clamp(0.0, maxExtent);

    _isSnapping = true;
    Future snapFuture;
    if (animate) {
      snapFuture = _controller.animateTo(
        clampedTarget,
        duration: widget.snapAnimationDuration,
        curve: widget.snapAnimationCurve,
      );
    } else {
      snapFuture = Future(() => _controller.jumpTo(clampedTarget));
    }
    snapFuture.whenComplete(() {
      _isSnapping = false;
      if (_lastSnappedIndex != index) {
        _lastSnappedIndex = index;
        widget.bloc.add(SelectItemEvent<T>(items[index]));
        if (notifyCallback && widget.onItemSelected != null) {
          widget.onItemSelected!(items[index], index);
        }
      }
    });
  }

  // ========== MAIN WIDGET BUILD ==========

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfiniteSnapListBloc<T>, InfiniteSnapListState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = state.state.items;
        final selected = state.state.selectedItem;
        final selectedItemIndex = items.indexOf(selected);

        // --- Initial state or shimmer loading ---
        if (state is InitialState<T> ||
            (state is LoadingState<T> &&
                state.state.loadingDirection == LoadingDirection.initial)) {
          return LayoutBuilder(
            builder: (context, constraints) {
              _currentActualMainAxis = widget.scrollDirection == Axis.horizontal
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              _currentStartEndPadding = max(0.0,
                  (_currentActualMainAxis / 2) - (_totalItemSlotMainAxis / 2));
              return _buildShimmerList(
                  context, widget.initialItemsCountForShimmer);
            },
          );
        }

        // --- Error state ---
        if (state is ErrorState<T>) {
          return widget.errorBuilder?.call(context, state.error) ??
              _defaultErrorBuilder(context, state.error);
        }

        // --- Empty state ---
        if (items.isEmpty) {
          return widget.emptyListBuilder?.call(context) ??
              _defaultEmptyListBuilder(context);
        }

        final isLoading = state is LoadingState<T>;
        final loadingDir = state.state.loadingDirection;
        final showLoader = isLoading && loadingDir != null && items.isNotEmpty;

        return Focus(
          focusNode: widget.enableKeyboardNavigation ? _focusNode : null,
          autofocus: widget.enableKeyboardNavigation,
          onKeyEvent: widget.enableKeyboardNavigation ? _onKey : null,
          child: SizedBox(
            width: widget.scrollDirection == Axis.horizontal
                ? double.infinity
                : widget.itemWidth,
            height: widget.scrollDirection == Axis.horizontal
                ? widget.itemHeight
                : double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _currentActualMainAxis =
                    widget.scrollDirection == Axis.horizontal
                        ? constraints.maxWidth
                        : constraints.maxHeight;
                _currentStartEndPadding = max(
                    0.0,
                    (_currentActualMainAxis / 2) -
                        (_totalItemSlotMainAxis / 2));

                return Stack(
                  children: [
                    // --- Selected item overlay ---
                    Align(
                      alignment: widget.itemAlignment,
                      child: widget.selectedItemOverlayBuilder?.call(
                              context, widget.itemWidth, widget.itemHeight) ??
                          _defaultSelectedItemOverlayBuilder(
                              context, widget.itemWidth, widget.itemHeight),
                    ),
                    // --- Main item list ---
                    ListView.builder(
                      controller: _controller,
                      scrollDirection: widget.scrollDirection,
                      physics: (_isSnapping || showLoader)
                          ? const NeverScrollableScrollPhysics()
                          : widget.scrollPhysics,
                      padding: widget.listPadding.add(
                        widget.scrollDirection == Axis.horizontal
                            ? EdgeInsets.symmetric(
                                horizontal: _currentStartEndPadding)
                            : EdgeInsets.symmetric(
                                vertical: _currentStartEndPadding),
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final isSelected = i == selectedItemIndex;

                        return SizedBox(
                          width: widget.scrollDirection == Axis.horizontal
                              ? _totalItemSlotMainAxis
                              : widget.itemWidth,
                          height: widget.scrollDirection == Axis.vertical
                              ? _totalItemSlotMainAxis
                              : widget.itemHeight,
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
                              label: widget.semanticLabelBuilder?.call(item),
                              selected: isSelected,
                              child: InkWell(
                                onTap: () {
                                  if (!_isSnapping && !isLoading) _snapTo(i);
                                },
                                borderRadius: widget.itemInkWellBorderRadius ??
                                    BorderRadius.circular(8),
                                splashColor: widget.inkWellSplashColor,
                                highlightColor: widget.inkWellHighlightColor,
                                child: SizedBox(
                                  width: widget.itemWidth,
                                  height: widget.itemHeight,
                                  child: AnimatedSwitcher(
                                    duration: widget.itemFadeAnimationDuration,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                            opacity: animation, child: child),
                                    child: FittedBox(
                                      key: ValueKey(item),
                                      fit: BoxFit.contain,
                                      child: widget.itemBuilder(
                                          context, item, i, isSelected),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // --- Loader for fetching more items ---
                    if (showLoader)
                      Positioned(
                        right: widget.scrollDirection == Axis.horizontal &&
                                loadingDir == LoadingDirection.right
                            ? 0
                            : null,
                        left: widget.scrollDirection == Axis.horizontal &&
                                loadingDir == LoadingDirection.left
                            ? 0
                            : null,
                        top: widget.scrollDirection == Axis.vertical &&
                                loadingDir == LoadingDirection.left
                            ? 0
                            : null,
                        bottom: widget.scrollDirection == Axis.vertical &&
                                loadingDir == LoadingDirection.right
                            ? 0
                            : null,
                        child: SizedBox(
                          width: widget.scrollDirection == Axis.horizontal
                              ? widget.itemWidth
                              : null,
                          height: widget.scrollDirection == Axis.vertical
                              ? widget.itemHeight
                              : null,
                          child: Center(
                            child:
                                widget.loadingIndicatorBuilder?.call(context) ??
                                    _defaultLoadingIndicatorBuilder(context),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Handles keyboard arrow navigation for selection.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final items = widget.bloc.state.state.items;
    final selected = widget.bloc.state.state.selectedItem;
    final idx = items.indexOf(selected);

    if (widget.scrollDirection == Axis.horizontal) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          idx < items.length - 1) {
        _snapTo(idx + 1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft && idx > 0) {
        _snapTo(idx - 1);
        return KeyEventResult.handled;
      }
    } else {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
          idx < items.length - 1) {
        _snapTo(idx + 1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp && idx > 0) {
        _snapTo(idx - 1);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// Builds a shimmer loading placeholder list.
  Widget _buildShimmerList(BuildContext context, int count) {
    return SizedBox(
      width: widget.scrollDirection == Axis.horizontal
          ? double.infinity
          : widget.itemWidth,
      height: widget.scrollDirection == Axis.horizontal
          ? widget.itemHeight
          : double.infinity,
      child: ListView.separated(
        scrollDirection: widget.scrollDirection,
        padding: widget.listPadding.add(
          widget.scrollDirection == Axis.horizontal
              ? EdgeInsets.symmetric(horizontal: _currentStartEndPadding)
              : EdgeInsets.symmetric(vertical: _currentStartEndPadding),
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) => SizedBox(
          width: widget.scrollDirection == Axis.horizontal
              ? widget.itemSpacing
              : 0,
          height:
              widget.scrollDirection == Axis.vertical ? widget.itemSpacing : 0,
        ),
        itemBuilder: (context, index) {
          return widget.loadingShimmerItemBuilder?.call(context, index) ??
              _defaultShimmerItemBuilder(context, index);
        },
      ),
    );
  }

  /// Default shimmer item for loading state.
  Widget _defaultShimmerItemBuilder(BuildContext context, int index) {
    final baseColor = widget.shimmerBaseColor ?? Colors.grey.shade300;
    final highlightColor = widget.shimmerHighlightColor ?? Colors.grey.shade100;
    final borderRadius =
        widget.shimmerBorderRadius ?? BorderRadius.circular(8.0);
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: widget.itemWidth,
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  /// Default overlay for the selected item.
  Widget _defaultSelectedItemOverlayBuilder(
      BuildContext context, double w, double h) {
    final overlayColor = widget.selectedOverlayColor ??
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

  /// Default loading indicator widget.
  Widget _defaultLoadingIndicatorBuilder(BuildContext context) {
    final indicatorColor = widget.loadingIndicatorColor;
    final strokeWidth = widget.loadingIndicatorStrokeWidth ?? 2;
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: indicatorColor != null
            ? AlwaysStoppedAnimation<Color>(indicatorColor)
            : null,
      ),
    );
  }

  /// Default empty state widget.
  Widget _defaultEmptyListBuilder(BuildContext context) {
    final textStyle =
        widget.emptyListTextStyle ?? Theme.of(context).textTheme.bodyLarge;
    final padding = widget.emptyListPadding ?? const EdgeInsets.all(16.0);
    return Center(
      child: Padding(
        padding: padding,
        child: Text(widget.emptyListMessage,
            textAlign: TextAlign.center, style: textStyle),
      ),
    );
  }

  /// Default error state widget.
  Widget _defaultErrorBuilder(BuildContext context, Exception error) {
    final textStyle =
        widget.errorTextStyle ?? const TextStyle(color: Colors.red);
    final padding = widget.errorPadding ?? const EdgeInsets.all(16.0);
    return Center(
      child: Padding(
        padding: padding,
        child: Text('Error: ${error.toString()}',
            textAlign: TextAlign.center, style: textStyle),
      ),
    );
  }
}
