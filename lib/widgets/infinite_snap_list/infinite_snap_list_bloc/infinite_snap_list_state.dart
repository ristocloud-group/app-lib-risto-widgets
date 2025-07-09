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
class InitialState<T> extends InfiniteSnapListState<T> {
  const InitialState(super.s);
}

/// Stato di caricamento
class LoadingState<T> extends InfiniteSnapListState<T> {
  const LoadingState(super.s);
}

/// Stato con dati caricati (items aggiornati)
class LoadedState<T> extends InfiniteSnapListState<T> {
  // Aggiunto il campo prependedItemCount a LoadedState
  final int prependedItemCount;

  const LoadedState(super.s,
      {this.prependedItemCount = 0}); // Valore di default 0

  @override
  List<Object?> get props => [...super.props, prependedItemCount];
}

/// Stato di errore
class ErrorState<T> extends InfiniteSnapListState<T> {
  final Exception error;

  const ErrorState(super.s, {required this.error});

  @override
  List<Object?> get props => [...super.props, error];
}

/// Stato che indica che non ci sono più item da caricare
class NoMoreItemsState<T> extends InfiniteSnapListState<T> {
  const NoMoreItemsState(super.s);
}
