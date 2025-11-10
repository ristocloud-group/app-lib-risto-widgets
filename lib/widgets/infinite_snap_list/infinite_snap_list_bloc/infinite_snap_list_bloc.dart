import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'infinite_snap_list_event.dart';
part 'infinite_snap_list_state.dart';

/// BLoC that manages bidirectional infinite scrolling with a selection event,
/// leveraging snap behavior to load new items only when
/// the first or last position is reached, keeping track of the selected item.
/// Requires an `initValue` to pre-select the starting element (initial offset).
abstract class InfiniteSnapListBloc<T>
    extends Bloc<InfiniteSnapListEvent, InfiniteSnapListState<T>> {
  /// Default fetch limit
  final int defaultLimit;

  /// Initial element to select (starting offset), non-null
  final T initValue;

  InfiniteSnapListBloc({required this.initValue, this.defaultLimit = 10})
    : super(
        ISLInitialState<T>(
          ISLState<T>(
            items: [],
            selectedItem: initValue,
            loadingDirection: null,
          ),
        ),
      ) {
    on<SelectItemEvent<T>>(_onSelectItem);
    // Immediately triggers the initial load with initValue
    add(SelectItemEvent<T>(initValue));
  }

  /// Selecting an item: if it's at the edges, load in the appropriate direction;
  /// otherwise, just update selectedItem.
  Future<void> _onSelectItem(
    SelectItemEvent<T> event,
    Emitter<InfiniteSnapListState<T>> emit,
  ) async {
    final current = state.state.items;
    final selected = event.selectedItem;

    // If we are not at the edges, just update selectedItem and reset loadingDirection
    // and don't emit if the selected item is already the same
    if (current.isNotEmpty &&
        selected != current.first &&
        selected != current.last &&
        state.state.selectedItem != selected) {
      emit(
        ISLoadedState<T>(
          state.state.copyWith(selectedItem: selected, loadingDirection: null),
        ),
      );
      return;
    }

    // Avoid loading again if we are already loading and the selected item hasn't changed
    if (state is ISLLoadingState && state.state.selectedItem == selected) {
      return;
    }

    LoadingDirection? directionToLoad;
    if (current.isEmpty) {
      directionToLoad = LoadingDirection.initial;
      current.add(selected);
    } else if (selected == current.last) {
      directionToLoad = LoadingDirection.right;
    } else if (selected == current.first) {
      directionToLoad = LoadingDirection.left;
    }

    // We only emit LoadingState if there is a loading direction
    if (directionToLoad != null) {
      emit(
        ISLLoadingState<T>(
          state.state.copyWith(
            loadingDirection: directionToLoad,
            selectedItem: selected,
          ),
        ),
      );
    }

    debugPrint("selected: $selected");

    try {
      List<T> updated = List<T>.from(current);
      int prependedCount = 0; // Initialize for this case
      if (directionToLoad == LoadingDirection.initial) {
        // Initial loading
        final (left, right) = await fetchItems(
          leftLimit: defaultLimit,
          rightLimit: defaultLimit,
          offset: selected,
        );
        updated.addAll(right);
        updated.insertAll(0, left);
        prependedCount = left.length;
      } else if (directionToLoad == LoadingDirection.right) {
        // Load items to the right
        final (_, right) = await fetchItems(
          leftLimit: 0,
          rightLimit: defaultLimit,
          offset: selected,
        );
        updated.addAll(right);
      } else if (directionToLoad == LoadingDirection.left) {
        // Load items to the left
        final (left, _) = await fetchItems(
          leftLimit: defaultLimit,
          rightLimit: 0,
          offset: selected,
        );
        updated.insertAll(0, left);
        prependedCount = left.length; // Capture the number of prepended items
      }

      // Emits LoadedState only if there was a load or if the selected item changed
      // This prevents redundant emissions when there's no actual loading
      if (directionToLoad != null || state.state.selectedItem != selected) {
        emit(
          ISLoadedState<T>(
            state.state.copyWith(
              items: updated,
              selectedItem: selected,
              loadingDirection:
                  null, // Reset direction after loading is complete
            ),
            prependedItemCount: prependedCount, // Pass the counter
          ),
        );
      }
    } catch (e) {
      emit(
        ISLErrorState<T>(
          state.state.copyWith(loadingDirection: null),
          error: Exception(e.toString()),
        ),
      );
    }
  }

  /// Must be implemented to fetch lists (left, right)
  Future<(List<T>, List<T>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required T offset,
  });
}
