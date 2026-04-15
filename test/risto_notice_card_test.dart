import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/custom_action_button.dart';
import 'package:risto_widgets/widgets/feedback/risto_notice_card.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? ThemeData.light(),
  home: Scaffold(
    body: Center(child: SizedBox(width: 600, child: child)),
  ),
);

void main() {
  group('RistoNoticeCard', () {
    testWidgets('renders title, subtitle and footer', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Hello',
            subtitle: 'World',
            footerBuilder: (context, accentColor) => CustomActionButton.flat(
              onPressed: () => tapped = true,
              child: const Text('Action'),
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);

      await tester.tap(find.text('Action'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders icon when one is explicitly provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.info,
            noticeIcon: Icon(Icons.star),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders default semantic icon when noticeIcon is omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.success,
            title: 'Success Title',
          ),
        ),
      );

      expect(find.text('Success Title'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('inverts title and icon when invert is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Inverted Title',
            noticeIcon: const Icon(Icons.invert_colors),
            invert: true,
          ),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.children.first, isA<Text>());
      expect(column.children.last, isA<Icon>());
    });

    testWidgets('renders rich text when subtitleSpan is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Rich Text',
            subtitleSpan: [
              TextSpan(text: 'Hello '),
              TextSpan(
                text: 'World',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

      final subtitleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText() == 'Hello World',
      );

      expect(subtitleFinder, findsOneWidget);
    });

    testWidgets('applies runSpacing between elements correctly', (
      tester,
    ) async {
      const spacing = 24.0;
      await tester.pumpWidget(
        _wrap(
          RistoNoticeCard(
            kind: RistoNoticeKind.info,
            noticeIcon: const Icon(Icons.info),
            title: 'Title',
            subtitle: 'Subtitle',
            runSpacing: spacing,
            footerBuilder: (context, accentColor) => const Text('Footer'),
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.ancestor(of: find.text('Footer'), matching: find.byType(Column)),
      );
      final children = column.children;

      expect(children.length, 7);
      expect(
        children[1],
        isA<SizedBox>().having((s) => s.height, 'height', spacing),
      );
      expect(
        children[3],
        isA<SizedBox>().having((s) => s.height, 'height', spacing / 2),
      );
      expect(
        children[5],
        isA<SizedBox>().having((s) => s.height, 'height', spacing),
      );
    });

    testWidgets('respects mainAxisAlignment for alignment', (tester) async {
      await tester.pumpWidget(
        _wrap(
          RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Title',
            footerBuilder: (context, accentColor) => const Text('Footer'),
            minHeight: 300,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      );

      final column = tester.widget<Column>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Column && widget.mainAxisSize == MainAxisSize.max,
        ),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('applies custom titleStyle', (tester) async {
      const customStyle = TextStyle(color: Colors.purple, fontSize: 24.0);

      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Styled Title',
            titleStyle: customStyle,
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Styled Title'));
      expect(titleText.style?.color, customStyle.color);
      expect(titleText.style?.fontSize, customStyle.fontSize);
    });

    testWidgets('applies custom subtitleStyle', (tester) async {
      const customStyle = TextStyle(
        color: Colors.teal,
        fontStyle: FontStyle.italic,
      );

      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Title',
            subtitle: 'Styled Subtitle',
            subtitleStyle: customStyle,
          ),
        ),
      );

      final subtitleText = tester.widget<Text>(find.text('Styled Subtitle'));
      expect(subtitleText.style?.color, customStyle.color);
      expect(subtitleText.style?.fontStyle, customStyle.fontStyle);
    });

    testWidgets('merges custom titleStyle with default theme style', (
      tester,
    ) async {
      const customStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(
        _wrap(
          const RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Merged Title',
            titleStyle: customStyle,
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Merged Title'));

      expect(titleText.style?.color, customStyle.color);
      expect(titleText.style?.fontWeight, isNotNull);
    });
  });
}
