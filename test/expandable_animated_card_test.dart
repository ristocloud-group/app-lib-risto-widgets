import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  testWidgets(
      'ExpandableAnimatedCard expands and collapses, removing expanded content on collapse',
      (WidgetTester tester) async {
    // Build the widget inside a MaterialApp/Scaffold
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpandableAnimatedCard(
            collapsedBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: const Text('Tap to expand'),
              );
            },
            expandedBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: const Text('Expanded content goes here'),
              );
            },
            // When onClose is called, pop the overlay.
            onClose: () {
              Navigator.of(tester.element(find.byType(Scaffold))).pop();
            },
          ),
        ),
      ),
    );

    // Verify the collapsed view is visible.
    expect(find.text('Tap to expand'), findsOneWidget);
    expect(find.text('Expanded content goes here'), findsNothing);

    // Tap the collapsed view to expand.
    await tester.tap(find.text('Tap to expand'));
    await tester.pumpAndSettle();

    // Verify that the expanded content is now visible.
    expect(find.text('Expanded content goes here'), findsOneWidget);

    // Tap the default header back button to collapse.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that the expanded content is removed after collapse.
    expect(find.text('Expanded content goes here'), findsNothing);
  });

  testWidgets(
      'ExpandableAnimatedCard with custom header expands and collapses, removing expanded content on collapse',
      (WidgetTester tester) async {
    // Build the widget with a custom header
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpandableAnimatedCard(
            collapsedBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: const Text('Tap to expand'),
              );
            },
            expandedBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: const Text('Expanded content goes here'),
              );
            },
            // Provide a custom header builder that returns a tappable header.
            headerBuilder: (context, tapAction) {
              return GestureDetector(
                onTap: tapAction,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: const Text(
                    'Custom Header',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            onClose: () {
              Navigator.of(tester.element(find.byType(Scaffold))).pop();
            },
          ),
        ),
      ),
    );

    // Verify the collapsed view is visible and the custom header is not yet visible.
    expect(find.text('Tap to expand'), findsOneWidget);
    expect(find.text('Custom Header'), findsNothing);
    expect(find.text('Expanded content goes here'), findsNothing);

    // Tap the collapsed view to expand.
    await tester.tap(find.text('Tap to expand'));
    await tester.pumpAndSettle();

    // Verify that the custom header and expanded content are now visible.
    expect(find.text('Custom Header'), findsOneWidget);
    expect(find.text('Expanded content goes here'), findsOneWidget);

    // Tap the custom header to collapse.
    await tester.tap(find.text('Custom Header'));
    await tester.pumpAndSettle();

    // Verify that the expanded content is removed after collapse.
    expect(find.text('Expanded content goes here'), findsNothing);
  });
}
