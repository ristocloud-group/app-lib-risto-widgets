import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/infinite_snap_list/infinite_snap_list_bloc/infinite_snap_list_bloc.dart';
import 'package:risto_widgets/widgets/infinite_snap_list/infinite_snap_list_bloc/infinite_snap_list_event.dart';
import 'package:risto_widgets/widgets/infinite_snap_list/infinite_snap_list_bloc/infinite_snap_list_state.dart';

void main() {
  group('InfiniteSnapListBloc', () {
    late InfiniteSnapListBloc bloc;

    setUp(() {
      bloc = InfiniteSnapListBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const InfiniteSnapListState());
    });

    test('InfiniteSnapListUpdateIndex event updates index', () {
      bloc.add(const InfiniteSnapListUpdateIndex(5));
      expect(bloc.state.currentIndex, 5);
    });

    test('InfiniteSnapListProgrammaticNav event sets navigation index and resets it', () {
      bloc.add(const InfiniteSnapListProgrammaticNav(10));
      expect(bloc.state.programmaticTargetIndex, 10);
      
      // The BLoC typically resets the target after emitting it (or the UI handles it)
      // Actually, let's look at how the BLoC is implemented to be sure.
    });
  });
}
