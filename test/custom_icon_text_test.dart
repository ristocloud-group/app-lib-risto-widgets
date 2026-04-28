import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/custom_icon_text.dart';

void main() {
  group('CustomIconText', () {
    testWidgets('renders icon and text correctly', (WidgetTester tester) async {
      const icon = Icons.add;
      const text = 'Add Item';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(icon: icon, text: text),
          ),
        ),
      );

      expect(find.byIcon(icon), findsOneWidget);
      expect(find.text(text), findsOneWidget);
    });

    testWidgets('applies custom color to both icon and text', (
      WidgetTester tester,
    ) async {
      const icon = Icons.favorite;
      const text = 'Like';
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(icon: icon, text: text, color: customColor),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(icon));
      final textWidget = tester.widget<Text>(find.text(text));

      expect(iconWidget.color, customColor);
      expect(textWidget.style?.color, customColor);
    });

    testWidgets('respects spacing between icon and text', (
      WidgetTester tester,
    ) async {
      const spacing = 20.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(
              icon: Icons.star,
              text: 'Star',
              spacing: spacing,
            ),
          ),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(CustomIconText),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == spacing,
        ),
      );
      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets('aligns content based on mainAxisAlignment', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(
              icon: Icons.info,
              text: 'Info',
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.mainAxisAlignment, MainAxisAlignment.end);
    });

    testWidgets('respects invert field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(
              icon: Icons.add,
              text: 'Add',
              invert: true,
            ),
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      // Inverted: [Text, SizedBox, Icon]
      expect(flex.children[0], isA<Flexible>());
      expect(flex.children[2], isA<Icon>());
    });

    testWidgets('respects axis field (vertical)', (WidgetTester tester) async {
      const spacing = 15.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconText(
              icon: Icons.add,
              text: 'Add',
              axis: Axis.vertical,
              spacing: spacing,
            ),
          ),
        ),
      );

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);

      final sizedBoxFinder = find.descendant(
        of: find.byType(CustomIconText),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == spacing,
        ),
      );
      expect(sizedBoxFinder, findsOneWidget);
    });
  });
}
