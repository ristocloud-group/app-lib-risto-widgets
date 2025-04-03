// test/open_custom_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('OpenCustomSheet Tests', () {
    testWidgets('Confirm buttons are visible in openConfirmSheet',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet.openConfirmSheet(
                    context,
                    body: const Text('Are you sure?'),
                    onClose: (value) {
                    },
                    confirmButtonText: 'Confirm',
                    cancelButtonText: 'Cancel',
                  ).show(context); // Ensure to call the show() method
                },
                child: const Text('Open Confirm Sheet'),
              ),
            ),
          ),
        ),
      );

      // Verify the button to open the sheet is present.
      expect(find.text('Open Confirm Sheet'), findsOneWidget);

      // Tap the button to open the confirm sheet.
      await tester.tap(find.text('Open Confirm Sheet'));
      await tester.pumpAndSettle(); // Wait for the modal to render.

      // Ensure the sheet content is displayed.
      expect(find.text('Are you sure?'), findsOneWidget);

      // Verify that the Confirm and Cancel buttons are visible.
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Confirm buttons function correctly - Confirm Action',
        (WidgetTester tester) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet.openConfirmSheet(
                    context,
                    body: const Text('Are you sure?'),
                    onClose: (value) {
                      confirmed = value == true;
                    },
                    confirmButtonText: 'Confirm',
                    cancelButtonText: 'Cancel',
                  ).show(context);
                },
                child: const Text('Open Confirm Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the confirm sheet.
      await tester.tap(find.text('Open Confirm Sheet'));
      await tester.pumpAndSettle(); // Wait for the modal to render.

      // Tap the 'Confirm' button.
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle(); // Wait for the sheet to close.

      // Verify that the sheet closed with a true value.
      expect(confirmed, true);
    });

    testWidgets('Confirm buttons function correctly - Cancel Action',
        (WidgetTester tester) async {
      bool cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet.openConfirmSheet(
                    context,
                    body: const Text('Are you sure?'),
                    onClose: (value) {
                      cancelled = value == false;
                    },
                    confirmButtonText: 'Confirm',
                    cancelButtonText: 'Cancel',
                  ).show(context);
                },
                child: const Text('Open Confirm Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the confirm sheet.
      await tester.tap(find.text('Open Confirm Sheet'));
      await tester.pumpAndSettle(); // Wait for the modal to render.

      // Tap the 'Cancel' button.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle(); // Wait for the sheet to close.

      // Verify that the sheet closed with a false value.
      expect(cancelled, true);
    });

    testWidgets('Confirm buttons are not visible in normal sheet',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet(
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    onClose: (value) {
                    },
                    backgroundColor: Colors.white,
                    handleColor: Colors.grey,
                    sheetPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    showDefaultButtons: false,
                    // Ensure no default buttons
                    body: ({scrollController}) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomActionButton.flat(
                          onPressed: () => Navigator.pop(context, true),
                          backgroundColor: Colors.green,
                          margin: EdgeInsets.zero,
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ).show(context);
                },
                child: const Text('Open Custom Form Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the custom form sheet.
      await tester.tap(find.text('Open Custom Form Sheet'));
      await tester.pumpAndSettle(); // Wait for the sheet to render.

      // Ensure the sheet content is displayed.
      expect(find.text('Enter Details'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Ensure that Confirm and Cancel buttons are NOT visible.
      expect(find.text('Confirm'), findsNothing);
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('Scrollable sheet works correctly',
        (WidgetTester tester) async {

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet.scrollableSheet(
                    context,
                    expand: true,
                    initialChildSize: 0.5,
                    minChildSize: 0.25,
                    maxChildSize: 1.0,
                    body: ({scrollController}) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: 50,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Item $index'),
                        ),
                      );
                    },
                    onClose: (value) {
                    },
                    backgroundColor: Colors.white,
                    handleColor: Colors.grey,
                  ).show(context);
                },
                child: const Text('Open Scrollable Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the scrollable sheet.
      await tester.tap(find.text('Open Scrollable Sheet'));
      await tester.pumpAndSettle();

      // Now scroll the list
      await tester.dragUntilVisible(
        find.text('Item 19'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();

      // Verify that Item 19 is visible.
      expect(find.text('Item 19'), findsOneWidget);
    });

    testWidgets('Barrier dismiss works correctly', (WidgetTester tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet(
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    onClose: (value) {
                      dismissed = value == null;
                    },
                    backgroundColor: Colors.white,
                    handleColor: Colors.grey,
                    sheetPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    showDefaultButtons: false,
                    // No default buttons
                    body: ({scrollController}) =>
                        const Text('Dismissable Sheet'),
                  ).show(context);
                },
                child: const Text('Open Dismissable Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the dismissable sheet.
      await tester.tap(find.text('Open Dismissable Sheet'));
      await tester.pumpAndSettle(); // Wait for the sheet to appear.

      // Ensure the sheet content is displayed.
      expect(find.text('Dismissable Sheet'), findsOneWidget);

      // Tap outside the sheet to dismiss it.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle(); // Wait for the sheet to dismiss.

      // Verify that the dismiss action was triggered.
      expect(dismissed, true);
    });

    testWidgets('Barrier dismiss disabled prevents sheet from closing',
        (WidgetTester tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet(
                    barrierDismissible: false,
                    // Disable barrier dismiss
                    barrierColor: Colors.black.withOpacity(0.5),
                    onClose: (value) {
                      dismissed = value == null;
                    },
                    backgroundColor: Colors.white,
                    handleColor: Colors.grey,
                    sheetPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    showDefaultButtons: false,
                    // No default buttons
                    body: ({scrollController}) =>
                        const Text('Non-dismissible Sheet'),
                  ).show(context);
                },
                child: const Text('Open Non-dismissible Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the non-dismissible sheet.
      await tester.tap(find.text('Open Non-dismissible Sheet'));
      await tester.pumpAndSettle(); // Wait for the sheet to appear.

      // Ensure the sheet content is displayed.
      expect(find.text('Non-dismissible Sheet'), findsOneWidget);

      // Attempt to tap outside the sheet to dismiss it.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle(); // Wait to see if the sheet dismisses.

      // Verify that the dismiss action was NOT triggered.
      expect(dismissed, false);

      // Close the sheet programmatically.
      await tester.tap(find.text('Non-dismissible Sheet'));
      await tester.pumpAndSettle();

      // Verify that the sheet is still open.
      expect(find.text('Non-dismissible Sheet'), findsOneWidget);
    });

    testWidgets('Custom sheet without confirm buttons works correctly',
        (WidgetTester tester) async {
      bool? sheetResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  OpenCustomSheet(
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    onClose: (value) {
                      sheetResult = value;
                    },
                    backgroundColor: Colors.white,
                    handleColor: Colors.grey,
                    sheetPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    showDefaultButtons: false,
                    // No default buttons
                    body: ({scrollController}) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomActionButton.flat(
                          onPressed: () => Navigator.pop(context, true),
                          backgroundColor: Colors.green,
                          margin: EdgeInsets.zero,
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ).show(context);
                },
                child: const Text('Open Custom Form Sheet'),
              ),
            ),
          ),
        ),
      );

      // Tap the button to open the custom form sheet.
      await tester.tap(find.text('Open Custom Form Sheet'));
      await tester.pumpAndSettle(); // Wait for the sheet to render.

      // Ensure the sheet content is displayed.
      expect(find.text('Enter Details'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Ensure that Confirm and Cancel buttons are NOT visible.
      expect(find.text('Confirm'), findsNothing);
      expect(find.text('Cancel'), findsNothing);

      // Tap the 'Submit' button to close the sheet.
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle(); // Wait for the sheet to close.

      // Verify that the sheet closed with a true value.
      expect(sheetResult, true);
    });
  });
}
