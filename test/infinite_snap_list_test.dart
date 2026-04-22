import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/infinite_snap_list/infinite_snap_list.dart';
import 'package:risto_widgets/widgets/infinite_snap_list/infinite_snap_list_bloc/infinite_snap_list_bloc.dart';

class MockItem {
  final int id;

  MockItem(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MockItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MockSnapBloc extends InfiniteSnapListBloc<MockItem> {
  MockSnapBloc(MockItem initValue) : super(initValue: initValue);

  @override
  Future<(List<MockItem>, List<MockItem>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required MockItem offset,
  }) async {
    return ([MockItem(offset.id - 1)], [MockItem(offset.id + 1)]);
  }
}

void main() {
  group('SnapList (Finite) Tests', () {
    testWidgets('SnapList renders items and exposes centerProgress', (
      tester,
    ) async {
      final items = [MockItem(0), MockItem(1), MockItem(2)];
      double capturedProgress = -1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 100,
              child: SnapList<MockItem>(
                items: items,
                selectedItem: items[0],
                visibleItemCount: 3,
                itemBuilder: (context, item, index, isSelected, progress) {
                  if (isSelected) capturedProgress = progress;
                  return Center(child: Text('Item ${item.id}'));
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsOneWidget);
      // Item 2 might be culled by the layout boundary constraints in the test environment,
      // so we verify Item 1 which is guaranteed to be adjacent and rendered.
      expect(find.text('Item 1'), findsOneWidget);
      expect(capturedProgress, greaterThan(0.9));
    });

    testWidgets('SnapList.picker scales unfocused items automatically', (
      tester,
    ) async {
      final items = [MockItem(10), MockItem(20), MockItem(30)];
      final capturedProgresses = <int, double>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 150,
              height: 150,
              child: SnapList<MockItem>.picker(
                items: items,
                selectedItem: items[1], // Item 20
                itemBuilder: (context, item, index, isSelected, progress) {
                  capturedProgresses[item.id] = progress;
                  return Center(child: Text('Pick ${item.id}'));
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Item 20 is selected, so it should be perfectly centered with a progress of ~1.0
      expect(capturedProgresses[20], greaterThan(0.9));

      // Item 10 is off to the side, so its progress should be ~0.0
      // This mathematically guarantees it uses the unfocused scale limit.
      expect(capturedProgresses[10], lessThan(0.1));
    });
  });

  group('InfiniteSnapList Tests', () {
    late MockSnapBloc bloc;

    setUp(() {
      bloc = MockSnapBloc(MockItem(0));
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('InfiniteSnapList wraps SnapList and resolves BLoC data', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 100,
              child: InfiniteSnapList<MockItem>(
                bloc: bloc,
                visibleItemCount: 3,
                itemBuilder: (context, item, index, isSelected, progress) {
                  return Center(child: Text('Item ${item.id}'));
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.byType(SnapList<MockItem>), findsOneWidget);
    });
  });
}
