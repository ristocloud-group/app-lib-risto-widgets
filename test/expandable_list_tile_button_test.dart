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

    // New keys for scoping the overlay tests
    const Key overlayContainerKey = Key('overlayContainer');
    const Key rebuildTestContainerKey = Key('rebuildTestContainer');
    const Key scrollableContainerKey = Key('scrollableContainer');

    const Key overlayHeaderKey = Key('overlayHeader');
    const Key overlayExpandedContentKey = Key('overlayExpandedContent');
    const Key scrollableOverlayHeaderKey = Key('scrollableOverlayHeader');
    const Key scrollableOverlayExpandedContentKey = Key(
      'scrollableOverlayExpandedContent',
    );

    testWidgets(
      'ExpandableListTileButton.listTile expands and collapses correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ExpandableListTileButton.listTile(
                title: const Text(
                  'Expandable ListTile Button',
                  key: listTileHeaderKey,
                ),
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
      },
    );

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
      },
    );

    testWidgets(
      'ExpandableListTileButton.overlayMenu expands and collapses in overlay',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Container(
                  key: overlayContainerKey,
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
          ),
        );

        // Use a descendant finder to ensure we only find the header in the main tree
        final headerFinder = find.descendant(
          of: find.byKey(overlayContainerKey),
          matching: find.byKey(overlayHeaderKey),
        );

        expect(headerFinder, findsOneWidget);
        expect(find.byKey(overlayExpandedContentKey), findsNothing);

        await tester.tap(headerFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(overlayExpandedContentKey), findsOneWidget);

        await tester.tap(headerFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(overlayExpandedContentKey), findsNothing);
      },
    );

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
                    Container(
                      key: scrollableContainerKey,
                      child: ExpandableListTileButton.overlayMenu(
                        title: const Text(
                          'Scrollable Overlay Header',
                          key: scrollableOverlayHeaderKey,
                        ),
                        expanded: SizedBox(
                          key: scrollableOverlayExpandedContentKey,
                          height: 100,
                          child: const Text('Overlay expanded content'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 500), // Spacer to allow scrolling
                  ],
                ),
              ),
            ),
          ),
        );

        final headerFinder = find.descendant(
          of: find.byKey(scrollableContainerKey),
          matching: find.byKey(scrollableOverlayHeaderKey),
        );

        // Act 1: Tap the header to expand the overlay.
        await tester.tap(headerFinder);
        await tester.pumpAndSettle();

        // Assert 1: Verify the overlay is visible.
        expect(
          find.byKey(scrollableOverlayExpandedContentKey),
          findsOneWidget,
          reason: 'Overlay should be visible after tapping.',
        );

        // Act 2: Scroll the list using dragFrom to avoid hit-test warnings.
        final safeDragStartPoint = const Offset(100, 100);
        await tester.dragFrom(safeDragStartPoint, const Offset(0, -50));
        await tester.pumpAndSettle();

        // Assert 2: Verify the overlay has been removed.
        expect(
          find.byKey(scrollableOverlayExpandedContentKey),
          findsNothing,
          reason: 'Overlay should automatically close upon scrolling.',
        );
      },
    );

    testWidgets(
      'ExpandableListTileButton.overlayMenu works after parent widget rebuild',
      (WidgetTester tester) async {
        final GlobalKey<_TestParentState> parentKey = GlobalKey();

        // Arrange: Wrap the widget in a stateful parent that can be rebuilt.
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestParent(
                key: parentKey,
                child: Container(
                  key: rebuildTestContainerKey,
                  child: ExpandableListTileButton.overlayMenu(
                    title: const Text('Rebuild Test', key: overlayHeaderKey),
                    expanded: const Text(
                      'Overlay content for rebuild test',
                      key: overlayExpandedContentKey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final headerFinder = find.descendant(
          of: find.byKey(rebuildTestContainerKey),
          matching: find.byKey(overlayHeaderKey),
        );

        // 1. Expand the tile and verify the overlay is shown.
        expect(find.byKey(overlayExpandedContentKey), findsNothing);
        await tester.tap(headerFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(overlayExpandedContentKey), findsOneWidget);

        // 2. Trigger a rebuild of the parent widget.
        parentKey.currentState!.rebuild();
        await tester.pumpAndSettle();

        // Assert: Verify the overlay is still visible after the rebuild.
        expect(find.byKey(overlayExpandedContentKey), findsOneWidget);

        // 3. Collapse the tile.
        await tester.tap(headerFinder);
        await tester.pumpAndSettle();

        // Assert: Verify the overlay is now gone.
        expect(find.byKey(overlayExpandedContentKey), findsNothing);

        // 4. Re-expand the tile to check if it's still functional.
        await tester.tap(headerFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(overlayExpandedContentKey), findsOneWidget);
      },
    );
  });
}

// A simple StatefulWidget to simulate a parent widget's rebuild.
class _TestParent extends StatefulWidget {
  final Widget child;

  const _TestParent({super.key, required this.child});

  @override
  State<_TestParent> createState() => _TestParentState();
}

class _TestParentState extends State<_TestParent> {
  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
