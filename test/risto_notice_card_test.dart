import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/feedback/risto_notice_card.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(body: Center(child: SizedBox(width: 600, child: child))),
    );

void main() {
  testWidgets('renders title, subtitle and inline action when wide',
      (tester) async {
    bool tapped = false;

    await tester.pumpWidget(_wrap(
      RistoNoticeCard(
        kind: RistoNoticeKind.info,
        title: 'Hello',
        subtitle: 'World',
        actionLabel: 'Action',
        onAction: () => tapped = true,
      ),
    ));

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
    expect(find.byKey(const ValueKey('risto_notice_action_inline')),
        findsOneWidget);

    await tester.tap(find.text('Action'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('stacks action below when narrow', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400, // below default breakpoint 520
            child: RistoNoticeCard(
              kind: RistoNoticeKind.warning,
              title: 'Watch out',
              subtitle: 'Careful here',
              actionLabel: 'Fix',
              onAction: () {},
            ),
          ),
        ),
      ),
    ));

    expect(find.byKey(const ValueKey('risto_notice_action_below')),
        findsOneWidget);
  });

  testWidgets('uses kind accent color on stripe', (tester) async {
    const kErr = Color(0xFFAA0011);
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo).copyWith(
        error: kErr,
      ),
    );

    await tester.pumpWidget(_wrap(
      const RistoNoticeCard(
        kind: RistoNoticeKind.error,
        title: 'Boom',
      ),
      theme: theme,
    ));

    final stripe = tester.widget<Container>(
      find.byKey(const ValueKey('risto_notice_stripe')),
    );
    final deco = stripe.decoration as BoxDecoration;
    expect(deco.color, kErr);
  });
}
