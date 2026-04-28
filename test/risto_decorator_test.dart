import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/layouts/risto_decorator.dart';

void main() {
  group('RistoDecorator', () {
    testWidgets('renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RistoDecorator(
            child: Text('Child content'),
          ),
        ),
      );

      expect(find.text('Child content'), findsOneWidget);
    });

    testWidgets('applies backgroundColor correctly', (WidgetTester tester) async {
      const bgColor = Colors.blue;
      await tester.pumpWidget(
        const MaterialApp(
          home: RistoDecorator(
            backgroundColor: bgColor,
            child: SizedBox.shrink(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, bgColor);
    });

    testWidgets('applies borderRadius correctly', (WidgetTester tester) async {
      final radius = BorderRadius.circular(10);
      await tester.pumpWidget(
        MaterialApp(
          home: RistoDecorator(
            borderRadius: radius,
            child: const SizedBox.shrink(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, radius);
    });

    testWidgets('handles transparent shadowColor correctly (no shadow)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RistoDecorator(
            elevation: 4.0,
            shadowColor: Colors.transparent,
            child: SizedBox.shrink(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('applies shadow when elevation > 0 and shadowColor is not transparent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RistoDecorator(
            elevation: 4.0,
            shadowColor: Colors.black,
            child: SizedBox.shrink(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });
  });
}
