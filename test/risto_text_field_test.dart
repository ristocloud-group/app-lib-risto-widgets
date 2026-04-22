import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Replace with the correct path to your widget file.
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('RistoTextField Tests', () {
    testWidgets('Renders standard text field with title and hint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RistoTextField(title: 'Full Name', hint: 'Enter your name'),
          ),
        ),
      );

      // Verify title and hint are displayed
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);

      // Enter text and verify (enterText works on the TextFormField wrapper)
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pump();
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Password factory toggles obscureText on icon tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: RistoTextField.password(title: 'Password')),
        ),
      );

      // We read the underlying TextField to check the obscureText property
      TextField textField = tester.widget(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // The icon should be visibility_off when text is obscured
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap the visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Fetch the rebuilt TextField and verify it is no longer obscured
      textField = tester.widget(find.byType(TextField));
      expect(textField.obscureText, isFalse);

      // The icon should switch to visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Email factory sets correct keyboard type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: RistoTextField.email(title: 'Email')),
        ),
      );

      // We read the underlying TextField to check the keyboardType property
      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('Number factory formats input correctly (allows decimals)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RistoTextField.number(title: 'Amount', allowDecimals: true),
          ),
        ),
      );

      // 1. Verify that valid decimals are accepted
      await tester.enterText(find.byType(TextFormField), '123.45');
      await tester.pump();
      expect(find.text('123.45'), findsOneWidget);

      // 2. Verify that plain text is rejected
      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pump();
      expect(find.text('abc'), findsNothing);

      // 3. Verify that typing an invalid mix strips everything after the invalid character
      // (because the regex is anchored at the start: ^\d*\.?\d* )
      await tester.enterText(find.byType(TextFormField), '12a3.4b5');
      await tester.pump();
      expect(find.text('12'), findsOneWidget); // Stops parsing at the 'a'
    });

    testWidgets('Horizontal layout places title and field in a Row', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RistoTextField(title: 'Horizontal', horizontalLayout: true),
          ),
        ),
      );

      // Verify the title exists
      expect(find.text('Horizontal'), findsOneWidget);

      // In a horizontal layout, the Title and TextFormField should share a common Row ancestor
      final rowFinder = find.ancestor(
        of: find.byType(TextFormField),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsWidgets);
    });

    testWidgets(
      'Search factory renders outer leading and trailing widgets properly',
      (WidgetTester tester) async {
        const Key outerLeadingKey = Key('outer_leading');
        const Key outerTrailingKey = Key('outer_trailing');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RistoTextField.search(
                fieldHeight: 54.0,
                outerLeading: const SizedBox(
                  key: outerLeadingKey,
                  width: 50,
                  child: Text('Left'),
                ),
                outerTrailing: const SizedBox(
                  key: outerTrailingKey,
                  width: 50,
                  child: Text('Right'),
                ),
              ),
            ),
          ),
        );

        // Verify both outer elements rendered
        expect(find.byKey(outerLeadingKey), findsOneWidget);
        expect(find.byKey(outerTrailingKey), findsOneWidget);

        // Verify inner search icon rendered
        expect(find.byIcon(Icons.search), findsOneWidget);

        // Verify they are wrapped in a Row that uses CrossAxisAlignment.start
        final row = tester.widget<Row>(
          find
              .ancestor(
                of: find.byType(TextFormField),
                matching: find.byType(Row),
              )
              .first,
        );

        expect(row.crossAxisAlignment, CrossAxisAlignment.start);
      },
    );

    testWidgets('Validation error displays correctly below the field', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: RistoTextField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Initially no error is shown
      expect(find.text('This field is required'), findsNothing);

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pump();

      // Error message should now be visible
      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
