import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/extensions.dart';
import 'package:shimmer/shimmer.dart';

import 'infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

/// Widget per una lista orizzontale con snap e fetch infinito bidirezionale.
/// Fornisce un'ampia personalizzazione attraverso parametri diretti e builder.
class InfiniteSnapList<T> extends StatefulWidget {
  /// Il BLoC che gestisce lo stato e la logica di caricamento della lista.
  final InfiniteListBloc<T> bloc;

  /// Builder per renderizzare un singolo elemento della lista.
  /// Riceve il contesto, l'elemento, il suo indice e se è selezionato.
  final Widget Function(
      BuildContext context, T item, int index, bool isSelected) itemBuilder;

  /// Builder opzionale per un singolo elemento shimmer durante il caricamento iniziale.
  /// Riceve il [BuildContext] e l'indice dell'elemento.
  /// Se non fornito, viene utilizzato un builder predefinito personalizzabile.
  final Widget Function(BuildContext context, int index)?
      loadingShimmerItemBuilder;

  /// Larghezza desiderata per ogni elemento della lista.
  final double itemWidth;

  /// Altezza desiderata per ogni elemento della lista.
  final double itemHeight;

  /// Spaziatura tra gli elementi della lista.
  final double itemSpacing;

  /// La fisica dello scroll della lista.
  final ScrollPhysics scrollPhysics;

  /// Messaggio da visualizzare quando la lista è vuota e nessun `emptyListBuilder` è fornito.
  final String emptyListMessage;

  /// Builder opzionale per visualizzare un errore.
  /// Riceve il [BuildContext] e l'?[Exception].
  /// Se non fornito, viene utilizzato un builder predefinito personalizzabile.
  final Widget Function(BuildContext context, Exception)? errorBuilder;

  /// Numero di elementi shimmer da mostrare durante il caricamento iniziale.
  final int initialItemsCountForShimmer;

  /// Builder opzionale per l'overlay dell'elemento selezionato.
  /// Riceve il [BuildContext], la larghezza totale dello slot dell'elemento
  /// (itemWidth + itemSpacing) e l'altezza dell'elemento.
  /// Se non fornito, viene utilizzato un builder predefinito personalizzabile.
  final Widget Function(
          BuildContext context, double totalItemSlotWidth, double itemHeight)?
      selectedItemOverlayBuilder;

  /// Builder opzionale per l'indicatore di caricamento (es. durante il fetch di nuovi dati).
  /// Riceve il [BuildContext].
  /// Se non fornito, viene utilizzato un builder predefinito personalizzabile.
  final Widget Function(BuildContext context)? loadingIndicatorBuilder;

  /// Builder opzionale per la lista vuota.
  /// Riceve il [BuildContext].
  /// Se non fornito, viene utilizzato un builder predefinito personalizzabile.
  final Widget Function(BuildContext context)? emptyListBuilder;

  /// Colore di base per lo shimmer predefinito.
  final Color? shimmerBaseColor;

  /// Colore di highlight per lo shimmer predefinito.
  final Color? shimmerHighlightColor;

  /// Raggio del bordo per lo shimmer predefinito.
  final BorderRadius? shimmerBorderRadius;

  /// Colore per l'overlay dell'elemento selezionato predefinito.
  final Color? selectedOverlayColor;

  /// Raggio del bordo per l'overlay dell'elemento selezionato predefinito.
  final BorderRadius? selectedOverlayBorderRadius;

  /// Larghezza del tratto per l'indicatore di caricamento predefinito (CircularProgressIndicator).
  final double? loadingIndicatorStrokeWidth;

  /// Colore per l'indicatore di caricamento predefinito (CircularProgressIndicator).
  final Color? loadingIndicatorColor;

  /// Stile del testo per il messaggio di lista vuota predefinito.
  final TextStyle? emptyListTextStyle;

  /// Padding per il messaggio di lista vuota predefinito.
  final EdgeInsetsGeometry? emptyListPadding;

  /// Stile del testo per il messaggio di errore predefinito.
  final TextStyle? errorTextStyle;

  /// Padding per il messaggio di errore predefinito.
  final EdgeInsetsGeometry? errorPadding;

  /// Raggio del bordo per l'effetto InkWell di ogni elemento tappabile.
  final BorderRadius? itemInkWellBorderRadius;

  /// Durata dell'animazione di fade quando un elemento cambia stato (es. selezionato/deselezionato).
  final Duration itemFadeAnimationDuration;

  /// Durata dell'animazione di snap per centrare un elemento.
  final Duration snapAnimationDuration;

  /// Curva dell'animazione di snap per centrare un elemento.
  final Curve snapAnimationCurve;

  /// Durata del timer prima che avvenga lo snap dopo lo scroll.
  final Duration snapTimerDuration;

  /// Colore dello splash effect dell'InkWell.
  final Color? inkWellSplashColor;

  /// Colore di highlight dell'InkWell.
  final Color? inkWellHighlightColor;

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
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerBorderRadius,
    this.selectedOverlayColor,
    this.selectedOverlayBorderRadius,
    this.loadingIndicatorStrokeWidth = 2,
    this.loadingIndicatorColor,
    this.emptyListTextStyle,
    this.emptyListPadding = const EdgeInsets.all(16.0),
    this.errorTextStyle,
    this.errorPadding = const EdgeInsets.all(16.0),
    this.itemInkWellBorderRadius,
    this.itemFadeAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.snapTimerDuration = const Duration(milliseconds: 200),
    this.inkWellSplashColor,
    this.inkWellHighlightColor,
  });

  @override
  State<InfiniteSnapList<T>> createState() => _InfiniteSnapListState<T>();
}

class _InfiniteSnapListState<T> extends State<InfiniteSnapList<T>> {
  late final ScrollController _controller;
  Timer? _snapTimer;
  bool _isInitializing = true;
  bool _isSnapping = false;
  int _lastSnappedIndex =
      -1; // Indice dell'ultimo elemento su cui è stato fatto lo snap
  late StreamSubscription _blocSubscription;

  double _currentActualWidth = 0; // Larghezza attuale del widget
  double _currentStartEndPadding =
      0; // Padding da applicare all'inizio e alla fine della lista

  // Larghezza totale occupata da un singolo elemento (larghezza + spaziatura)
  double get _totalItemSlotWidth => widget.itemWidth + widget.itemSpacing;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);

    // Sottoscrizione per gestire i cambiamenti di stato del BLoC
    _blocSubscription = widget.bloc.stream.listen((state) {
      if (state is LoadedState<T>) {
        // Applica la compensazione se sono stati aggiunti elementi all'inizio (prepended)
        if (state.prependedItemCount > 0 && _controller.hasClients) {
          final compensationOffset =
              state.prependedItemCount * _totalItemSlotWidth;
          final currentOffset = _controller.offset;
          final newTargetOffset = currentOffset + compensationOffset;

          // Esegui il jumpTo immediatamente per prevenire il flash visivo
          _controller.jumpTo(newTargetOffset);
          debugPrint(
              'InfiniteSnapList: Compensato offset per ${state.prependedItemCount} elementi prepended. Nuovo offset: $newTargetOffset');
        }

        // Dopo qualsiasi compensazione o caricamento, assicurati che l'elemento selezionato sia centrato.
        // Questo viene posticipato al prossimo frame per assicurare che il layout sia aggiornato.
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
      } else if (state is ErrorState<T>) {
        debugPrint(
            'InfiniteSnapList: Errore nello stato del BLoC: ${state.error}');
      }
    });

    // Imposta _isInitializing a false dopo un breve ritardo per permettere al BLoC
    // di avviare il caricamento e al LayoutBuilder di ottenere la larghezza effettiva.
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  /// Callback richiamato ad ogni scroll della lista.
  /// Calcola l'elemento più vicino al centro e avvia un timer per lo snap.
  void _onScroll() {
    // Evita di eseguire la logica di snap durante l'inizializzazione, uno snap attivo, o quando la larghezza non è disponibile.
    if (_isInitializing || _isSnapping || _currentActualWidth == 0) return;

    final currentItems = widget.bloc.state.state.items;
    if (currentItems.isEmpty) return;

    // Calcola il centro della viewport rispetto all'estensione di scroll
    final double viewportCenterInScrollExtent =
        _controller.offset + (_currentActualWidth / 2);

    double minDistance = double.infinity;
    int closestIndex = 0;

    // Trova l'elemento più vicino al centro della viewport
    for (int i = 0; i < currentItems.length; i++) {
      // Calcola il centro dello slot dell'elemento rispetto all'estensione di scroll
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

    // Cancella il timer precedente e avviane uno nuovo per lo snap,
    // evitando snap continui durante lo scroll rapido.
    _snapTimer?.cancel();
    _snapTimer = Timer(widget.snapTimerDuration, () => _snapTo(closestIndex));
  }

  /// Esegue lo snap (animazione di scroll) all'elemento specificato.
  void _snapTo(int index) {
    final bloc = widget.bloc;
    final currentItems = bloc.state.state.items;
    // Controlli di validità
    if (index < 0 ||
        index >= currentItems.length ||
        !_controller.hasClients ||
        _currentActualWidth == 0) {
      return;
    }

    // Calcola l'offset di scroll target per centrare l'elemento
    final double targetScrollOffset = (index * _totalItemSlotWidth);

    // Clampa l'offset per assicurarsi che non superi i limiti di scroll
    final maxScrollExtent = _controller.position.maxScrollExtent;
    final clampedTargetOffset = targetScrollOffset.clamp(0.0, maxScrollExtent);

    // Imposta il flag _isSnapping per disabilitare lo scroll manuale durante l'animazione
    _isSnapping = true;
    _controller
        .animateTo(
      clampedTargetOffset,
      duration: widget.snapAnimationDuration,
      curve: widget.snapAnimationCurve,
    )
        .whenComplete(() {
      // Resetta il flag una volta completata l'animazione
      _isSnapping = false;

      // Se l'elemento su cui è stato fatto lo snap è diverso dall'ultimo, notifica il BLoC
      final selected = currentItems[index];
      if (_lastSnappedIndex != index) {
        _lastSnappedIndex = index;
        bloc.add(SelectItemEvent<T>(selected));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utilizza BlocBuilder per ricostruire il widget in base ai cambiamenti di stato del BLoC
    return BlocBuilder<InfiniteListBloc<T>, InfiniteSnapListState<T>>(
      bloc: widget.bloc,
      builder: (context, state) {
        final items = state.state.items;
        final selected = state.state.selectedItem;
        final selectedItemIndex = items.indexOf(selected);

        // Gestione dello stato iniziale o di caricamento iniziale
        if (state is InitialState<T> ||
            (state is LoadingState<T> &&
                state.state.loadingDirection == LoadingDirection.initial)) {
          // Utilizza LayoutBuilder per ottenere la larghezza effettiva del widget
          // prima di costruire la lista shimmer.
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

        // Gestione dello stato di errore
        if (state is ErrorState<T>) {
          return widget.errorBuilder?.call(context, state.error) ??
              _defaultErrorBuilder(context, state.error);
        }

        // Gestione dello stato di lista vuota
        if (items.isEmpty) {
          return widget.emptyListBuilder?.call(context) ??
              _defaultEmptyListBuilder(context);
        }

        // Determina se mostrare l'indicatore di caricamento (solo se non è il caricamento iniziale
        // e ci sono già elementi nella lista).
        final isLoading = state is LoadingState<T>;
        final loadingDirection = state.state.loadingDirection;
        final showLoader =
            isLoading && loadingDirection != null && items.isNotEmpty;

        return SizedBox(
          width: double.infinity,
          height: widget.itemHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Aggiorna larghezza effettiva e padding
              _currentActualWidth = constraints.maxWidth;
              _currentStartEndPadding =
                  (_currentActualWidth / 2) - (_totalItemSlotWidth / 2);

              return Stack(
                children: [
                  // Overlay dell'elemento selezionato posizionato al centro
                  Center(
                    child: widget.selectedItemOverlayBuilder?.call(
                            context, _totalItemSlotWidth, widget.itemHeight) ??
                        _defaultSelectedItemOverlayBuilder(
                            context, _totalItemSlotWidth, widget.itemHeight),
                  ),
                  // La lista scrollabile degli elementi
                  ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    // Disabilita lo scroll manuale durante lo snap o il caricamento
                    physics: (_isSnapping || showLoader)
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
                            // Abilita il tap solo se non è in corso uno snap o un caricamento
                            onTap: () {
                              if (!_isSnapping && !isLoading) {
                                _snapTo(i);
                              }
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
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                                // La chiave è fondamentale per AnimatedSwitcher per animare correttamente i cambiamenti
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
                  // Indicatore di caricamento posizionato a sinistra o a destra
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

  /// Costruisce una lista di elementi shimmer.
  Widget _buildShimmerList(BuildContext context, int count) {
    return SizedBox(
      width: double.infinity,
      height: widget.itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _currentStartEndPadding),
        // Lo scroll è disabilitato per la lista shimmer
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

  /// Builder predefinito per un singolo elemento shimmer.
  Widget _defaultShimmerItemBuilder(BuildContext context, int index) {
    // Recupera i colori dal tema o usa i fallback predefiniti
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
          color: baseColor, // Usa il colore di base anche per il container
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  /// Builder predefinito per l'overlay dell'elemento selezionato.
  Widget _defaultSelectedItemOverlayBuilder(
      BuildContext context, double totalItemSlotWidth, double itemHeight) {
    final overlayColor = widget.selectedOverlayColor ??
        Theme.of(context).colorScheme.secondary.withCustomOpacity(0.2);
    final borderRadius =
        widget.selectedOverlayBorderRadius ?? BorderRadius.circular(8.0);

    return Container(
      width: totalItemSlotWidth,
      height: itemHeight,
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Builder predefinito per l'indicatore di caricamento.
  Widget _defaultLoadingIndicatorBuilder(BuildContext context) {
    final indicatorColor = widget.loadingIndicatorColor; // Nullable
    final strokeWidth = widget.loadingIndicatorStrokeWidth ?? 2; // Default 2

    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: indicatorColor != null
            ? AlwaysStoppedAnimation<Color>(indicatorColor)
            : null, // Usa il colore se fornito, altrimenti usa il default del tema
      ),
    );
  }

  /// Builder predefinito per il messaggio di lista vuota.
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

  /// Builder predefinito per il messaggio di errore.
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
