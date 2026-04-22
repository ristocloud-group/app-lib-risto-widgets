import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/list_tile_button.dart';
import 'package:risto_widgets/widgets/layouts/risto_decorator.dart';

void main() {
  group('ListTileButton Tests', () {
    testWidgets('ListTileButton renders correctly and responds to tap', (
      WidgetTester tester,
    ) async {
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

      expect(find.text('ListTileButton'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);

      // Verify the margin is applied by checking RistoDecorator.
      final ristoDecoratorFinder = find.byType(RistoDecorator);
      expect(ristoDecoratorFinder, findsOneWidget);

      final RistoDecorator ristoDecorator = tester.widget<RistoDecorator>(
        ristoDecoratorFinder,
      );
      expect(ristoDecorator.margin, const EdgeInsets.all(16.0));

      await tester.tap(find.byType(ListTileButton));
      await tester.pump();

      expect(buttonPressed, true);
    });

    testWidgets('ListTileButton displays subtitle and trailing widgets', (
      WidgetTester tester,
    ) async {
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

      expect(find.text('ListTileButton'), findsOneWidget);
      expect(find.text('Subtitle Text'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('ListTileButton applies margin correctly', (
      WidgetTester tester,
    ) async {
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

      final ristoDecoratorFinder = find.byType(RistoDecorator);
      expect(ristoDecoratorFinder, findsOneWidget);

      final RistoDecorator ristoDecorator = tester.widget<RistoDecorator>(
        ristoDecoratorFinder,
      );
      expect(
        ristoDecorator.margin,
        const EdgeInsets.only(left: 20.0, right: 20.0),
      );
    });

    testWidgets('ListTileButton scales leading widget with leadingSizeFactor', (
      WidgetTester tester,
    ) async {
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

      final iconFinder = find.byIcon(Icons.access_alarm);
      expect(iconFinder, findsOneWidget);

      // Find the exact wrapping sizing box
      final sizedBoxFinder = find.byWidgetPredicate(
        (w) =>
            w is SizedBox &&
            w.width == 24.0 * sizeFactor &&
            w.height == 24.0 * sizeFactor,
      );
      expect(sizedBoxFinder, findsOneWidget);
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

        expect(find.text('Icon ListTileButton'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);

        final ristoDecoratorFinder = find.byType(RistoDecorator);
        expect(ristoDecoratorFinder, findsOneWidget);

        final RistoDecorator ristoDecorator = tester.widget<RistoDecorator>(
          ristoDecoratorFinder,
        );
        expect(ristoDecorator.margin, const EdgeInsets.all(10.0));

        final iconFinder = find.byIcon(Icons.star);
        expect(iconFinder, findsOneWidget);

        final sizedBoxFinder = find.byWidgetPredicate(
          (w) =>
              w is SizedBox &&
              w.width == 24.0 * sizeFactor &&
              w.height == 24.0 * sizeFactor,
        );
        expect(sizedBoxFinder, findsOneWidget);
      },
    );

    testWidgets('IconListTileButton responds to tap', (
      WidgetTester tester,
    ) async {
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

      await tester.tap(find.byType(IconListTileButton));
      await tester.pump();

      expect(buttonPressed, true);
    });

    testWidgets('IconListTileButton applies margin correctly', (
      WidgetTester tester,
    ) async {
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

      final ristoDecoratorFinder = find.byType(RistoDecorator);
      expect(ristoDecoratorFinder, findsOneWidget);

      final RistoDecorator ristoDecorator = tester.widget<RistoDecorator>(
        ristoDecoratorFinder,
      );
      expect(
        ristoDecorator.margin,
        const EdgeInsets.only(top: 10.0, bottom: 10.0),
      );
    });

    testWidgets('IconListTileButton scales leading icon correctly', (
      WidgetTester tester,
    ) async {
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

      final iconFinder = find.byIcon(Icons.thumb_up);
      expect(iconFinder, findsOneWidget);

      final sizedBoxFinder = find.byWidgetPredicate(
        (w) =>
            w is SizedBox &&
            w.width == 24.0 * sizeFactor &&
            w.height == 24.0 * sizeFactor,
      );
      expect(sizedBoxFinder, findsOneWidget);
    });
  });

  group('DoubleListTileButtons Tests', () {
    testWidgets('DoubleListTileButtons renders two ListTileButtons', (
      WidgetTester tester,
    ) async {
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

      expect(find.text('First Button'), findsOneWidget);
      expect(find.text('Second Button'), findsOneWidget);

      final doubleListTileButtonsFinder = find.byType(DoubleListTileButtons);
      expect(doubleListTileButtonsFinder, findsOneWidget);

      final DoubleListTileButtons doubleListTileButtons = tester
          .widget<DoubleListTileButtons>(doubleListTileButtonsFinder);
      expect(doubleListTileButtons.padding, const EdgeInsets.all(12.0));

      final sizedBoxFinder = find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == 16.0,
      );
      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets('DoubleListTileButtons applies padding and spacing correctly', (
      WidgetTester tester,
    ) async {
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

      final doubleListTileButtonsFinder = find.byType(DoubleListTileButtons);
      expect(doubleListTileButtonsFinder, findsOneWidget);

      final DoubleListTileButtons doubleListTileButtons = tester
          .widget<DoubleListTileButtons>(doubleListTileButtonsFinder);
      expect(
        doubleListTileButtons.padding,
        const EdgeInsets.symmetric(horizontal: 20.0),
      );

      final sizedBoxFinder = find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == 24.0,
      );
      expect(sizedBoxFinder, findsOneWidget);
    });
  });
}
