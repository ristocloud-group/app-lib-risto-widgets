import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart'; // Adjust path to your library

class NavBarsPage extends StatelessWidget {
  const NavBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Bar Styles')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            title: '1. Bubble NavBar (Split Grouping)',
            subtitle:
                'Matching your screenshots with distinct, floating pills.',
            icon: Icons.bubble_chart,
            destination: const BubbleSplitNavBarDemo(),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            title: '2. Bubble NavBar (Consolidated)',
            subtitle: 'All items grouped into a single floating pill.',
            icon: Icons.horizontal_distribute,
            destination: const BubbleConsolidatedNavBarDemo(),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            title: '3. Classic Custom NavBar',
            subtitle:
                'The original, full-width shifting bottom navigation bar.',
            icon: Icons.web_asset,
            destination: const ClassicNavBarDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}

// ===========================================================================
// DEMO 1: BUBBLE NAV BAR (SPLIT / MULTIPLE GROUPS)
// ===========================================================================
class BubbleSplitNavBarDemo extends StatelessWidget {
  const BubbleSplitNavBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BubbleBottomNavBar(
      groups: [
        // GROUP 1: The Switcher (Pill Shape)
        BubbleGroup(
          items: [
            BubbleNavItem(
              label: 'Home',
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              page: _buildMockPage(
                context,
                Colors.grey.shade100,
                'Home Dashboard',
              ),
            ),
            BubbleNavItem(
              label: 'Map',
              icon: const Icon(Icons.map_outlined),
              activeIcon: const Icon(Icons.map),
              page: _buildMockPage(
                context,
                Colors.green.shade100,
                'Interactive Map View',
              ),
            ),
          ],
        ),

        // GROUP 2: Action Button (Circular Shape)
        BubbleGroup(
          borderRadius: BorderRadius.circular(50), // Force perfect circle
          items: [
            BubbleNavItem(
              label: 'Menu',
              icon: const Icon(Icons.menu),
              page: null, // No page, acts purely as a trigger
              onPress: () async {
                showModalBottomSheet(
                  context: context,
                  builder:
                      (ctx) => Container(
                        height: 300,
                        padding: const EdgeInsets.all(24),
                        child: const Center(
                          child: Text(
                            "Custom Menu Action Triggered!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                );
                return false; // Prevent page navigation
              },
            ),
          ],
        ),

        // GROUP 3: Another Tab (Circular Shape)
        BubbleGroup(
          borderRadius: BorderRadius.circular(50),
          items: [
            BubbleNavItem(
              label: 'Deliveries',
              icon: const Icon(Icons.local_shipping_outlined),
              activeIcon: const Icon(Icons.local_shipping),
              page: _buildMockPage(
                context,
                Colors.orange.shade100,
                'Delivery List',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// DEMO 2: BUBBLE NAV BAR (CONSOLIDATED / SINGLE PILL)
// ===========================================================================
class BubbleConsolidatedNavBarDemo extends StatelessWidget {
  const BubbleConsolidatedNavBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return BubbleBottomNavBar(
      activeBackgroundColor: Colors.teal, // Custom active color
      groups: [
        BubbleGroup(
          // Everything is grouped together in one continuous pill
          items: [
            BubbleNavItem(
              label: 'Home',
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              page: _buildMockPage(context, Colors.teal.shade50, 'Home'),
            ),
            BubbleNavItem(
              label: 'Search',
              icon: const Icon(Icons.search),
              page: _buildMockPage(context, Colors.teal.shade100, 'Search'),
            ),
            BubbleNavItem(
              label: 'Profile',
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              page: _buildMockPage(context, Colors.teal.shade200, 'Profile'),
            ),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// DEMO 3: CLASSIC CUSTOM NAV BAR
// ===========================================================================
class ClassicNavBarDemo extends StatelessWidget {
  const ClassicNavBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey.shade600,
      items: [
        NavigationItem(
          label: 'Feed',
          icon: const Icon(Icons.dynamic_feed),
          page: _buildMockPage(context, Colors.purple.shade50, 'Activity Feed'),
        ),
        NavigationItem(
          label: 'Post',
          icon: const Icon(Icons.add_box),
          // Example of a conditional action in the classic navbar
          onPress: () async {
            bool? proceed = await showDialog<bool>(
              context: context,
              builder:
                  (ctx) => AlertDialog(
                    title: const Text('Create Post?'),
                    content: const Text(
                      'Do you want to proceed to the creation screen?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Proceed'),
                      ),
                    ],
                  ),
            );
            return proceed; // Navigates only if the user pressed 'Proceed'
          },
          page: _buildMockPage(context, Colors.purple.shade100, 'Create Post'),
        ),
        NavigationItem(
          label: 'Settings',
          icon: const Icon(Icons.settings),
          page: _buildMockPage(context, Colors.purple.shade200, 'Settings'),
        ),
      ],
    );
  }
}

// ===========================================================================
// UTILITY: MOCK PAGE BUILDER
// ===========================================================================
Widget _buildMockPage(BuildContext context, Color color, String title) {
  return Scaffold(
    backgroundColor: color,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed:
            () => Navigator.of(context).pop(), // Allow popping back to the menu
      ),
    ),
    body: Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    ),
  );
}
