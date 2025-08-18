import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  const anim = Duration(milliseconds: 350);

  Future<void> openByTap(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump(); // start the animation
    await tester.pumpAndSettle(anim); // finish it
  }

  Future<void> tapBarrier(WidgetTester tester) async {
    // Tap near the top-left of the screen, which is always outside the sheet.
    final scaffoldTopLeft =
        tester.getTopLeft(find.byType(Scaffold)).translate(8, 8);
    await tester.tapAt(scaffoldTopLeft);
    await tester.pump();
    await tester.pumpAndSettle(anim);
  }

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('OpenCustomSheet', () {
    testWidgets('Confirm buttons are visible in openConfirmSheet',
        (tester) async {
      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet.openConfirmSheet(
                context,
                body: const Text('Are you sure?'),
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                onClose: (_) {},
              ).show(context);
            },
            child: const Text('Open Confirm Sheet'),
          ),
        ),
      ));

      expect(find.text('Open Confirm Sheet'), findsOneWidget);

      await openByTap(tester, 'Open Confirm Sheet');

      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Confirm buttons function correctly - Confirm Action',
        (tester) async {
      bool confirmed = false;

      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet.openConfirmSheet(
                context,
                body: const Text('Are you sure?'),
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                onClose: (value) => confirmed = value == true,
              ).show(context);
            },
            child: const Text('Open Confirm Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Confirm Sheet');
      await tester.tap(find.text('Confirm'));
      await tester.pump();
      await tester.pumpAndSettle(anim);

      expect(confirmed, isTrue);
    });

    testWidgets('Confirm buttons function correctly - Cancel Action',
        (tester) async {
      bool cancelled = false;

      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet.openConfirmSheet(
                context,
                body: const Text('Are you sure?'),
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                onClose: (value) => cancelled = value == false,
              ).show(context);
            },
            child: const Text('Open Confirm Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Confirm Sheet');
      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.pumpAndSettle(anim);

      expect(cancelled, isTrue);
    });

    testWidgets('Confirm buttons are not visible in normal sheet',
        (tester) async {
      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet(
                barrierDismissible: true,
                barrierColor: Colors.black.withCustomOpacity(0.5),
                onClose: (_) {},
                backgroundColor: Colors.white,
                handleColor: Colors.grey,
                sheetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                showDefaultButtons: false,
                body: ({scrollController}) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Details',
                        style: Theme.of(context).textTheme.titleLarge),
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
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ).show(context);
            },
            child: const Text('Open Custom Form Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Custom Form Sheet');

      expect(find.text('Enter Details'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      expect(find.text('Confirm'), findsNothing);
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('Scrollable sheet works correctly', (tester) async {
      await tester.pumpWidget(host(
        Builder(
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
                    itemBuilder: (context, index) =>
                        ListTile(title: Text('Item $index')),
                  );
                },
                onClose: (_) {},
                backgroundColor: Colors.white,
                handleColor: Colors.grey,
              ).show(context);
            },
            child: const Text('Open Scrollable Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Scrollable Sheet');

      // Scroll the list until a certain item is visible.
      await tester.dragUntilVisible(
        find.text('Item 19'),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle(anim);

      expect(find.text('Item 19'), findsOneWidget);
    });

    testWidgets('Barrier dismiss works correctly', (tester) async {
      bool dismissed = false;

      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet(
                barrierDismissible: true,
                barrierColor: Colors.black.withCustomOpacity(0.5),
                onClose: (value) => dismissed = value == null,
                backgroundColor: Colors.white,
                handleColor: Colors.grey,
                sheetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                showDefaultButtons: false,
                body: ({scrollController}) => const Text('Dismissable Sheet'),
              ).show(context);
            },
            child: const Text('Open Dismissable Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Dismissable Sheet');
      expect(find.text('Dismissable Sheet'), findsOneWidget);

      await tapBarrier(tester);

      expect(dismissed, isTrue);
    });

    testWidgets('Barrier dismiss disabled prevents sheet from closing',
        (tester) async {
      bool dismissed = false;

      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet(
                barrierDismissible: false,
                barrierColor: Colors.black.withCustomOpacity(0.5),
                onClose: (value) => dismissed = value == null,
                backgroundColor: Colors.white,
                handleColor: Colors.grey,
                sheetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                showDefaultButtons: false,
                body: ({scrollController}) =>
                    const Text('Non-dismissible Sheet'),
              ).show(context);
            },
            child: const Text('Open Non-dismissible Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Non-dismissible Sheet');
      expect(find.text('Non-dismissible Sheet'), findsOneWidget);

      // Try to dismiss by tapping the barrier – it should NOT close.
      await tapBarrier(tester);

      expect(dismissed, isFalse);
      expect(find.text('Non-dismissible Sheet'), findsOneWidget);

      // Close by tapping content (no-op in your sheet, just ensures it remains).
      await tester.tap(find.text('Non-dismissible Sheet'));
      await tester.pumpAndSettle(anim);

      expect(find.text('Non-dismissible Sheet'), findsOneWidget);
    });

    testWidgets('Custom sheet without confirm buttons returns true on Submit',
        (tester) async {
      bool? result;

      await tester.pumpWidget(host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              OpenCustomSheet(
                barrierDismissible: true,
                barrierColor: Colors.black.withCustomOpacity(0.5),
                onClose: (value) => result = value,
                backgroundColor: Colors.white,
                handleColor: Colors.grey,
                sheetPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                showDefaultButtons: false,
                body: ({scrollController}) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Details',
                        style: Theme.of(context).textTheme.titleLarge),
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
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ).show(context);
            },
            child: const Text('Open Custom Form Sheet'),
          ),
        ),
      ));

      await openByTap(tester, 'Open Custom Form Sheet');

      expect(find.text('Enter Details'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Confirm'), findsNothing);
      expect(find.text('Cancel'), findsNothing);

      await tester.tap(find.text('Submit'));
      await tester.pump();
      await tester.pumpAndSettle(anim);

      expect(result, isTrue);
    });
  });
}
