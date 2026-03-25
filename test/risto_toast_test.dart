import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/feedback/risto_toast.dart';

final _hostKey = GlobalKey();

Widget _wrap() {
  return MaterialApp(
    home: Scaffold(
      body: Container(key: _hostKey), // unique element to grab a BuildContext
    ),
  );
}

BuildContext _ctx(WidgetTester tester) => tester.element(find.byKey(_hostKey));

void main() {
  testWidgets('RistoToast.show renders and auto-hides with animations', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());

    RistoToast.show(
      _ctx(tester),
      message: 'Hello!',
      // Give it a duration long enough to outlast the 250ms entry animation
      duration: const Duration(seconds: 2),
    );

    await tester.pump(); // insert overlay
    await tester.pumpAndSettle(); // wait for entry animation to complete

    // It should now safely find the widget
    expect(find.text('Hello!'), findsOneWidget);

    // Fast-forward time past the 2-second duration to trigger the dismiss timer
    await tester.pump(const Duration(seconds: 2));

    // Wait for the exit animation to complete
    await tester.pumpAndSettle();

    expect(find.text('Hello!'), findsNothing);
  });

  testWidgets('RistoToast is dismissible on tap', (tester) async {
    await tester.pumpWidget(_wrap());

    RistoToast.show(
      _ctx(tester),
      message: 'Tap me!',
      // Long duration so it doesn't auto-hide during the test
      duration: const Duration(seconds: 10),
    );

    await tester.pump();
    await tester.pumpAndSettle(); // wait for entry animation

    expect(find.text('Tap me!'), findsOneWidget);

    // Tap the toast to dismiss it early
    await tester.tap(find.text('Tap me!'));

    // Wait for the exit animation triggered by the tap
    await tester.pumpAndSettle();

    expect(find.text('Tap me!'), findsNothing);
  });

  testWidgets('RistoToast.error uses theme error color by default', (
    tester,
  ) async {
    const kErr = Color(0xFFAA0011);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
      ).copyWith(error: kErr, onError: Colors.white),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: Container(key: _hostKey)),
      ),
    );

    RistoToast.error(
      _ctx(tester),
      message: 'Boom',
      duration: const Duration(seconds: 5), // Keep open for inspection
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Find the Container that wraps the text 'Boom'
    final containerFinder = find.ancestor(
      of: find.text('Boom'),
      matching: find.byType(Container),
    );
    expect(containerFinder, findsWidgets);

    // Pick the first ancestor Container and verify its color
    final container = tester.firstWidget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, kErr);

    // Cleanup to prevent pending timers from failing the test suite
    RistoToast.hide();
    await tester.pumpAndSettle();
  });

  testWidgets('RistoToast.top aligns at top', (tester) async {
    await tester.pumpWidget(_wrap());

    RistoToast.info(
      _ctx(tester),
      message: 'Top!',
      top: true,
      duration: const Duration(seconds: 5),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    final aligns = find.byWidgetPredicate(
      (w) => w is Align && w.alignment == Alignment.topCenter,
    );
    expect(aligns, findsOneWidget);

    // Cleanup to prevent pending timers
    RistoToast.hide();
    await tester.pumpAndSettle();
  });

  testWidgets('RistoToast instantly overrides previous toast', (tester) async {
    await tester.pumpWidget(_wrap());

    // Show first toast
    RistoToast.show(
      _ctx(tester),
      message: 'First',
      duration: const Duration(seconds: 5),
    );

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('First'), findsOneWidget);

    // Show second toast immediately
    RistoToast.show(
      _ctx(tester),
      message: 'Second',
      duration: const Duration(seconds: 5),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // The old one should be gone entirely, replaced by the new one
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);

    // Cleanup
    RistoToast.hide();
    await tester.pumpAndSettle();
  });
}
