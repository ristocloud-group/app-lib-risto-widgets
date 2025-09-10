import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('LinearPercentIndicator', () {
    testWidgets('renders correct filled width (no animation)', (tester) async {
      const width = 200.0;
      const percent = 0.4;

      await tester.pumpWidget(_wrap(
        SizedBox(
          width: width,
          child: const LinearPercentIndicator(
            percent: percent,
            lineHeight: 8,
          ),
        ),
      ));

      await tester.pump();

      final box = tester.renderObject<RenderBox>(
          find.byKey(const ValueKey('linear_percent_filled')));
      // The SizedBox width is set directly on the child.
      expect(box.size.width, closeTo(width * percent, 0.5));
    });

    testWidgets('animates from 0 to target percent', (tester) async {
      const width = 300.0;
      const percent = 0.6;
      const durationMs = 500;

      await tester.pumpWidget(_wrap(
        SizedBox(
          width: width,
          child: const LinearPercentIndicator(
            percent: percent,
            animation: true,
            animationDuration: durationMs,
          ),
        ),
      ));

      // Kick the tween off (first frame is exactly 0.0 by design)
      const firstTick = Duration(milliseconds: 16);
      await tester.pump(firstTick);

      // ---- Mid progress (accounting for the firstTick) ----
      final elapsedMid = firstTick + Duration(milliseconds: durationMs ~/ 2);
      await tester.pump(Duration(milliseconds: durationMs ~/ 2));

      final tMid = elapsedMid.inMilliseconds / durationMs;
      final curveMid = Curves.easeInOut.transform(tMid.clamp(0.0, 1.0));
      final expectedMidWidth = width * percent * curveMid;

      var box = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey('linear_percent_filled')),
      );
      expect(box.size.width, closeTo(expectedMidWidth, 3));

      // ---- End ----
      await tester.pump(Duration(milliseconds: durationMs));
      box = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey('linear_percent_filled')),
      );
      expect(box.size.width, closeTo(width * percent, 0.5));
    });
  });

  group('CircularPercentIndicator', () {
    testWidgets('paints ring and shows center widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const CircularPercentIndicator(
          percent: 0.75,
          radius: 40,
          lineWidth: 8,
          center: Text('75%'),
        ),
      ));

      expect(find.byKey(const ValueKey('circular_percent_painter')),
          findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('animates without exceptions', (tester) async {
      await tester.pumpWidget(_wrap(
        const CircularPercentIndicator(
          percent: 1.0,
          radius: 30,
          animation: true,
          animationDuration: 300,
        ),
      ));

      await tester.pump(); // start
      await tester.pump(const Duration(milliseconds: 150)); // mid
      await tester.pump(const Duration(milliseconds: 200)); // end
      expect(find.byKey(const ValueKey('circular_percent_painter')),
          findsOneWidget);
    });
  });
}
