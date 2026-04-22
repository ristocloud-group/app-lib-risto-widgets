import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/custom_action_button.dart';
import 'package:risto_widgets/widgets/buttons/single_press_button.dart';

void main() {
  group('SinglePressButton Tests', () {
    testWidgets('SinglePressButton respects width and height properties', (
      WidgetTester tester,
    ) async {
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

      final finder = find.byType(SinglePressButton);
      expect(finder, findsOneWidget);

      final RenderBox renderBox = tester.renderObject(
        find.byType(CustomActionButton),
      );

      expect(renderBox.size.width, equals(testWidth));
      expect(renderBox.size.height, equals(testHeight));
    });

    testWidgets('SinglePressButton invokes onPressed once on single tap', (
      WidgetTester tester,
    ) async {
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

      await tester.tap(find.byType(SinglePressButton));
      await tester.pump();

      expect(pressCount, 1);
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
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                showLoadingIndicator: true,
                child: const Text('Press Me'),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(SinglePressButton));
        await tester.tap(find.byType(SinglePressButton));
        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(pressCount, 1);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(pressCount, 2);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      },
    );

    testWidgets('SinglePressButton shows loading indicator when processing', (
      WidgetTester tester,
    ) async {
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

      expect(find.text('Press Me'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(SinglePressButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Press Me'), findsOneWidget);
    });

    testWidgets(
      'SinglePressButton is actively loading while processing and resolved afterward',
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

        final CustomActionButton button = tester.widget<CustomActionButton>(
          find.byType(CustomActionButton),
        );
        expect(button.isLoading, false);

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        final CustomActionButton buttonDuring = tester
            .widget<CustomActionButton>(find.byType(CustomActionButton));
        expect(
          buttonDuring.isLoading,
          true,
        ); // Relies on Native CustomActionButton loading state

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        final CustomActionButton buttonAfter = tester
            .widget<CustomActionButton>(find.byType(CustomActionButton));
        expect(buttonAfter.isLoading, false);
      },
    );

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

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Press Me'), findsOneWidget);

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(pressCount, 2);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      },
    );

    testWidgets('SinglePressButton applies margin correctly', (
      WidgetTester tester,
    ) async {
      EdgeInsetsGeometry testMargin = const EdgeInsets.symmetric(
        horizontal: 20.0,
      );

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

      final containerFinder = find.descendant(
        of: find.byType(SinglePressButton),
        matching: find.byType(Container).first,
      );

      expect(containerFinder, findsOneWidget);

      final Container containerWidget = tester.widget<Container>(
        containerFinder,
      );

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

        expect(startProcessingCalled, isFalse);
        expect(finishProcessingCalled, isFalse);

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(startProcessingCalled, isTrue);
        expect(finishProcessingCalled, isFalse);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(finishProcessingCalled, isTrue);
      },
    );

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

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 500));

        expect(onErrorCalled, isTrue);
        expect(caughtError, isA<Exception>());
        expect(
          (caughtError as Exception).toString(),
          contains('Test Exception'),
        );

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Press Me'), findsOneWidget);

        await tester.tap(find.byType(SinglePressButton));
        await tester.pump();

        expect(pressCount, 2);

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      },
    );
  });
}
