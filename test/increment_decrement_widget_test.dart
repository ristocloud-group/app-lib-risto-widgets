import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('IncrementDecrementWidget - Synchronous Callbacks', () {
    testWidgets('Initial state is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementSyncTestWidget(),
          ),
        ),
      );

      // Verify the initial quantity is 1.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Increments quantity when add button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementSyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(); // Trigger a rebuild after the tap.

      // Verify the quantity increases to 2.
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Decrements quantity when remove button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementSyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button once to set quantity to 2.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Tap the decrement button.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump(); // Trigger a rebuild after the tap.

      // Verify the quantity decreases back to 1.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Decrement button is disabled when quantity is at minValue',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementSyncTestWidget(),
          ),
        ),
      );

      // Verify the decrement button is disabled when quantity is at minValue (1).
      final decrementButton =
          find.widgetWithIcon(CustomActionButton, Icons.remove);
      final CustomActionButton buttonWidget = tester.widget(decrementButton);
      expect(buttonWidget.onPressed, isNull,
          reason: 'Decrement button should be disabled at minValue');
    });

    testWidgets('Increment button is disabled when quantity is at maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementSyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button until quantity reaches maxQuantity (10).
      for (int i = 0; i < 9; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      // Verify the increment button is disabled when quantity reaches maxQuantity.
      final incrementButton =
          find.widgetWithIcon(CustomActionButton, Icons.add);
      final CustomActionButton buttonWidget = tester.widget(incrementButton);
      expect(buttonWidget.onPressed, isNull,
          reason: 'Increment button should be disabled at maxQuantity');
    });
  });

  group('IncrementDecrementWidget - Asynchronous Callbacks', () {
    testWidgets('Initial state is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementAsyncTestWidget(),
          ),
        ),
      );

      // Verify the initial quantity is 1.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'Increments quantity when add button is tapped with async callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementAsyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(); // Start the async operation.

      // Since the async operation takes 100ms, pump until completion.
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the quantity increases to 2 (1 + 1 from async callback).
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
        'Decrements quantity when remove button is tapped with async callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementAsyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button once to set quantity to 2.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump(); // Start the async operation.
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the decrement button.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump(); // Start the async operation.
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the quantity decreases back to 1 (2 - 1 + 0 from async callback).
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
        'Decrement button is disabled when quantity is at minValue with async callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementAsyncTestWidget(),
          ),
        ),
      );

      // Ensure quantity is at minValue (1).
      expect(find.text('1'), findsOneWidget);

      // Verify the decrement button is disabled.
      final decrementButton =
          find.widgetWithIcon(CustomActionButton, Icons.remove);
      final CustomActionButton buttonWidget = tester.widget(decrementButton);
      expect(buttonWidget.onPressed, isNull,
          reason: 'Decrement button should be disabled at minValue');
    });

    testWidgets(
        'Increment button is disabled when quantity is at maxQuantity with async callback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _IncrementDecrementAsyncTestWidget(),
          ),
        ),
      );

      // Tap the increment button until quantity reaches maxQuantity (10).
      for (int i = 0; i < 9; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump(); // Start async operation
        await tester.pump(
            const Duration(milliseconds: 100)); // Complete async operation
      }

      // Since maxQuantity is 10, quantity should cap at 10.
      expect(find.text('10'), findsOneWidget);

      // Verify the increment button is disabled when quantity reaches maxQuantity.
      final incrementButton =
          find.widgetWithIcon(CustomActionButton, Icons.add);
      final CustomActionButton buttonWidget = tester.widget(incrementButton);
      expect(buttonWidget.onPressed, isNull,
          reason: 'Increment button should be disabled at maxQuantity');
    });
  });
}

// A Stateful widget to manage the state during synchronous tests
class _IncrementDecrementSyncTestWidget extends StatefulWidget {
  @override
  __IncrementDecrementSyncTestWidgetState createState() =>
      __IncrementDecrementSyncTestWidgetState();
}

class __IncrementDecrementSyncTestWidgetState
    extends State<_IncrementDecrementSyncTestWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: 10,
      minValue: 1,
      onChanged: (newQuantity) {
        setState(() {
          quantity = newQuantity;
        });
        return quantity; // Returning int?
      },
    );
  }
}

// A Stateful widget to manage the state during asynchronous tests
class _IncrementDecrementAsyncTestWidget extends StatefulWidget {
  @override
  __IncrementDecrementAsyncTestWidgetState createState() =>
      __IncrementDecrementAsyncTestWidgetState();
}

class __IncrementDecrementAsyncTestWidgetState
    extends State<_IncrementDecrementAsyncTestWidget> {
  int quantity = 1;

  Future<int?> asyncOnChanged(int newQuantity) async {
    // Simulate an asynchronous operation, e.g., server validation
    await Future.delayed(const Duration(milliseconds: 100));
    // Return the updated quantity without modification
    return newQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return IncrementDecrementWidget(
      quantity: quantity,
      maxQuantity: 10,
      minValue: 1,
      onChanged: asyncOnChanged, // Returning Future<int?>
    );
  }
}
