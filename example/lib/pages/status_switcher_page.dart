import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/risto_widgets.dart';

// ===========================================================================
// DEMO BLOC & STATE
// ===========================================================================

abstract class DemoEvent {}

class DemoTriggerLoading extends DemoEvent {}

class DemoTriggerError extends DemoEvent {}

class DemoTriggerEmpty extends DemoEvent {}

class DemoTriggerContent extends DemoEvent {}

class DemoState {
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final int contentDataCounter;

  const DemoState({
    this.isLoading = false,
    this.hasError = false,
    this.isEmpty = false,
    this.contentDataCounter = 0,
  });

  DemoState copyWith({
    bool? isLoading,
    bool? hasError,
    bool? isEmpty,
    int? contentDataCounter,
  }) {
    return DemoState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      isEmpty: isEmpty ?? this.isEmpty,
      contentDataCounter: contentDataCounter ?? this.contentDataCounter,
    );
  }
}

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(const DemoState()) {
    on<DemoTriggerLoading>((event, emit) {
      emit(state.copyWith(isLoading: true, hasError: false, isEmpty: false));
    });

    on<DemoTriggerError>((event, emit) {
      emit(state.copyWith(isLoading: false, hasError: true, isEmpty: false));
    });

    on<DemoTriggerEmpty>((event, emit) {
      emit(state.copyWith(isLoading: false, hasError: false, isEmpty: true));
    });

    on<DemoTriggerContent>((event, emit) async {
      emit(state.copyWith(isLoading: true, hasError: false, isEmpty: false));
      // Simulate network delay for effect
      await Future.delayed(const Duration(milliseconds: 800));
      emit(
        state.copyWith(
          isLoading: false,
          hasError: false,
          isEmpty: false,
          contentDataCounter: state.contentDataCounter + 1,
        ),
      );
    });
  }
}

// ===========================================================================
// EXAMPLE PAGE
// ===========================================================================

class StatusSwitcherPage extends StatelessWidget {
  const StatusSwitcherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Auto-trigger loading on start so the user immediately sees the loading state
      create: (_) => DemoBloc()..add(DemoTriggerLoading()),
      child: const _StatusSwitcherView(),
    );
  }
}

class _StatusSwitcherView extends StatelessWidget {
  const _StatusSwitcherView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.labelMedium ?? const TextStyle();

    return Scaffold(
      appBar: AppBar(title: const Text('Status Switcher')),
      body: BlocBuilder<DemoBloc, DemoState>(
        builder: (context, state) {
          // Determine active segment index based on Bloc state
          int segmentIndex = 1; // Default to Content
          if (state.isLoading) segmentIndex = 0;
          if (state.isEmpty) segmentIndex = 2;
          if (state.hasError) segmentIndex = 3;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Text(
                'Status Switcher (.computed)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Seamlessly animates between Loading, Empty, Error, and Content states based purely on boolean flags passed from your BLoC.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // --- CONTROLS ---
              SegmentedControl(
                initialIndex: segmentIndex,
                onSegmentSelected: (index) {
                  final bloc = BlocProvider.of<DemoBloc>(context);
                  if (index == 0) {
                    bloc.add(DemoTriggerLoading());
                  } else if (index == 1) {
                    bloc.add(DemoTriggerContent());
                  } else if (index == 2) {
                    bloc.add(DemoTriggerEmpty());
                  } else if (index == 3) {
                    bloc.add(DemoTriggerError());
                  }
                },
                style: SegmentedControl.styleFrom(
                  indicatorColor: theme.primaryColor,
                  selectedTextStyle: baseStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedTextStyle: baseStyle.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                segments: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Load'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Content'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Empty'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Error'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- EXAMPLE 1: Full Block ---
              Text('Full Block Example', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),

              RistoStatusSwitcher.computed(
                isLoading: state.isLoading,
                hasError: state.hasError,
                isEmpty: state.isEmpty,
                backgroundColor: Colors.white,
                borderColor: Colors.blueGrey.shade100,
                padding: const EdgeInsets.all(16),
                minHeight: 250,
                alignment: Alignment.center,
                defaultEmptyTitle: 'No students found',
                defaultEmptySubtitle:
                    'Try adjusting your filters to see results.',
                defaultErrorTitle: 'Network Timeout',
                defaultErrorSubtitle:
                    'Could not fetch the latest school menu. Please check your connection.',
                onRetry:
                    () => BlocProvider.of<DemoBloc>(
                      context,
                    ).add(DemoTriggerContent()),
                contentBuilder:
                    (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTileButton(
                          body: Text(
                            'Pizza Margherita (Loaded ${state.contentDataCounter}x)',
                          ),
                          subtitle: const Text('Main Course'),
                          leading: const Icon(
                            Icons.local_pizza,
                            color: Colors.orange,
                            size: 32,
                          ),
                          onPressed:
                              () => RistoToast.info(
                                context,
                                message: 'Pizza tapped!',
                              ),
                          backgroundColor: Colors.orange.shade50,
                          borderColor: Colors.orange.shade200,
                        ),
                        const SizedBox(height: 12),
                        ListTileButton(
                          body: const Text('Caesar Salad'),
                          subtitle: const Text('Side Dish'),
                          leading: const Icon(
                            Icons.eco,
                            color: Colors.green,
                            size: 32,
                          ),
                          onPressed:
                              () => RistoToast.info(
                                context,
                                message: 'Salad tapped!',
                              ),
                          backgroundColor: Colors.green.shade50,
                          borderColor: Colors.green.shade200,
                        ),
                      ],
                    ),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),

              // --- EXAMPLE 2: Card Style ---
              Text('Card Style Example', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'The switcher automatically constraints its size to perfectly fit smaller areas like cards.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: RistoStatusSwitcher.computed(
                      isLoading: state.isLoading,
                      hasError: state.hasError,
                      isEmpty: state.isEmpty,
                      backgroundColor: Colors.blue.shade50,
                      borderColor: Colors.blue.shade200,
                      padding: const EdgeInsets.all(24),
                      minHeight: 140,
                      // Smaller min height for cards
                      defaultEmptyTitle: 'No Stats',
                      defaultErrorTitle: 'Failed',
                      onRetry:
                          () => BlocProvider.of<DemoBloc>(
                            context,
                          ).add(DemoTriggerContent()),
                      contentBuilder:
                          (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 36,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '+${state.contentDataCounter * 12}%',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const Text('Growth'),
                            ],
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RistoStatusSwitcher.computed(
                      isLoading: state.isLoading,
                      hasError: state.hasError,
                      isEmpty: state.isEmpty,
                      backgroundColor: Colors.purple.shade50,
                      borderColor: Colors.purple.shade200,
                      padding: const EdgeInsets.all(24),
                      minHeight: 140,
                      defaultEmptyTitle: 'No Users',
                      defaultErrorTitle: 'Failed',
                      onRetry:
                          () => BlocProvider.of<DemoBloc>(
                            context,
                          ).add(DemoTriggerContent()),
                      contentBuilder:
                          (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people,
                                size: 36,
                                color: Colors.purple,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${state.contentDataCounter * 42}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade900,
                                ),
                              ),
                              const Text('Active Users'),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
