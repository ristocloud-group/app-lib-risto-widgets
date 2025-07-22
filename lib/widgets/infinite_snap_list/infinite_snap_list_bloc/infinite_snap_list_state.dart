part of 'infinite_snap_list_bloc.dart';

enum LoadingDirection { left, right, initial }

/// Stato interno della lista (items + selectedItem)
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

/// Base dello stato emesso dal BLoC
abstract class InfiniteSnapListState<T> extends Equatable {
  final ISLState<T> state;

  const InfiniteSnapListState(this.state);

  @override
  List<Object?> get props =>
      [state.items, state.selectedItem, state.loadingDirection];
}

/// Stato iniziale prima di caricare i dati
class ISLInitialState<T> extends InfiniteSnapListState<T> {
  const ISLInitialState(super.s);
}

/// Stato di caricamento
class ISLLoadingState<T> extends InfiniteSnapListState<T> {
  const ISLLoadingState(super.s);
}

/// Stato con dati caricati (items aggiornati)
class ISLoadedState<T> extends InfiniteSnapListState<T> {
  // Aggiunto il campo prependedItemCount a LoadedState
  final int prependedItemCount;

  const ISLoadedState(super.s,
      {this.prependedItemCount = 0}); // Valore di default 0

  @override
  List<Object?> get props => [...super.props, prependedItemCount];
}

/// Stato di errore
class ISLErrorState<T> extends InfiniteSnapListState<T> {
  final Exception error;

  const ISLErrorState(super.s, {required this.error});

  @override
  List<Object?> get props => [...super.props, error];
}

/// Stato che indica che non ci sono più item da caricare
class ISLNoMoreItemsState<T> extends InfiniteSnapListState<T> {
  const ISLNoMoreItemsState(super.s);
}
