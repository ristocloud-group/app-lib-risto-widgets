import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  const Size testSurface = Size(400, 800); // deterministic geometry

  testWidgets(
    'Default: expands on tap, no drag dismiss, closes via default header',
    (WidgetTester tester) async {
      tester.view.physicalSize = testSurface;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableAnimatedCard(
              collapsedBuilder: (context) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: const Text('Tap to expand'),
              ),
              expandedBuilder: (context) => Container(
                key: const ValueKey('default-expanded'),
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: const Text('Expanded content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tap to expand'), findsOneWidget);
      expect(find.byKey(const ValueKey('default-expanded')), findsNothing);

      await tester.tap(find.text('Tap to expand'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('default-expanded')), findsOneWidget);

      // Drag should NOT dismiss for default ctor
      await tester.drag(
          find.byKey(const ValueKey('default-expanded')), const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('default-expanded')), findsOneWidget);

      // Close via default header button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('default-expanded')), findsNothing);
    },
  );

  testWidgets(
    'Default + custom header: expands on tap, closes by custom header tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = testSurface;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableAnimatedCard(
              collapsedBuilder: (context) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: const Text('Tap to expand'),
              ),
              expandedBuilder: (context) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[300],
                child: const Text('Expanded content goes here'),
              ),
              headerBuilder: (context, close) => GestureDetector(
                onTap: close,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue,
                  child: const Text('Custom Header',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tap to expand'), findsOneWidget);
      expect(find.text('Custom Header'), findsNothing);
      expect(find.text('Expanded content goes here'), findsNothing);

      await tester.tap(find.text('Tap to expand'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Header'), findsOneWidget);
      expect(find.text('Expanded content goes here'), findsOneWidget);

      await tester.tap(find.text('Custom Header'));
      await tester.pumpAndSettle();

      expect(find.text('Expanded content goes here'), findsNothing);
    },
  );

  testWidgets(
    'Sheet: no header, clamped height, drag-to-dismiss using fractional threshold',
    (WidgetTester tester) async {
      tester.view.physicalSize = testSurface; // 400x800
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableAnimatedCard.sheet(
              margin: const EdgeInsets.only(
                  top: 120, left: 16, right: 16, bottom: 16),
              maxHeightFraction: 0.60,
              // clamp to 480 on 800h
              dragDismissThresholdFraction: 0.20,
              // 20% of 480 = 96
              dragToClose: true,
              collapsedBuilder: (_) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.brown[300],
                child: const Text('Tap to open sheet'),
              ),
              expandedBuilder: (_) => Container(
                key: const ValueKey('sheet-expanded'),
                padding: const EdgeInsets.all(16),
                color: Colors.brown[300],
                child: const Text('Sheet content...'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tap to open sheet'), findsOneWidget);

      await tester.tap(find.text('Tap to open sheet'));
      await tester.pumpAndSettle();

      final sheet = find.byKey(const ValueKey('sheet-expanded'));
      expect(sheet, findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing,
          reason: 'Sheet must have no header');

      // EXPECT 304, not 320: the key is on the child Container itself;
      // its own padding is internal, so its global top equals the card's top.
      final topLeft = tester.getTopLeft(sheet);
      expect(topLeft.dy, moreOrLessEquals(304, epsilon: 1.0)); // <-- fixed

      // Drag down enough to dismiss (>= 96)
      await tester.drag(sheet, const Offset(0, 300));
      await tester.pumpAndSettle();
      expect(sheet, findsNothing);
    },
  );

  testWidgets(
    'Fullscreen: no header, no drag dismiss; closes by popping Navigator',
    (WidgetTester tester) async {
      tester.view.physicalSize = testSurface;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpandableAnimatedCard.fullscreen(
              collapsedBuilder: (_) => Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFF455A64)),
                child: const Text('Tap to open fullscreen'),
              ),
              expandedBuilder: (_) => Container(
                key: const ValueKey('full-expanded'),
                color: const Color(0xFF121212),
                child: const Center(
                  child: Text('Fullscreen content',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tap to open fullscreen'), findsOneWidget);

      await tester.tap(find.text('Tap to open fullscreen'));
      await tester.pumpAndSettle();

      final full = find.byKey(const ValueKey('full-expanded'));
      expect(full, findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing,
          reason: 'Fullscreen must have no header');

      // Drag shouldn't dismiss
      await tester.drag(full, const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(full, findsOneWidget);

      // Pop the top route directly (no app bar back in fullscreen)
      final navigatorState =
          tester.state<NavigatorState>(find.byType(Navigator));
      navigatorState.pop(); // <-- fixed
      await tester.pumpAndSettle();

      expect(full, findsNothing);
    },
  );
}
