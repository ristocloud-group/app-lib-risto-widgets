import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';
import 'package:risto_widgets/widgets/expandable/expandable_list_tile_button.dart';

void main() {
  testWidgets(
      'ExpandableListTileButton expands and collapses, removing body on collapse',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpandableListTileButton.listTile(
            expanded: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Text('Expanded content goes here'),
            ),
            title: const Text('Expandable ListTile Button'),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );

    // Verify the ListTile button is present.
    expect(find.text('Expandable ListTile Button'), findsOneWidget);

    // Initially, the expanded content should not be visible (collapsed state).
    expect(find.text('Expanded content goes here'), findsNothing);

    // Tap the button to expand.
    await tester.tap(find.text('Expandable ListTile Button'));
    await tester.pumpAndSettle(); // Wait for the animation to complete.

    // Verify that the expanded content is now visible.
    expect(find.text('Expanded content goes here'), findsOneWidget);

    // Tap the button again to collapse.
    await tester.tap(find.text('Expandable ListTile Button'));
    await tester.pumpAndSettle(); // Wait for the animation to complete.

    // Verify that the expanded content is now removed after the collapse.
    expect(find.text('Expanded content goes here'), findsNothing);
  });

  testWidgets(
      'ExpandableListTileButton with custom header expands and collapses, removing body on collapse',
      (WidgetTester tester) async {
    // Build the widget with a custom header
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpandableListTileButton.custom(
            expanded: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Text('Expanded content goes here'),
            ),
            customHeaderBuilder: (tapAction, isExpanded, isDisabled) =>
                GestureDetector(
              onTap: () => tapAction.call(),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: const Text('Custom Header'),
              ),
            ),
          ),
        ),
      ),
    );

    // Verify the custom header is present.
    expect(find.text('Custom Header'), findsOneWidget);

    // Initially, the expanded content should not be visible (collapsed state).
    expect(find.text('Expanded content goes here'), findsNothing);

    // Tap the custom header to expand.
    await tester.tap(find.text('Custom Header'));
    await tester.pumpAndSettle(); // Wait for the animation to complete.

    // Verify that the expanded content is now visible.
    expect(find.text('Expanded content goes here'), findsOneWidget);

    // Tap the custom header again to collapse.
    await tester.tap(find.text('Custom Header'));
    await tester.pumpAndSettle(); // Wait for the animation to complete.

    // Verify that the expanded content is now removed after the collapse.
    expect(find.text('Expanded content goes here'), findsNothing);
  });
}
