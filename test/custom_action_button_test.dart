import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('CustomActionButton Tests', () {
    testWidgets('CustomActionButton increments counter when pressed',
        (WidgetTester tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton(
              onPressed: () {
                counter++;
              },
              backgroundColor: Colors.blue,
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      expect(find.text('Press Me'), findsOneWidget);
      expect(counter, 0);

      await tester.tap(find.byType(CustomActionButton));
      await tester.pump(); // Rebuild the widget with the new state.

      expect(counter, 1);
    });

    testWidgets('CustomActionButton.flat renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton.flat(
              onPressed: () {},
              backgroundColor: Colors.red,
              child: const Text('Flat Button'),
            ),
          ),
        ),
      );

      expect(find.text('Flat Button'), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byType(TextButton), findsNothing);

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      final elevatedButton = tester.widget<ElevatedButton>(find.descendant(
        of: find.byType(CustomActionButton),
        matching: find.byType(ElevatedButton),
      ));
      expect(elevatedButton.style?.elevation?.resolve({}), equals(null));
    });

    testWidgets('CustomActionButton.elevated renders with correct elevation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton.elevated(
              onPressed: () {},
              backgroundColor: Colors.green,
              elevation: 5.0,
              child: const Text('Elevated Button'),
            ),
          ),
        ),
      );

      // Expect the button to be present
      expect(find.text('Elevated Button'), findsOneWidget);

      // Find the ElevatedButton within the CustomActionButton
      final elevatedButtonFinder = find.descendant(
        of: find.byType(CustomActionButton),
        matching: find.byType(ElevatedButton),
      );

      // Ensure the ElevatedButton is found
      expect(elevatedButtonFinder, findsOneWidget);

      // Verify the elevation of the ElevatedButton
      final elevatedButton =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(elevatedButton.style?.elevation?.resolve({}), equals(5.0));
    });

    testWidgets('CustomActionButton.minimal renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton.minimal(
              onPressed: () {},
              child: const Text('Minimal Button'),
            ),
          ),
        ),
      );

      expect(find.text('Minimal Button'), findsOneWidget);

      // Ensure the button is a TextButton
      expect(find.byType(TextButton), findsOneWidget);

      // Ensure that the button has no overlay or splash
      final textButton = tester.widget<TextButton>(find.byType(TextButton));

      // Check that overlayColor is transparent
      final overlayColor = textButton.style?.overlayColor?.resolve({});

      expect(overlayColor, Colors.transparent);

      // Check that splashFactory is NoSplash
      expect(textButton.style?.splashFactory, NoSplash.splashFactory);
    });

    testWidgets('CustomActionButton.longPress triggers onLongPress',
        (WidgetTester tester) async {
      int longPressCounter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton.longPress(
              onPressed: () {},
              onLongPress: () {
                longPressCounter++;
              },
              child: const Text('Long Press Button'),
            ),
          ),
        ),
      );

      expect(find.text('Long Press Button'), findsOneWidget);

      // Simulate a long press
      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(CustomActionButton)));
      await tester
          .pump(const Duration(milliseconds: 600)); // Recognize long press
      await tester
          .pump(const Duration(milliseconds: 300)); // Allow timer to trigger

      // Release the gesture
      await gesture.up();

      expect(longPressCounter, greaterThan(0));
    });

    testWidgets('CustomActionButton shows disabled state correctly',
        (WidgetTester tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomActionButton.elevated(
              onPressed: null, // Disabled state
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      // Verify the disabled button is present with correct text
      expect(find.text('Disabled Button'), findsOneWidget);

      // Locate the CustomActionButton widget
      final customActionButtonFinder = find.byType(CustomActionButton);
      expect(customActionButtonFinder, findsOneWidget);

      // Find the specific AbsorbPointer inside the CustomActionButton
      final absorbPointerFinder = find.descendant(
          of: customActionButtonFinder, matching: find.byType(AbsorbPointer));
      expect(absorbPointerFinder, findsOneWidget);

      // Ensure that the AbsorbPointer is absorbing (i.e., button is disabled)
      final absorbPointerWidget =
          tester.widget<AbsorbPointer>(absorbPointerFinder);
      expect(absorbPointerWidget.absorbing, true);

      // Try to tap the button
      await tester.tap(customActionButtonFinder, warnIfMissed: false);
      await tester.pump();

      // Counter should not have incremented
      expect(counter, 0);
    });
  });
}
