import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('Loader Utility', () {
    testWidgets('Loader.basic renders CircularProgressIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Loader.basic(color: Colors.red)),
        ),
      );

      final indicatorFinder = find.byType(CircularProgressIndicator);
      expect(indicatorFinder, findsOneWidget);

      final CircularProgressIndicator indicator = tester.widget(
        indicatorFinder,
      );
      expect(indicator.valueColor, isA<AlwaysStoppedAnimation<Color>>());
      expect(
        (indicator.valueColor as AlwaysStoppedAnimation<Color>).value,
        Colors.red,
      );
    });

    testWidgets('Loader.fitted renders inside FittedBox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Loader.fitted(padding: const EdgeInsets.all(8))),
        ),
      );

      expect(find.byType(FittedBox), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Loader.centered renders inside Container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Loader.centered(alignment: Alignment.bottomRight),
          ),
        ),
      );

      final containerFinder = find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsWidgets);
      final Container container = tester.firstWidget(containerFinder);
      expect(container.alignment, Alignment.bottomRight);
    });
  });

  group('RistoLoadingOverlay (Local)', () {
    const Key childKey = Key('child_content');

    testWidgets('shows barrier and loader when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingPanel(
              isLoading: true,
              child: const Text('Background Content', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('hides barrier and loader when isLoading is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingPanel(
              isLoading: false,
              child: const Text('Background Content', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.byType(BackdropFilter), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays message and progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingPanel(
              isLoading: true,
              message: 'Uploading...',
              progress: 0.75,
              loaderStyle: RistoLoaderStyle.adaptive,
            ),
          ),
        ),
      );

      expect(find.text('Uploading...'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);

      final LinearProgressIndicator progressIndicator = tester.widget(
        find.byType(LinearProgressIndicator),
      );
      expect(progressIndicator.value, 0.75);
    });

    testWidgets('factory constructors build correctly', (tester) async {
      // We are just verifying that the factory configurations don't throw errors
      // and successfully insert the BackdropFilter and Loader into the tree.

      // .dark
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoadingPanel.dark(isLoading: true)),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);

      // .glass
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoadingPanel.glass(isLoading: true)),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);

      // .clear
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoadingPanel.clear(isLoading: true)),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });

  group('RistoLoadingOverlay (Global Static Methods)', () {
    final GlobalKey hostKey = GlobalKey();

    Widget wrap() {
      return MaterialApp(
        home: Scaffold(body: Container(key: hostKey)),
      );
    }

    BuildContext getCtx(WidgetTester tester) =>
        tester.element(find.byKey(hostKey));

    testWidgets('show and hide global overlay', (tester) async {
      await tester.pumpWidget(wrap());

      // Ensure it's not showing initially
      expect(find.byType(LoadingPanel), findsNothing);

      // Show the global overlay
      LoadingPanel.show(
        getCtx(tester),
        message: 'Global Loading',
        loaderStyle:
            RistoLoaderStyle.pulsingDots, // Testing the custom dots here
      );

      await tester.pump(); // Start transition
      await tester.pump(
        const Duration(milliseconds: 300),
      ); // Advance past transition animation

      // Verify the overlay is present
      expect(find.byType(LoadingPanel), findsOneWidget);
      expect(find.text('Global Loading'), findsOneWidget);

      // _PulsingDots uses 3 containers for the dots
      final dotFinder = find.descendant(
        of: find.byType(LoadingPanel),
        matching: find.byType(ScaleTransition),
      );
      expect(dotFinder, findsWidgets);

      // Hide the global overlay
      LoadingPanel.hide(getCtx(tester));

      await tester.pump(); // Start hide transition
      await tester
          .pumpAndSettle(); // Safe to pumpAndSettle now since the repeating animation is removed

      // Verify it's gone
      expect(find.byType(LoadingPanel), findsNothing);
    });
  });
}
