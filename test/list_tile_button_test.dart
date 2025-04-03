import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/list_tile_button.dart';

void main() {
  group('ListTileButton Tests', () {
    testWidgets('ListTileButton renders correctly and responds to tap',
        (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTileButton(
              margin: const EdgeInsets.all(16.0),
              body: const Text('ListTileButton'),
              leading: const Icon(Icons.list),
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify the ListTileButton is present.
      expect(find.text('ListTileButton'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);

      // Verify the margin is applied by checking RoundedContainer.
      final roundedContainerFinder = find.byType(RoundedContainer);
      expect(roundedContainerFinder, findsOneWidget);

      final RoundedContainer roundedContainer =
          tester.widget<RoundedContainer>(roundedContainerFinder);
      expect(roundedContainer.margin, const EdgeInsets.all(16.0));

      // Tap the ListTileButton and verify it triggers the onPressed callback.
      await tester.tap(find.byType(ListTileButton));
      await tester.pump(); // Rebuild the widget with the new state.

      expect(buttonPressed, true);
    });

    testWidgets('ListTileButton displays subtitle and trailing widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTileButton(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              body: const Text('ListTileButton'),
              subtitle: const Text('Subtitle Text'),
              trailing: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the body, subtitle, and trailing widgets are present.
      expect(find.text('ListTileButton'), findsOneWidget);
      expect(find.text('Subtitle Text'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('ListTileButton applies margin correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTileButton(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              body: const Text('Margin Test'),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the RoundedContainer and verify margin.
      final roundedContainerFinder = find.byType(RoundedContainer);
      expect(roundedContainerFinder, findsOneWidget);

      final RoundedContainer roundedContainer =
          tester.widget<RoundedContainer>(roundedContainerFinder);
      expect(roundedContainer.margin,
          const EdgeInsets.only(left: 20.0, right: 20.0));
    });

    testWidgets('ListTileButton scales leading widget with leadingSizeFactor',
        (WidgetTester tester) async {
      const double sizeFactor = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTileButton(
              margin: const EdgeInsets.all(8.0),
              body: const Text('Scaling Test'),
              leading: const Icon(Icons.access_alarm),
              leadingSizeFactor: sizeFactor,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the leading Icon.
      final iconFinder = find.byIcon(Icons.access_alarm);
      expect(iconFinder, findsOneWidget);

      // Find the wrapper Container using the Key.
      final containerFinder = find.byKey(const Key('leading_wrapper'));
      expect(containerFinder, findsOneWidget);

      // Retrieve the size of the wrapper Container.
      final Size containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 24.0 * sizeFactor);
      expect(containerSize.height, 24.0 * sizeFactor);
    });
  });

  group('IconListTileButton Tests', () {
    testWidgets(
        'IconListTileButton renders correctly with custom leadingSizeFactor',
        (WidgetTester tester) async {
      const double sizeFactor = 1.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconListTileButton(
              margin: const EdgeInsets.all(10.0),
              icon: Icons.star,
              title: const Text('Icon ListTileButton'),
              leadingSizeFactor: sizeFactor,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Verify the IconListTileButton is present.
      expect(find.text('Icon ListTileButton'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verify the margin is applied by checking RoundedContainer.
      final roundedContainerFinder = find.byType(RoundedContainer);
      expect(roundedContainerFinder, findsOneWidget);

      final RoundedContainer roundedContainer =
          tester.widget<RoundedContainer>(roundedContainerFinder);
      expect(roundedContainer.margin, const EdgeInsets.all(10.0));

      // Find the leading Icon.
      final iconFinder = find.byIcon(Icons.star);
      expect(iconFinder, findsOneWidget);

      // Find the wrapper Container using the Key.
      final containerFinder = find.byKey(const Key('leading_wrapper'));
      expect(containerFinder, findsOneWidget);

      // Retrieve the size of the wrapper Container.
      final Size containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 24.0 * sizeFactor);
      expect(containerSize.height, 24.0 * sizeFactor);
    });

    testWidgets('IconListTileButton responds to tap',
        (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconListTileButton(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              icon: Icons.star,
              title: const Text('Icon ListTileButton'),
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // Tap the IconListTileButton and verify it triggers the onPressed callback.
      await tester.tap(find.byType(IconListTileButton));
      await tester.pump(); // Rebuild the widget with the new state.

      expect(buttonPressed, true);
    });

    testWidgets('IconListTileButton applies margin correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconListTileButton(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              icon: Icons.favorite,
              title: const Text('Margin Test'),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the RoundedContainer and verify margin.
      final roundedContainerFinder = find.byType(RoundedContainer);
      expect(roundedContainerFinder, findsOneWidget);

      final RoundedContainer roundedContainer =
          tester.widget<RoundedContainer>(roundedContainerFinder);
      expect(roundedContainer.margin,
          const EdgeInsets.only(top: 10.0, bottom: 10.0));
    });

    testWidgets('IconListTileButton scales leading icon correctly',
        (WidgetTester tester) async {
      const double sizeFactor = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconListTileButton(
              margin: const EdgeInsets.all(8.0),
              icon: Icons.thumb_up,
              title: const Text('Scaling Test'),
              leadingSizeFactor: sizeFactor,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the leading Icon.
      final iconFinder = find.byIcon(Icons.thumb_up);
      expect(iconFinder, findsOneWidget);

      // Find the wrapper Container using the Key.
      final containerFinder = find.byKey(const Key('leading_wrapper'));
      expect(containerFinder, findsOneWidget);

      // Retrieve the size of the wrapper Container.
      final Size containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 24.0 * sizeFactor);
      expect(containerSize.height, 24.0 * sizeFactor);
    });
  });

  group('DoubleListTileButtons Tests', () {
    testWidgets('DoubleListTileButtons renders two ListTileButtons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoubleListTileButtons(
              padding: const EdgeInsets.all(12.0),
              space: 16.0,
              firstButton: ListTileButton(
                margin: const EdgeInsets.only(right: 8.0),
                body: const Text('First Button'),
                onPressed: () {},
              ),
              secondButton: ListTileButton(
                margin: const EdgeInsets.only(left: 8.0),
                body: const Text('Second Button'),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify both buttons are present.
      expect(find.text('First Button'), findsOneWidget);
      expect(find.text('Second Button'), findsOneWidget);

      // Verify the padding is applied to DoubleListTileButtons.
      final doubleListTileButtonsFinder = find.byType(DoubleListTileButtons);
      expect(doubleListTileButtonsFinder, findsOneWidget);

      final DoubleListTileButtons doubleListTileButtons =
          tester.widget<DoubleListTileButtons>(doubleListTileButtonsFinder);
      expect(doubleListTileButtons.padding, const EdgeInsets.all(12.0));

      // Verify the spacing between buttons.
      final sizedBoxFinder = find.descendant(
        of: doubleListTileButtonsFinder,
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBox.width, 16.0);
    });

    testWidgets('DoubleListTileButtons applies padding and spacing correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoubleListTileButtons(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              space: 24.0,
              firstButton: ListTileButton(
                margin: const EdgeInsets.only(right: 12.0),
                body: const Text('First Button'),
                onPressed: () {},
              ),
              secondButton: ListTileButton(
                margin: const EdgeInsets.only(left: 12.0),
                body: const Text('Second Button'),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify the padding is applied to DoubleListTileButtons.
      final doubleListTileButtonsFinder = find.byType(DoubleListTileButtons);
      expect(doubleListTileButtonsFinder, findsOneWidget);

      final DoubleListTileButtons doubleListTileButtons =
          tester.widget<DoubleListTileButtons>(doubleListTileButtonsFinder);
      expect(
          doubleListTileButtons.padding,
          const EdgeInsets.symmetric(
              horizontal: 20.0)); // Verify horizontal padding

      // Verify the spacing between buttons.
      final sizedBoxFinder = find.descendant(
        of: doubleListTileButtonsFinder,
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsOneWidget);
      final SizedBox sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBox.width, 24.0);
    });
  });
}
