import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('OpenCustomDialog', () {
    testWidgets('displays custom dialog and closes automatically on pop', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomDialog.custom(
                    context,
                    builder: (ctx, close) => ElevatedButton(
                      onPressed: () => close('done_testing'),
                      child: const Text('Close Dialog'),
                    ),
                  ).show(context);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify custom content exists
      expect(find.text('Close Dialog'), findsOneWidget);

      // Tap to close via passed close() function
      await tester.tap(find.text('Close Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is gone
      expect(find.text('Close Dialog'), findsNothing);
    });

    testWidgets('success factory renders notice card and passes accentColor', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomDialog.success(
                    context,
                    title: 'Success!',
                    subtitle: 'It worked.',
                    confirmButtonText: 'OK',
                    accentColor: Colors.deepPurple,
                  ).show(context);
                },
                child: const Text('Open Success'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Success'));
      await tester.pumpAndSettle();

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('It worked.'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // FIX: Use find.byIcon instead of find.byType to avoid catching the close 'X' icon
      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle_outline));
      expect(icon.color, Colors.deepPurple);

      // Close the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Success!'), findsNothing);
    });

    testWidgets('warning factory renders double buttons', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomDialog.warning(
                    context,
                    title: 'Are you sure?',
                    confirmButtonText: 'Yes',
                    cancelButtonText: 'No',
                    onClose: (res) => dialogResult = res,
                  ).show(context);
                },
                child: const Text('Open Warning'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Warning'));
      await tester.pumpAndSettle();

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      // Tapping cancel should yield false natively
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(dialogResult, isFalse);
    });

    testWidgets('applies barrier dismissible behavior correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomDialog.error(
                    context,
                    title: 'Strict Error',
                    barrierDismissible: false,
                  ).show(context);
                },
                child: const Text('Open Strict'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Strict'));
      await tester.pumpAndSettle();

      expect(find.text('Strict Error'), findsOneWidget);

      // Try tapping outside the dialog (using coordinates far from the center dialog)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should STILL exist because barrierDismissible is false
      expect(find.text('Strict Error'), findsOneWidget);
    });
  });
}
