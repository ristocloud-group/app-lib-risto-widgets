import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'infinite_snap_list_event.dart';
part 'infinite_snap_list_state.dart';

/// BLoC che gestisce lo scrolling infinito bidirezionale con evento di selezione
/// sfruttando il comportamento snap per caricare nuovi item solo quando
/// si raggiunge la prima o l'ultima posizione, mantenendo traccia dell'item selezionato.
/// Richiede un `initValue` per pre-selezionare l’elemento di partenza (offset iniziale).
abstract class InfiniteListBloc<T>
    extends Bloc<InfiniteSnapListEvent, InfiniteSnapListState<T>> {
  /// Limite di fetch di default
  final int defaultLimit;

  /// Elemento iniziale da selezionare (offset di partenza), non null
  final T initValue;

  InfiniteListBloc({required this.initValue, this.defaultLimit = 10})
      : super(
          InitialState<T>(
            ISLState<T>(
              items: [],
              selectedItem: initValue,
              loadingDirection: null,
            ),
          ),
        ) {
    on<SelectItemEvent<T>>(_onSelectItem);
    // Lancia subito il caricamento iniziale con initValue
    add(SelectItemEvent<T>(initValue));
  }

  /// Selezione di un elemento: se è ai bordi, carica nella direzione appropriata;
  /// altrimenti aggiorna solo selectedItem.
  Future<void> _onSelectItem(
    SelectItemEvent<T> event,
    Emitter<InfiniteSnapListState<T>> emit,
  ) async {
    final current = state.state.items;
    final selected = event.selectedItem;

    // Se non siamo ai bordi, aggiorna solo selectedItem e resetta loadingDirection
    // e non emettere se l'elemento selezionato è già lo stesso
    if (current.isNotEmpty &&
        selected != current.first &&
        selected != current.last &&
        state.state.selectedItem != selected) {
      emit(LoadedState<T>(
        state.state.copyWith(selectedItem: selected, loadingDirection: null),
      ));
      return;
    }

    // Evita di caricare di nuovo se stiamo già caricando e l'elemento selezionato non è cambiato
    if (state is LoadingState && state.state.selectedItem == selected) {
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

    // Emettiamo LoadingState solo se c'è una direzione di caricamento
    if (directionToLoad != null) {
      emit(LoadingState<T>(state.state.copyWith(
        loadingDirection: directionToLoad,
        selectedItem: selected,
      )));
    }

    debugPrint("selected: $selected");

    try {
      List<T> updated = List<T>.from(current);
      int prependedCount = 0; // Inizializza per questo caso
      if (directionToLoad == LoadingDirection.initial) {
        // Caricamento iniziale
        final (left, right) = await fetchItems(
          leftLimit: defaultLimit,
          rightLimit: defaultLimit,
          offset: selected,
        );
        updated.addAll(right);
        updated.insertAll(0, left);
        prependedCount = left.length;
      } else if (directionToLoad == LoadingDirection.right) {
        // Carica elementi a destra
        final (_, right) = await fetchItems(
          leftLimit: 0,
          rightLimit: defaultLimit,
          offset: selected,
        );
        updated.addAll(right);
      } else if (directionToLoad == LoadingDirection.left) {
        // Carica elementi a sinistra
        final (left, _) = await fetchItems(
          leftLimit: defaultLimit,
          rightLimit: 0,
          offset: selected,
        );
        updated.insertAll(0, left);
        prependedCount = left.length; // Cattura il numero di elementi prepended
      }

      // Emette LoadedState solo se c'è stato un caricamento o se l'elemento selezionato è cambiato
      // Questo previene emissioni ridondanti quando non c'è caricamento effettivo
      if (directionToLoad != null || state.state.selectedItem != selected) {
        emit(LoadedState<T>(
          state.state.copyWith(
            items: updated,
            selectedItem: selected,
            loadingDirection: null, // Reset direzione dopo il carico completato
          ),
          prependedItemCount: prependedCount, // Passa il contatore
        ));
      }
    } catch (e) {
      emit(ErrorState<T>(state.state.copyWith(loadingDirection: null),
          error: Exception(e.toString())));
    }
  }

  /// Deve essere implementato per recuperare liste (left, right)
  Future<(List<T>, List<T>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required T offset,
  });
}
