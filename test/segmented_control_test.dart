import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/navigation/custom_bottom_navbar.dart';
import 'package:risto_widgets/widgets/navigation/section_switcher.dart';

void main() {
  testWidgets('SegmentedControl renders segment labels correctly',
      (WidgetTester tester) async {
    // Arrange
    final segments = [Text('One'), Text('Two'), Text('Three')];

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

  testWidgets('SegmentedControl calls onSegmentSelected callback on tap',
      (WidgetTester tester) async {
    // Arrange
    final segments = [Text('A'), Text('B')];
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

  testWidgets('SectionSwitcher shows initial page and switches on tap',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      NavigationItem(
          page: Text('Page 1'), icon: Icon(Icons.home), label: 'Home'),
      NavigationItem(
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

  testWidgets('SegmentedControl applies custom backgroundColor',
      (WidgetTester tester) async {
    // Arrange
    final bgColor = Colors.redAccent;
    final segments = [Text('X'), Text('Y')];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SegmentedControl(
            segments: segments,
            backgroundColor: bgColor,
          ),
        ),
      ),
    );

    // Act
    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(SegmentedControl),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration as BoxDecoration;

    // Assert
    expect(decoration.color, equals(bgColor));
  });
}
