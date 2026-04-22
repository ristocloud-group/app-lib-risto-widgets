import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/navigation/custom_nav_bars.dart'; // Adjust path if needed

void main() {
  // ===========================================================================
  // CLASSIC CUSTOM BOTTOM NAV BAR TESTS
  // ===========================================================================
  group('CustomBottomNavBar Tests', () {
    testWidgets('renders correctly with default settings', (tester) async {
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
          home: Scaffold(body: CustomBottomNavBar(items: items)),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('allows item selection and page navigation', (tester) async {
      final items = [
        const NavigationItem(
          page: Text('Page 1 Content'),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationItem(
          page: Text('Page 2 Content'),
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: CustomBottomNavBar(items: items)),
      );

      // Initially, Page 1 Content is visible
      expect(find.text('Page 1 Content'), findsOneWidget);
      expect(find.text('Page 2 Content'), findsNothing);

      // Act
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Page 1 Content'), findsNothing);
      expect(find.text('Page 2 Content'), findsOneWidget);
    });

    testWidgets('applies custom item padding and margin', (tester) async {
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

      final card = tester.widget<Card>(find.byType(Card));
      final containerFinder = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byType(Container),
      );

      expect(card.margin, const EdgeInsets.all(8.0));
      expect(containerFinder, findsWidgets);

      final firstContainer = tester.widget<Container>(containerFinder.first);
      expect(firstContainer.padding, const EdgeInsets.all(16.0));
    });

    testWidgets('applies custom elevation', (tester) async {
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
            body: CustomBottomNavBar(items: items, elevation: 12.0),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 12.0);
    });
  });

  // ===========================================================================
  // BUBBLE BOTTOM NAV BAR TESTS
  // ===========================================================================
  group('BubbleBottomNavBar Tests', () {
    testWidgets('renders groups and items correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BubbleBottomNavBar(
              groups: [
                BubbleGroup(
                  items: [
                    const BubbleNavItem(
                      page: Text('Page 1'),
                      icon: Icon(Icons.home, key: Key('icon_home')),
                    ),
                    const BubbleNavItem(
                      page: Text('Page 2'),
                      icon: Icon(Icons.map, key: Key('icon_map')),
                    ),
                  ],
                ),
                BubbleGroup(
                  items: [
                    BubbleNavItem(
                      page: const Text('Page 3'),
                      customWidget: Container(key: const Key('custom_widget')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify icons are rendered
      expect(find.byKey(const Key('icon_home')), findsOneWidget);
      expect(find.byKey(const Key('icon_map')), findsOneWidget);

      // Verify custom widget is rendered
      expect(find.byKey(const Key('custom_widget')), findsOneWidget);

      // Verify first page is visible
      expect(find.text('Page 1'), findsOneWidget);
    });

    testWidgets('navigates to the correct page on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BubbleBottomNavBar(
              groups: [
                const BubbleGroup(
                  items: [
                    BubbleNavItem(
                      page: Text('Home Content'),
                      icon: Icon(Icons.home, key: Key('btn_home')),
                    ),
                    BubbleNavItem(
                      page: Text('Settings Content'),
                      icon: Icon(Icons.settings, key: Key('btn_settings')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home Content'), findsOneWidget);
      expect(find.text('Settings Content'), findsNothing);

      // Tap settings
      await tester.tap(find.byKey(const Key('btn_settings')));
      await tester.pumpAndSettle();

      // Verify page flip
      expect(find.text('Home Content'), findsNothing);
      expect(find.text('Settings Content'), findsOneWidget);
    });

    testWidgets(
      'onPress intercepts and prevents navigation if returning false',
      (tester) async {
        bool customActionFired = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BubbleBottomNavBar(
                groups: [
                  BubbleGroup(
                    items: [
                      const BubbleNavItem(
                        page: Text('Main Page'),
                        icon: Icon(Icons.home, key: Key('btn_home')),
                      ),
                      BubbleNavItem(
                        page: const Text('Hidden Page'),
                        icon: const Icon(Icons.menu, key: Key('btn_menu')),
                        onPress: () async {
                          customActionFired = true;
                          return false; // Prevent navigation
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Main Page'), findsOneWidget);

        // Tap the menu button
        await tester.tap(find.byKey(const Key('btn_menu')));
        await tester.pumpAndSettle();

        // The custom action should have fired
        expect(customActionFired, isTrue);

        // But the page should NOT have changed
        expect(find.text('Hidden Page'), findsNothing);
        expect(find.text('Main Page'), findsOneWidget);
      },
    );

    testWidgets(
      'items without pages act as pure trigger buttons without crashing',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BubbleBottomNavBar(
                groups: [
                  BubbleGroup(
                    items: [
                      const BubbleNavItem(
                        page: Text('Valid Page'),
                        icon: Icon(Icons.home, key: Key('btn_home')),
                      ),
                      BubbleNavItem(
                        page: null, // Null page
                        icon: const Icon(Icons.add, key: Key('btn_add')),
                        onPress: () async => false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap the action button
        await tester.tap(find.byKey(const Key('btn_add')));
        await tester.pumpAndSettle();

        // Verify it didn't break the layout or navigation state
        expect(tester.takeException(), isNull);
        expect(find.text('Valid Page'), findsOneWidget);
      },
    );
  });
}
