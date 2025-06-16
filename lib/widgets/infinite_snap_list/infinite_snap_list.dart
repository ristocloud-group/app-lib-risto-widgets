import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

// Assicurati che questo import punti al percorso corretto del tuo BLoC e file di stato/eventi.
import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

/// Widget per una lista orizzontale con snap e fetch infinito bidirezionale.
class InfiniteSnapList<T> extends StatefulWidget {
  final InfiniteListBloc<T> bloc;
  final Widget Function(
      BuildContext context, T item, int index, bool isSelected) itemBuilder;

  /// Builder per un singolo elemento shimmer durante il caricamento iniziale.
  /// Riceve il [BuildContext] e l'indice dell'elemento.
  final Widget Function(BuildContext context, int index)?
      loadingShimmerItemBuilder;
  final double itemWidth;
  final double itemHeight;
  final double itemSpacing;
  final ScrollPhysics scrollPhysics;
  final String emptyListMessage;

  /// Builder per visualizzare un errore.
  /// Riceve il [BuildContext] e l'?[Exception].
  final Widget Function(BuildContext context, Exception)? errorBuilder;
  final int initialItemsCountForShimmer;

  /// Builder per l'overlay dell'elemento selezionato.
  /// Riceve il [BuildContext], la larghezza totale dello slot dell'elemento
  /// (itemWidth + itemSpacing) e l'altezza dell'elemento.
  final Widget Function(
          BuildContext context, double totalItemSlotWidth, double itemHeight)?
      selectedItemOverlayBuilder;

  /// Builder per l'indicatore di caricamento.
  /// Riceve il [BuildContext].
  final Widget Function(BuildContext context)? loadingIndicatorBuilder;

  /// Builder per la lista vuota.
  /// Riceve il [BuildContext].
  final Widget Function(BuildContext context)? emptyListBuilder;

  /// Se true, disegna dei punti di debug per il centraggio degli elementi.
  final bool
      debugMode; // Mantenuto per compatibilità, anche se i punti sono rimossi

  const InfiniteSnapList({
    super.key,
    required this.bloc,
    required this.itemBuilder,
    this.loadingShimmerItemBuilder,
    this.itemWidth = 60,
    this.itemHeight = 80,
    this.itemSpacing = 12,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.emptyListMessage = 'Nessun elemento disponibile.',
    this.errorBuilder,
    this.initialItemsCountForShimmer = 7,
    this.selectedItemOverlayBuilder,
    this.loadingIndicatorBuilder,
    this.emptyListBuilder,
    this.debugMode = false, // Mantenuto il parametro
  });

  @override
  State<InfiniteSnapList<T>> createState() => _InfiniteSnapListState<T>();
}

class _InfiniteSnapListState<T> extends State<InfiniteSnapList<T>> {
  late final ScrollController _controller;
  Timer? _snapTimer;
  bool _isInitializing = true;
  bool _isSnapping = false;
  int _lastSnappedIndex = -1;
  late StreamSubscription _blocSubscription;

  double _currentActualWidth = 0;
  double _currentStartEndPadding = 0;

  double get _totalItemSlotWidth => widget.itemWidth + widget.itemSpacing;

  @override
  void initState() {
    super.initState();
    // Non inizializziamo _controller con initialScrollOffset qui direttamente,
    // perché la larghezza effettiva (_currentActualWidth) non è ancora disponibile.
    // Lo faremo all'interno del LayoutBuilder quando necessario.
    _controller = ScrollController();
    _controller.addListener(_onScroll);

    _blocSubscription = widget.bloc.stream.listen((state) {
      if (state is LoadedState<T>) {
        // Applica la compensazione se sono stati aggiunti elementi all'inizio
        if (state.prependedItemCount > 0 && _controller.hasClients) {
          final compensationOffset =
              state.prependedItemCount * _totalItemSlotWidth;
          final currentOffset = _controller.offset;
          final newTargetOffset = currentOffset + compensationOffset;

          // Esegui il jumpTo immediatamente per prevenire il flash visivo.
          _controller.jumpTo(newTargetOffset);
          debugPrint(
              'WIDGET: Compensato offset per ${state.prependedItemCount} elementi prepended. Nuovo offset: $newTargetOffset');
        }

        // Dopo qualsiasi compensazione o caricamento, assicurati che l'elemento selezionato sia centrato.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients &&
              state.state.items.isNotEmpty &&
              state.state.selectedItem != null) {
            final targetIndex =
                state.state.items.indexOf(state.state.selectedItem!);
            if (targetIndex != -1) {
              _snapTo(targetIndex);
            }
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Imposta _isInitializing a false solo dopo un piccolo ritardo per permettere
      // al BLoC di avviare il caricamento e al LayoutBuilder di ottenere la larghezza.
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) setState(() => _isInitializing = false);
      });
    });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _blocSubscription.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isInitializing || _isSnapping || _currentActualWidth == 0) return;

    final currentItems = widget.bloc.state.state.items;
    if (currentItems.isEmpty) return;

    final double viewportCenterInScrollExtent =
        _controller.offset + (_currentActualWidth / 2);

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < currentItems.length; i++) {
      final double itemSlotCenterInScrollExtent = _currentStartEndPadding +
          (i * _totalItemSlotWidth) +
          (_totalItemSlotWidth / 2);

      final double distance =
          (itemSlotCenterInScrollExtent - viewportCenterInScrollExtent).abs();

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    _snapTimer?.cancel();
    _snapTimer =
        Timer(const Duration(milliseconds: 200), () => _snapTo(closestIndex));
  }

  void _snapTo(int index) {
    final bloc = widget.bloc;
    final currentItems = bloc.state.state.items;
    if (index < 0 ||
        index >= currentItems.length ||
        !_controller.hasClients ||
        _currentActualWidth == 0) {
      return;
    }

    final double targetScrollOffset = (index * _totalItemSlotWidth);

    final maxScrollExtent = _controller.position.maxScrollExtent;
    final clampedTargetOffset = targetScrollOffset.clamp(0.0, maxScrollExtent);

    _isSnapping = true;
    _controller
        .animateTo(
      clampedTargetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .whenComplete(() {
      _isSnapping = false;

      final selected = currentItems[index];
      if (_lastSnappedIndex != index) {
        _lastSnappedIndex = index;
        bloc.add(SelectItemEvent<T>(selected));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfiniteListBloc<T>, InfiniteSnapListState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = state.state.items;
        final selected = state.state.selectedItem;
        // Si assume che selectedItem non sia null dato il design del BLoC
        final selectedItemIndex = items.indexOf(selected);

        // Determina l'offset iniziale per il ListView.builder
        // Questo calcolo tenta di posizionare l'initValue (se presente) al centro
        // prima che il listener del BLoC applichi lo snap definitivo.
        if (state is InitialState<T> && !items.contains(selected)) {
          // Se siamo in stato iniziale e l'elemento selezionato non è ancora nella lista,
          // stimiamo la sua posizione per un posizionamento iniziale.
          // Assumiamo che l'initValue sarà caricato al centro della lista iniziale di shimmer/placeholder.
          // Questo è un tentativo euristico per ridurre il "salto".
        } else if (items.isNotEmpty) {
          // Se la lista ha già elementi, usiamo l'indice dell'elemento selezionato
          // per calcolare un offset di partenza più preciso.
          final indexToScrollTo = items.indexOf(selected);
          if (indexToScrollTo != -1) {}
        }

        if (state is InitialState<T> ||
            (state is LoadingState<T> &&
                state.state.loadingDirection == LoadingDirection.initial)) {
          return LayoutBuilder(
            builder: (context, constraints) {
              _currentActualWidth = constraints.maxWidth;
              _currentStartEndPadding =
                  (_currentActualWidth / 2) - (_totalItemSlotWidth / 2);
              return _buildShimmerList(
                  context, widget.initialItemsCountForShimmer);
            },
          );
        }

        if (state is ErrorState<T>) {
          return widget.errorBuilder?.call(context, state.error) ??
              _defaultErrorBuilder(context, state.error);
        }

        if (items.isEmpty) {
          return widget.emptyListBuilder?.call(context) ??
              _defaultEmptyListBuilder(context);
        }

        final isLoading = state is LoadingState<T>;
        final loadingDirection = state.state.loadingDirection;
        final showLoader =
            isLoading && loadingDirection != null && items.isNotEmpty;

        return SizedBox(
          width: double.infinity,
          height: widget.itemHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              _currentActualWidth = constraints.maxWidth;
              _currentStartEndPadding =
                  (_currentActualWidth / 2) - (_totalItemSlotWidth / 2);

              return Stack(
                children: [
                  Center(
                    child: widget.selectedItemOverlayBuilder?.call(
                            context, _totalItemSlotWidth, widget.itemHeight) ??
                        _defaultSelectedItemOverlayBuilder(
                            context, _totalItemSlotWidth, widget.itemHeight),
                  ),
                  ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    physics: (_isSnapping || (isLoading && showLoader))
                        ? const NeverScrollableScrollPhysics()
                        : widget.scrollPhysics,
                    padding: EdgeInsets.symmetric(
                        horizontal: _currentStartEndPadding),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final isSelected = i == selectedItemIndex;

                      return SizedBox(
                        width: _totalItemSlotWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.itemSpacing / 2),
                          child: InkWell(
                            onTap: () {
                              if (!_isSnapping && !isLoading) {
                                _snapTo(i);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: widget.itemWidth,
                              height: widget.itemHeight,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
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
                      );
                    },
                  ),
                  if (showLoader)
                    Positioned(
                      right:
                          loadingDirection == LoadingDirection.right ? 0 : null,
                      left:
                          loadingDirection == LoadingDirection.left ? 0 : null,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: widget.itemWidth,
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
        );
      },
    );
  }

  Widget _buildShimmerList(BuildContext context, int count) {
    return SizedBox(
      width: double.infinity,
      height: widget.itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _currentStartEndPadding),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, __) => SizedBox(width: widget.itemSpacing),
        itemBuilder: (context, index) {
          return widget.loadingShimmerItemBuilder?.call(context, index) ??
              _defaultShimmerItemBuilder(context, index);
        },
      ),
    );
  }

  Widget _defaultShimmerItemBuilder(BuildContext context, int index) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: widget.itemWidth,
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _defaultSelectedItemOverlayBuilder(
      BuildContext context, double totalItemSlotWidth, double itemHeight) {
    return Container(
      width: totalItemSlotWidth,
      height: itemHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withCustomOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _defaultLoadingIndicatorBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }

  Widget _defaultEmptyListBuilder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.emptyListMessage, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _defaultErrorBuilder(BuildContext context, Exception error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error: ${error.toString()}',
            style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
