import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Replace with the correct path to your widget file.
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('ExpandableListTileButton', () {
    // Define unique keys for testing
    const Key listTileHeaderKey = Key('listTileHeader');
    const Key listTileExpandedContentKey = Key('listTileExpandedContent');
    const Key customHeaderKey = Key('customHeader');
    const Key customExpandedContentKey = Key('customExpandedContent');
    const Key overlayHeaderKey = Key('overlayHeader');
    const Key overlayExpandedContentKey = Key('overlayExpandedContent');
    const Key scrollableOverlayHeaderKey = Key('scrollableOverlayHeader');
    const Key scrollableOverlayExpandedContentKey =
        Key('scrollableOverlayExpandedContent');

    testWidgets(
        'ExpandableListTileButton.listTile expands and collapses correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableListTileButton.listTile(
              title: const Text('Expandable ListTile Button',
                  key: listTileHeaderKey),
              expanded: Container(
                key: listTileExpandedContentKey,
                padding: const EdgeInsets.all(16.0),
                child: const Text('Expanded content goes here'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(listTileHeaderKey), findsOneWidget);
      expect(find.byKey(listTileExpandedContentKey), findsNothing);
      await tester.tap(find.byKey(listTileHeaderKey));
      await tester.pumpAndSettle();
      expect(find.byKey(listTileExpandedContentKey), findsOneWidget);
      await tester.tap(find.byKey(listTileHeaderKey));
      await tester.pumpAndSettle();
      expect(find.byKey(listTileExpandedContentKey), findsNothing);
    });

    testWidgets(
        'ExpandableListTileButton.custom expands and collapses correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableListTileButton.custom(
              expanded: Container(
                key: customExpandedContentKey,
                padding: const EdgeInsets.all(16.0),
                child: const Text('Expanded content goes here'),
              ),
              customHeaderBuilder: (tapAction, isExpanded, isDisabled) =>
                  GestureDetector(
                onTap: tapAction,
                child: Container(
                  key: customHeaderKey,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('Custom Header'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(customHeaderKey), findsOneWidget);
      expect(find.byKey(customExpandedContentKey), findsNothing);
      await tester.tap(find.byKey(customHeaderKey));
      await tester.pumpAndSettle();
      expect(find.byKey(customExpandedContentKey), findsOneWidget);
      await tester.tap(find.byKey(customHeaderKey));
      await tester.pumpAndSettle();
      expect(find.byKey(customExpandedContentKey), findsNothing);
    });

    testWidgets(
        'ExpandableListTileButton.overlayMenu expands and collapses in overlay',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExpandableListTileButton.overlayMenu(
                title: const Text('Overlay Header', key: overlayHeaderKey),
                expanded: SizedBox(
                  key: overlayExpandedContentKey,
                  height: 100,
                  child: const Text('Overlay expanded content'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(overlayHeaderKey), findsOneWidget);
      expect(find.byKey(overlayExpandedContentKey), findsNothing);

      await tester.tap(find.byKey(overlayHeaderKey));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 1)); // Finish animation
      expect(find.byKey(overlayExpandedContentKey), findsOneWidget);

      await tester.tap(find.byKey(overlayHeaderKey));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(seconds: 1)); // Finish animation
      expect(find.byKey(overlayExpandedContentKey), findsNothing);
    });

    testWidgets(
        'ExpandableListTileButton.overlayMenu closes automatically on scroll',
        (WidgetTester tester) async {
      // Arrange: Set up the widget inside a scrollable view.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 500), // Spacer to allow scrolling
                  ExpandableListTileButton.overlayMenu(
                    title: const Text('Scrollable Overlay Header',
                        key: scrollableOverlayHeaderKey),
                    expanded: SizedBox(
                      key: scrollableOverlayExpandedContentKey,
                      height: 100,
                      child: const Text('Overlay expanded content'),
                    ),
                  ),
                  const SizedBox(height: 500), // Spacer to allow scrolling
                ],
              ),
            ),
          ),
        ),
      );

      // Act 1: Tap the header to expand the overlay.
      await tester.tap(find.byKey(scrollableOverlayHeaderKey));
      await tester.pump(); // Start the expansion animation.
      await tester
          .pump(const Duration(seconds: 1)); // Let the animation finish.

      // Assert 1: Verify the overlay is visible.
      expect(find.byKey(scrollableOverlayExpandedContentKey), findsOneWidget,
          reason: 'Overlay should be visible after tapping.');

      // Act 2: Scroll the list using dragFrom to avoid hit-test warnings.
      final safeDragStartPoint = const Offset(100, 100);
      await tester.dragFrom(safeDragStartPoint, const Offset(0, -50));
      await tester.pump(); // Start the collapse animation.
      await tester
          .pump(const Duration(seconds: 1)); // Let the animation finish.

      // Assert 2: Verify the overlay has been removed.
      expect(find.byKey(scrollableOverlayExpandedContentKey), findsNothing,
          reason: 'Overlay should automatically close upon scrolling.');
    });
  });
}
