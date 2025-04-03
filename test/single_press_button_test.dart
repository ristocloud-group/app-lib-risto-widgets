// test/single_press_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/custom_action_button.dart';
import 'package:risto_widgets/widgets/buttons/single_press_button.dart';

void main() {
  group('SinglePressButton Tests', () {
    testWidgets('SinglePressButton respects width and height properties',
        (WidgetTester tester) async {
      const double testWidth = 200.0;
      const double testHeight = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {},
              width: testWidth,
              height: testHeight,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Find the SinglePressButton widget.
      final finder = find.byType(SinglePressButton);
      expect(finder, findsOneWidget);

      // Get the RenderBox of the SinglePressButton.
      final RenderBox renderBox =
          tester.renderObject(find.byType(CustomActionButton));

      // Verify the size matches the specified width and height.
      expect(renderBox.size.width, equals(testWidth));
      expect(renderBox.size.height, equals(testHeight));
    });
    testWidgets('SinglePressButton invokes onPressed once on single tap',
        (WidgetTester tester) async {
      int pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async => pressCount += 1,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Tap the button once.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      expect(pressCount, 1);

      // Allow any pending timers to complete.
      await tester.pumpAndSettle();
    });

    testWidgets(
        'SinglePressButton does not invoke onPressed multiple times on rapid taps',
        (WidgetTester tester) async {
      int pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                pressCount += 1;
                // Simulate a delay to keep the button in processing state.
                await Future.delayed(const Duration(milliseconds: 500));
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Tap the button rapidly multiple times.
      await tester.tap(find.byType(SinglePressButton));
      await tester.tap(find.byType(SinglePressButton));
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // Only the first tap should have been registered.
      expect(pressCount, 1);

      // Allow the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // After processing, the button should be tappable again.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      expect(pressCount, 2);

      // Allow the second async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    });

    testWidgets('SinglePressButton shows loading indicator when processing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 500));
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Initially, the button should display its child.
      expect(find.text('Press Me'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap the button to start processing.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // The loading indicator should now be visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // The original child should still be present underneath.
      expect(find.text('Press Me'), findsOneWidget);

      // Wait for the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // The loading indicator should be removed.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Press Me'), findsOneWidget);
    });

    testWidgets(
        'SinglePressButton is disabled while processing and enabled afterward',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 500));
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Ensure the button is enabled initially.
      final CustomActionButton button =
          tester.widget<CustomActionButton>(find.byType(CustomActionButton));
      expect(button.onPressed != null, true);

      // Tap the button to start processing.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // The button should now be disabled.
      final CustomActionButton buttonDuring =
          tester.widget<CustomActionButton>(find.byType(CustomActionButton));
      expect(buttonDuring.onPressed, null);

      // Wait for the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // The button should be enabled again.
      final CustomActionButton buttonAfter =
          tester.widget<CustomActionButton>(find.byType(CustomActionButton));
      expect(buttonAfter.onPressed != null, true);
    });

    testWidgets(
        'SinglePressButton handles exceptions in onPressed without getting stuck',
        (WidgetTester tester) async {
      int pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                pressCount += 1;
                await Future.delayed(const Duration(milliseconds: 500));
                throw Exception('Test Exception');
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
              onError: (_) {},
            ),
          ),
        ),
      );

      // Tap the button to trigger the exception.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // The loading indicator should be visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // The button should revert to its normal state despite the exception.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Press Me'), findsOneWidget);

      // The button should be tappable again.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      expect(pressCount, 2);

      // Allow the second async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    });

    testWidgets('SinglePressButton applies margin correctly',
        (WidgetTester tester) async {
      EdgeInsetsGeometry testMargin =
          const EdgeInsets.symmetric(horizontal: 20.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {},
              margin: testMargin,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      // Find the Container wrapping the CustomActionButton.
      final containerFinder = find.descendant(
        of: find.byType(SinglePressButton),
        matching: find.byType(Container).first,
      );

      expect(containerFinder, findsOneWidget);

      final Container containerWidget =
          tester.widget<Container>(containerFinder);

      // Verify the margin is applied correctly.
      expect(containerWidget.margin, testMargin);
    });

    testWidgets(
        'SinglePressButton invokes onStartProcessing and onFinishProcessing callbacks',
        (WidgetTester tester) async {
      bool startProcessingCalled = false;
      bool finishProcessingCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 500));
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
              onStartProcessing: () {
                startProcessingCalled = true;
              },
              onFinishProcessing: () {
                finishProcessingCalled = true;
              },
            ),
          ),
        ),
      );

      // Initially, callbacks should not have been called.
      expect(startProcessingCalled, isFalse);
      expect(finishProcessingCalled, isFalse);

      // Tap the button to start processing.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // onStartProcessing should be called.
      expect(startProcessingCalled, isTrue);
      expect(finishProcessingCalled, isFalse);

      // Allow the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // onFinishProcessing should be called.
      expect(finishProcessingCalled, isTrue);
    });

    testWidgets(
        'SinglePressButton invokes onError callback when an exception occurs',
        (WidgetTester tester) async {
      int pressCount = 0;
      bool onErrorCalled = false;
      Object? caughtError;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SinglePressButton(
              onPressed: () async {
                pressCount += 1;
                await Future.delayed(const Duration(milliseconds: 500));
                throw Exception('Test Exception');
              },
              showLoadingIndicator: true,
              child: const Text('Press Me'),
              onError: (error) {
                onErrorCalled = true;
                caughtError = error;
              },
            ),
          ),
        ),
      );

      // Tap the button to trigger the exception.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      // The loading indicator should be visible.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500)); // Start the frame

      // The onError callback should have been called.
      // Since we cannot directly test debugPrint, we check the flags.
      expect(onErrorCalled, isTrue);
      expect(caughtError, isA<Exception>());
      expect((caughtError as Exception).toString(), contains('Test Exception'));

      // Wait for the async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // The button should revert to its normal state despite the exception.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Press Me'), findsOneWidget);

      // The button should be tappable again.
      await tester.tap(find.byType(SinglePressButton));
      await tester.pump(); // Start the frame

      expect(pressCount, 2);

      // Allow the second async operation to complete.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    });
  });
}
