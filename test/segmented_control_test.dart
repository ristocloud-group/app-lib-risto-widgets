import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/navigation/custom_bottom_navbar.dart';
import 'package:risto_widgets/widgets/navigation/section_switcher.dart';

void main() {
  // --- This test remains valid as it checks core rendering logic. ---
  testWidgets('SegmentedControl renders segment labels correctly',
      (WidgetTester tester) async {
    // Arrange
    final segments = [
      const Text('One'),
      const Text('Two'),
      const Text('Three')
    ];

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl(
            segments: segments,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });

  // --- This test remains valid as it checks the selection callback. ---
  testWidgets('SegmentedControl calls onSegmentSelected callback on tap',
      (WidgetTester tester) async {
    // Arrange
    final segments = [const Text('A'), const Text('B')];
    int? tappedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl(
            segments: segments,
            onSegmentSelected: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    // Act: tap second segment
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    // Assert
    expect(tappedIndex, equals(1));
  });

  // --- This test remains valid as it checks the core page switching logic. ---
  testWidgets('SectionSwitcher shows initial page and switches on tap',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      const NavigationItem(
          page: Text('Page 1'), icon: Icon(Icons.home), label: 'Home'),
      const NavigationItem(
          page: Text('Page 2'), icon: Icon(Icons.search), label: 'Search'),
    ];

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionSwitcher(items: items),
        ),
      ),
    );

    // Assert initial page
    expect(find.text('Page 1'), findsOneWidget);
    expect(find.text('Page 2'), findsNothing);

    // Act: tap second segment
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Assert switched page
    expect(find.text('Page 2'), findsOneWidget);
    expect(find.text('Page 1'), findsNothing);
  });

  // --- REFACTORED TEST for the new styling API ---
  // This test replaces the old `backgroundColor` test with a more comprehensive one.
  testWidgets('SegmentedControl applies custom style correctly',
      (WidgetTester tester) async {
    // Arrange: Define a custom style using the new API.
    const bgColor = Colors.redAccent;
    const indicatorColor = Colors.blueAccent;
    const indicatorElevation = 5.0;
    final segments = [const Text('X'), const Text('Y')];

    // Act: Apply the style using the `style` property.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl(
            segments: segments,
            style: SegmentedControl.styleFrom(
              backgroundColor: bgColor,
              indicatorColor: indicatorColor,
              indicatorElevation: indicatorElevation,
            ),
          ),
        ),
      ),
    );

    // Assert: Find the Card widgets and check their properties.

    // 1. Find the track Card by its unique background color.
    final trackCardFinder = find.byWidgetPredicate(
      (widget) => widget is Card && widget.color == bgColor,
    );
    expect(trackCardFinder, findsOneWidget,
        reason:
            'Should find the track Card with the specified background color.');

    // 2. Find the indicator Card by its unique properties.
    final indicatorCardFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Card &&
          widget.color == indicatorColor &&
          widget.elevation == indicatorElevation,
    );
    expect(indicatorCardFinder, findsOneWidget,
        reason:
            'Should find the indicator Card with specified color and elevation.');
  });
}
