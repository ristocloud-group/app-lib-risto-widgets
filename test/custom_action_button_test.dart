// test/custom_action_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// Returns the outer shell Material used by CustomActionButton to paint
/// gradients/solid color and elevation. We find the unique Ink inside the
/// button, then take its nearest Material ancestor.
Material _shellMaterialOf(WidgetTester tester) {
  final cabFinder = find.byType(CustomActionButton);

  // There should be exactly one Ink painted by the shell.
  final inkFinder = find.descendant(of: cabFinder, matching: find.byType(Ink));
  expect(inkFinder, findsOneWidget);

  // The nearest Material ancestor of that Ink is the shell Material.
  final materialFinder =
      find.ancestor(of: inkFinder, matching: find.byType(Material)).first;

  return tester.widget<Material>(materialFinder);
}

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
      await tester.pump();

      expect(counter, 1);
    });

    testWidgets(
        'CustomActionButton.flat renders correctly as TextButton and no elevation',
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
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);

      final shell = _shellMaterialOf(tester);
      expect(shell.elevation, 0.0);
    });

    testWidgets(
        'CustomActionButton.elevated renders with correct Material elevation',
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

      expect(find.text('Elevated Button'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CustomActionButton),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );

      final shell = _shellMaterialOf(tester);
      expect(shell.elevation, 5.0);
    });

    testWidgets(
        'CustomActionButton.minimal renders correctly (no overlay/splash, zero elevation)',
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

      final textButtonFinder = find.byType(TextButton);
      expect(textButtonFinder, findsOneWidget);

      final textButton = tester.widget<TextButton>(textButtonFinder);
      final overlayColor = textButton.style?.overlayColor?.resolve({});
      expect(overlayColor, Colors.transparent);
      expect(textButton.style?.splashFactory, NoSplash.splashFactory);

      final shell = _shellMaterialOf(tester);
      expect(shell.elevation, 0.0);
    });

    testWidgets(
        'CustomActionButton.longPress triggers onLongPress repeatedly while holding',
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

      final center = tester.getCenter(find.byType(CustomActionButton));
      final gesture = await tester.startGesture(center);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 300));
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
              onPressed: null,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      expect(find.text('Disabled Button'), findsOneWidget);

      final customActionButtonFinder = find.byType(CustomActionButton);
      expect(customActionButtonFinder, findsOneWidget);

      final absorbPointerFinder = find.descendant(
        of: customActionButtonFinder,
        matching: find.byType(AbsorbPointer),
      );
      expect(absorbPointerFinder, findsOneWidget);

      final absorbPointer = tester.widget<AbsorbPointer>(absorbPointerFinder);
      expect(absorbPointer.absorbing, true);

      await tester.tap(customActionButtonFinder, warnIfMissed: false);
      await tester.pump();
      expect(counter, 0);
    });

    testWidgets('CustomActionButton.icon respects size and iconColor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomActionButton.icon(
                onPressed: () {},
                icon: Icons.add,
                size: 48,
                baseType: ButtonType.rounded,
                backgroundColor: Colors.blue,
                iconColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.add));
      expect(icon.color, Colors.white);
      expect(icon.size, 20.0); // adjust if you changed the factory default

      final buttonSize = tester.getSize(find.byType(CustomActionButton));
      expect(buttonSize.width, 48);
      expect(buttonSize.height, 48);

      expect(find.byType(ElevatedButton), findsOneWidget);

      final shell = _shellMaterialOf(tester);
      expect(shell.elevation, isA<double>());
    });
  });
}
