import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/buttons/custom_action_button.dart';
import 'package:risto_widgets/widgets/feedback/risto_notice_card.dart';

// Helper to wrap a widget in a MaterialApp for testing.
Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(body: Center(child: SizedBox(width: 600, child: child))),
    );

void main() {
  group('RistoNoticeCard', () {
    testWidgets('renders title, subtitle and footer', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Hello',
          subtitle: 'World',
          footerBuilder: (context, accentColor) => CustomActionButton.flat(
            onPressed: () => tapped = true,
            child: const Text('Action'),
          ),
        ),
      ));

      // Verify title, subtitle, and action button are present
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);

      // Verify tap callback
      await tester.tap(find.text('Action'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders icon when one is provided', (tester) async {
      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          noticeIcon: Icon(Icons.info),
        ),
      ));
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('does not render icon when it is not provided',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'No Icon Here',
        ),
      ));

      expect(find.text('No Icon Here'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });
    
    testWidgets('inverts title and icon when invert is true', (tester) async {
      await tester.pumpWidget(_wrap(
        RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Inverted Title',
          noticeIcon: const Icon(Icons.invert_colors),
          invert: true,
        ),
      ));

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.children.first, isA<Text>());
      expect(column.children.last, isA<Icon>());
    });

    testWidgets('renders rich text when subtitleSpan is provided', (tester) async {
      await tester.pumpWidget(_wrap(
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
      ));

      // Find the specific RichText for the subtitle to avoid matching the title's RichText.
      final subtitleFinder = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == 'Hello World',
      );

      expect(subtitleFinder, findsOneWidget);
    });


    testWidgets('applies runSpacing between elements', (tester) async {
      const spacing = 24.0;
      await tester.pumpWidget(_wrap(
        RistoNoticeCard(
          kind: RistoNoticeKind.info,
          noticeIcon: const Icon(Icons.info),
          title: 'Title',
          subtitle: 'Subtitle',
          runSpacing: spacing,
          footerBuilder: (context, accentColor) => const Text('Footer'),
        ),
      ));

      // Find the main column by finding an ancestor of one of its direct children (the footer)
      final column = tester.widget<Column>(find.ancestor(
        of: find.text('Footer'),
        matching: find.byType(Column),
      ));
      final children = column.children;
      
      // We expect 7 children: icon, space, title, space, subtitle, space, footer
      expect(children.length, 7);
      expect(children[1], isA<SizedBox>().having((s) => s.height, 'height', spacing));
      expect(children[3], isA<SizedBox>().having((s) => s.height, 'height', spacing));
      expect(children[5], isA<SizedBox>().having((s) => s.height, 'height', spacing));
    });

    testWidgets('respects mainAxisAlignment for alignment', (tester) async {
      await tester.pumpWidget(_wrap(
        RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Title',
          footerBuilder: (context, accentColor) => const Text('Footer'),
          minHeight: 300, // Important for alignment to take effect
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ));

      // Find the main column, which will have MainAxisSize.max because a height is set.
      final column = tester.widget<Column>(find.byWidgetPredicate(
        (widget) => widget is Column && widget.mainAxisSize == MainAxisSize.max,
      ));
      expect(column.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('applies custom titleStyle', (tester) async {
      const customStyle = TextStyle(color: Colors.purple, fontSize: 24.0);

      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Styled Title',
          titleStyle: customStyle,
        ),
      ));

      final titleText = tester.widget<Text>(find.text('Styled Title'));
      expect(titleText.style?.color, customStyle.color);
      expect(titleText.style?.fontSize, customStyle.fontSize);
    });

    testWidgets('applies custom subtitleStyle', (tester) async {
      const customStyle =
          TextStyle(color: Colors.teal, fontStyle: FontStyle.italic);

      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Title',
          subtitle: 'Styled Subtitle',
          subtitleStyle: customStyle,
        ),
      ));

      final subtitleText = tester.widget<Text>(find.text('Styled Subtitle'));
      expect(subtitleText.style?.color, customStyle.color);
      expect(subtitleText.style?.fontStyle, customStyle.fontStyle);
    });

    testWidgets('merges custom titleStyle with default theme style',
        (tester) async {
      // Custom style only defines color. FontWeight should be inherited from the default.
      const customStyle = TextStyle(color: Colors.red);

      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Merged Title',
          titleStyle: customStyle,
        ),
      ));

      final titleText = tester.widget<Text>(find.text('Merged Title'));

      // Check that the custom color is applied.
      expect(titleText.style?.color, customStyle.color);

      // Check that the default fontWeight from the widget's internal styling is preserved.
      expect(titleText.style?.fontWeight, FontWeight.bold);
    });
  });
}
