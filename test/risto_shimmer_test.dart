import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/indicators/risto_shimmer.dart';

void main() {
  group('RistoShimmer', () {
    testWidgets('renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RistoShimmer(
            child: Text('Shimmering text'),
          ),
        ),
      );

      expect(find.text('Shimmering text'), findsOneWidget);
    });

    testWidgets('RistoShimmer.block factory creates themed shape', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RistoShimmer(
              child: RistoShimmer.block(width: 100, height: 100),
            ),
          ),
        ),
      );

      // Verify a Container exists within the Shimmer
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('RistoShimmer.circle factory creates circular shape', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RistoShimmer(
              child: RistoShimmer.circle(size: 50),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });
  });
}
