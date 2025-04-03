import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/navigation/custom_bottom_navbar.dart';

void main() {
  testWidgets('CustomBottomNavBar renders correctly with default settings',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      const NavigationItem(
        page: Text('Page 1'),
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationItem(
        page: Text('Page 2'),
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavBar(items: items),
        ),
      ),
    );

    // Assert
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('CustomBottomNavBar allows item selection and page navigation',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      const NavigationItem(
        page: Text('Page 1'),
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationItem(
        page: Text('Page 2'),
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: CustomBottomNavBar(items: items),
      ),
    );

    // Act
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Page 2'), findsOneWidget);
  });

  testWidgets('CustomBottomNavBar applies custom item padding and margin',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      const NavigationItem(
        page: Text('Page 1'),
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationItem(
        page: Text('Page 2'),
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavBar(
            items: items,
            margin: const EdgeInsets.all(8.0),
            itemPadding: const EdgeInsets.all(16.0),
          ),
        ),
      ),
    );

    // Act
    final card = tester.widget<Card>(find.byType(Card));
    final containerFinder = find.descendant(
      of: find.byType(BottomNavigationBar),
      matching: find.byType(Container),
    );

    // Assert
    expect(card.margin, const EdgeInsets.all(8.0)); // Check margin
    expect(containerFinder, findsWidgets); // Ensure Container widgets are found
    final firstContainer = tester.widget<Container>(containerFinder.first);
    expect(firstContainer.padding, const EdgeInsets.all(16.0)); // Check padding
  });

  testWidgets('CustomBottomNavBar applies custom elevation',
      (WidgetTester tester) async {
    // Arrange
    final items = [
      const NavigationItem(
        page: Text('Page 1'),
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationItem(
        page: Text('Page 2'),
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNavBar(
            items: items,
            elevation: 12.0,
          ),
        ),
      ),
    );

    // Act
    final card = tester.widget<Card>(find.byType(Card));

    // Assert
    expect(card.elevation, 12.0);
  });
}
