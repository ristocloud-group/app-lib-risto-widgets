import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/risto_widgets.dart';

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
      await Future.delayed(const Duration(milliseconds: 600));
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

class StatusSwitcherPage extends StatelessWidget {
  const StatusSwitcherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const _StatusSwitcherView(),
    );
  }
}

class _StatusSwitcherView extends StatelessWidget {
  const _StatusSwitcherView();

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        Theme.of(context).textTheme.labelMedium ?? const TextStyle();

    return BlocBuilder<DemoBloc, DemoState>(
      builder: (context, state) {
        int segmentIndex = 1;
        if (state.isLoading) segmentIndex = 0;
        if (state.isEmpty) segmentIndex = 2;
        if (state.hasError) segmentIndex = 3;

        return PaddedChildrenList(
          children: [
            Text(
              'Status Switcher (.computed Bloc Edition)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Now mapped to a full flutter_bloc implementation using Events.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

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
                indicatorColor: Theme.of(context).primaryColor,
                selectedTextStyle: baseStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedTextStyle: baseStyle.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              segments: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Load'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Content'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Empty'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Error'),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              'Computed Factory Example',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            RistoStatusSwitcher.computed(
              isLoading: state.isLoading,
              hasError: state.hasError,
              isEmpty: state.isEmpty,
              backgroundColor: Colors.grey.shade50,
              borderColor: Colors.black12,
              padding: const EdgeInsets.all(16),
              minHeight: 180,
              alignment: Alignment.center,
              defaultEmptyTitle: 'No students found',
              defaultEmptySubtitle:
                  'Try adjusting your filters to see results.',
              defaultErrorTitle: 'Network Timeout',
              defaultErrorSubtitle: 'Could not fetch the latest school menu.',
              onRetry:
                  () => BlocProvider.of<DemoBloc>(
                    context,
                  ).add(DemoTriggerContent()),
              contentBuilder:
                  (context) => Column(
                    children: [
                      ListTileButton(
                        body: Text(
                          'Pizza Margherita (Loaded ${state.contentDataCounter}x)',
                        ),
                        subtitle: const Text('Main Course'),
                        leading: const Icon(
                          Icons.local_pizza,
                          color: Colors.orange,
                        ),
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        borderColor: Colors.black12,
                      ),
                    ],
                  ),
            ),
          ],
        );
      },
    );
  }
}
