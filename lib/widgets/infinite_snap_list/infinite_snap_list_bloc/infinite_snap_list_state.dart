part of 'infinite_snap_list_bloc.dart';

enum LoadingDirection { left, right, initial }

/// Internal state of the list (items + selectedItem)
class ISLState<T> {
  final List<T> items;
  final T selectedItem;
  final LoadingDirection? loadingDirection;

  ISLState({
    required this.items,
    required this.selectedItem,
    this.loadingDirection,
  });

  ISLState<T> copyWith({
    List<T>? items,
    T? selectedItem,
    LoadingDirection? loadingDirection,
  }) {
    return ISLState<T>(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      loadingDirection: loadingDirection,
    );
  }
}

/// Base class for the state emitted by the BLoC
abstract class InfiniteSnapListState<T> extends Equatable {
  final ISLState<T> state;

  const InfiniteSnapListState(this.state);

  @override
  List<Object?> get props => [
    state.items,
    state.selectedItem,
    state.loadingDirection,
  ];
}

/// Initial state before loading data
class ISLInitialState<T> extends InfiniteSnapListState<T> {
  const ISLInitialState(super.s);
}

/// Loading state
class ISLLoadingState<T> extends InfiniteSnapListState<T> {
  const ISLLoadingState(super.s);
}

/// State with loaded data (items updated)
class ISLoadedState<T> extends InfiniteSnapListState<T> {
  // Added the prependedItemCount field to LoadedState
  final int prependedItemCount;

  const ISLoadedState(
    super.s, {
    this.prependedItemCount = 0,
  }); // Default value 0

  @override
  List<Object?> get props => [...super.props, prependedItemCount];
}

/// Error state
class ISLErrorState<T> extends InfiniteSnapListState<T> {
  final Exception error;

  const ISLErrorState(super.s, {required this.error});

  @override
  List<Object?> get props => [...super.props, error];
}

/// State indicating there are no more items to load
class ISLNoMoreItemsState<T> extends InfiniteSnapListState<T> {
  const ISLNoMoreItemsState(super.s);
}
