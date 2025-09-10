import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/overlays/risto_toast.dart';

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
  testWidgets('RistoToast.show renders and auto-hides', (tester) async {
    await tester.pumpWidget(_wrap());

    RistoToast.show(
      _ctx(tester),
      message: 'Hello!',
      duration: const Duration(milliseconds: 120),
    );

    await tester.pump(); // insert overlay
    expect(find.byKey(const ValueKey('risto_toast_bubble')), findsOneWidget);
    expect(find.text('Hello!'), findsOneWidget);

    // Wait beyond duration -> it should be removed
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(const ValueKey('risto_toast_bubble')), findsNothing);
  });

  testWidgets('RistoToast.error uses theme error color by default',
      (tester) async {
    const kErr = Color(0xFFAA0011);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo).copyWith(
        error: kErr,
        onError: Colors.white,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      theme: theme,
      home: Scaffold(body: Container(key: _hostKey)),
    ));

    RistoToast.error(
      _ctx(tester),
      message: 'Boom',
      duration: const Duration(milliseconds: 50),
    );

    await tester.pump();

    // Find the Container *inside* the toast bubble
    final containerFinder = find.descendant(
      of: find.byKey(const ValueKey('risto_toast_bubble')),
      matching: find.byType(Container),
    );
    expect(containerFinder, findsWidgets); // at least one Container

    // Pick the first Container that has a BoxDecoration with a color
    final container = tester.widgetList<Container>(containerFinder).firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).color != null,
        );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, kErr);

    await tester.pump(const Duration(milliseconds: 80)); // cleanup
  });

  testWidgets('RistoToast.top aligns at top', (tester) async {
    await tester.pumpWidget(_wrap());

    RistoToast.info(
      _ctx(tester),
      message: 'Top!',
      top: true,
      duration: const Duration(milliseconds: 50),
    );

    await tester.pump();

    final aligns = find.byWidgetPredicate(
      (w) => w is Align && w.alignment == Alignment.topCenter,
    );
    expect(aligns, findsOneWidget);

    // --- cleanup to avoid pending timer ---
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  });
}
