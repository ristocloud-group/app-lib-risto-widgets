import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    // Note: No specific key needed for the 'copied header' Material in overlay,
    // as we'll find it by its text content within the Overlay.

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
                color: Colors.grey[200],
                child: const Text('Expanded content goes here'),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );

      // Verify the ListTile button is present.
      expect(find.byKey(listTileHeaderKey), findsOneWidget);
      expect(find.text('Expandable ListTile Button'), findsOneWidget);

      // Initially, the expanded content widget should NOT be in the tree (due to conditional rendering).
      expect(find.byKey(listTileExpandedContentKey),
          findsNothing); // Now `findsNothing` is correct
      expect(find.text('Expanded content goes here'),
          findsNothing); // Text is not present

      // Tap the button to expand.
      await tester.tap(find.byKey(listTileHeaderKey));
      await tester.pumpAndSettle(); // Wait for the animation to complete.

      // Verify that the expanded content is now visible.
      expect(find.byKey(listTileExpandedContentKey), findsOneWidget);
      expect(find.text('Expanded content goes here'), findsOneWidget);

      // Tap the button again to collapse.
      await tester.tap(find.byKey(listTileHeaderKey));
      await tester.pumpAndSettle(); // Wait for the animation to complete.

      // Verify that the expanded content is now removed (due to conditional rendering).
      expect(find.byKey(listTileExpandedContentKey),
          findsNothing); // Now `findsNothing` is correct
      expect(find.text('Expanded content goes here'),
          findsNothing); // Text is gone
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
                color: Colors.grey[200],
                child: const Text('Expanded content goes here'),
              ),
              customHeaderBuilder: (tapAction, isExpanded, isDisabled) =>
                  GestureDetector(
                onTap: tapAction, // Directly use tapAction
                child: Container(
                  key: customHeaderKey,
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
      expect(find.byKey(customHeaderKey), findsOneWidget);
      expect(find.text('Custom Header'), findsOneWidget);

      // Initially, the expanded content widget should NOT be in the tree (due to conditional rendering).
      expect(find.byKey(customExpandedContentKey),
          findsNothing); // Now `findsNothing` is correct
      expect(find.text('Expanded content goes here'),
          findsNothing); // Text is not present

      // Tap the custom header to expand.
      await tester.tap(find.byKey(customHeaderKey));
      await tester.pumpAndSettle(); // Wait for the animation to complete.

      // Verify that the expanded content is now visible.
      expect(find.byKey(customExpandedContentKey), findsOneWidget);
      expect(find.text('Expanded content goes here'), findsOneWidget);
      expect(tester.getSize(find.byKey(customExpandedContentKey)).height,
          greaterThan(0.0));

      // Tap the custom header again to collapse.
      await tester.tap(find.byKey(customHeaderKey));
      await tester.pumpAndSettle(); // Wait for the animation to complete.

      // Verify that the expanded content is now removed (due to conditional rendering).
      expect(find.byKey(customExpandedContentKey),
          findsNothing); // Now `findsNothing` is correct
      expect(find.text('Expanded content goes here'),
          findsNothing); // Text is gone
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
                expanded: Container(
                  key: overlayExpandedContentKey,
                  padding: const EdgeInsets.all(16.0),
                  height: 100,
                  color: Colors.yellow[100],
                  child: const Text('Overlay expanded content'),
                ),
                margin: const EdgeInsets.all(8),
                elevation: 4,
                headerBackgroundColor: Colors.purple[300],
                expandedBodyColor: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );

      // --- Initial State Verification ---
      // The `CompositedTransformTarget` (the structural part of the header) should be present.
      // Verify the ListTile button is present.
      expect(find.byKey(overlayHeaderKey), findsOneWidget);
      expect(find.text('Overlay Header'), findsOneWidget);

      // Initially, the expanded content widget should NOT be in the tree (due to conditional rendering).
      expect(find.byKey(overlayExpandedContentKey),
          findsNothing); // Now `findsNothing` is correct
      expect(find.text('Overlay expanded content'),
          findsNothing); // Text is not present

      // --- Expansion Test ---
      // Tap the header to expand.
      await tester.tap(find.byKey(overlayHeaderKey));
      await tester.pump(); // Start animation, insert overlay
      await tester.pumpAndSettle(); // Wait for animation and overlay to settle

      // Verify the expanded content IS visible, and specifically in the Overlay.
      expect(find.byKey(overlayExpandedContentKey), findsOneWidget);
      expect(find.text('Overlay expanded content'), findsOneWidget);
      expect(tester.getSize(find.byKey(overlayExpandedContentKey)).height,
          greaterThan(0.0));

      // --- Collapse Test ---
      // Tap the header again to collapse.
      await tester.tap(find.byKey(overlayHeaderKey));
      await tester.pump(); // Start collapse animation
      await tester.pumpAndSettle(); // Wait for animation and overlay removal

      // Verify that the expanded content is no longer visible (removed from overlay).
      expect(find.byKey(overlayExpandedContentKey), findsNothing);
      expect(find.text('Overlay expanded content'), findsNothing);
    });

    testWidgets(
        'ExpandableListTileButton.overlayMenu stays linked to header on scroll',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 500, color: Colors.blue[50]), // Spacer
                  ExpandableListTileButton.overlayMenu(
                    title: const Text('Scrollable Overlay Header',
                        key: scrollableOverlayHeaderKey),
                    expanded: Container(
                      key: scrollableOverlayExpandedContentKey,
                      padding: const EdgeInsets.all(16.0),
                      height: 100,
                      color: Colors.yellow[100],
                      child: const Text('Overlay expanded content'),
                    ),
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    headerBackgroundColor: Colors.purple[300],
                    expandedBodyColor: Colors.purple[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  Container(height: 500, color: Colors.green[50]), // Spacer
                ],
              ),
            ),
          ),
        ),
      );

      // Tap the header to expand.
      await tester.tap(find.byKey(scrollableOverlayHeaderKey));
      await tester.pumpAndSettle();

      // Get RenderBox for the original header (the CompositedTransformTarget)
      final RenderBox headerRenderBox =
          tester.renderObject(find.byKey(scrollableOverlayHeaderKey));
      final Offset initialHeaderPos =
          headerRenderBox.localToGlobal(Offset.zero);

      // Get RenderBox for the expanded content in the overlay
      final RenderBox overlayContentRenderBox =
          tester.renderObject(find.byKey(scrollableOverlayExpandedContentKey));
      final Offset initialOverlayContentPos =
          overlayContentRenderBox.localToGlobal(Offset.zero);

      // We no longer check the absolute initial Y position of the overlay content against a calculated value.
      // Instead, we capture the relative offset immediately after expansion.
      final Offset initialRelativeOffset =
          initialOverlayContentPos - initialHeaderPos;

      // Scroll the list up by a certain amount (e.g., 200 pixels)
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Get new RenderBox for the original header (the CompositedTransformTarget)
      final RenderBox newHeaderRenderBox =
          tester.renderObject(find.byKey(scrollableOverlayHeaderKey));
      final Offset newHeaderPos = newHeaderRenderBox.localToGlobal(Offset.zero);

      // Get new RenderBox for the expanded content in the overlay
      final RenderBox newOverlayContentRenderBox =
          tester.renderObject(find.byKey(scrollableOverlayExpandedContentKey));
      final Offset newOverlayPos =
          newOverlayContentRenderBox.localToGlobal(Offset.zero);

      // Verify that the overlay has moved with the header.
      // The relative offset between header top and overlay content top should remain constant.
      final Offset currentRelativeOffset = newOverlayPos - newHeaderPos;

      expect(currentRelativeOffset.dx, closeTo(initialRelativeOffset.dx, 0.1));
      expect(currentRelativeOffset.dy, closeTo(initialRelativeOffset.dy, 0.1));
    });
  });
}
