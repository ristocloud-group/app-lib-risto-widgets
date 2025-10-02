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

    testWidgets('uses kind accent color on icon', (tester) async {
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

      // Find the icon and check its color
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, kErr);
    });

    testWidgets('does not render icon when showIcon is false', (tester) async {
      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'No Icon Here',
          showIcon: false,
        ),
      ));

      expect(find.text('No Icon Here'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('applies runSpacing between elements', (tester) async {
      const spacing = 24.0;
      await tester.pumpWidget(_wrap(
        const RistoNoticeCard(
          kind: RistoNoticeKind.info,
          title: 'Title',
          subtitle: 'Subtitle',
          runSpacing: spacing,
        ),
      ));

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

      // We expect two SizedBoxes for spacing between icon-title and title-subtitle.
      final spacingBoxes = sizedBoxes.where((box) => box.height == spacing).toList();
      expect(spacingBoxes.length, 2);
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
