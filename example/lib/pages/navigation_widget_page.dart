import 'package:flutter/material.dart';
// Assuming your widgets are in this library/file
import 'package:risto_widgets/risto_widgets.dart';

/// A playground for your refactored SectionSwitcher and SegmentedControl widgets.
class NavigationWidgetPage extends StatefulWidget {
  const NavigationWidgetPage({super.key});

  @override
  State<NavigationWidgetPage> createState() => _NavigationWidgetPageState();
}

class _NavigationWidgetPageState extends State<NavigationWidgetPage> {
  // 1. Create the controller
  late final SectionSwitcherController _sectionSwitcherController;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the controller
    _sectionSwitcherController = SectionSwitcherController();
  }

  @override
  void dispose() {
    // 3. Dispose the controller to prevent memory leaks
    _sectionSwitcherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Demo items for the SectionSwitcher
    final demoItems = <NavigationItem>[
      NavigationItem(
        page: const Center(
          child: Text('Page 1: Red', style: TextStyle(fontSize: 24)),
        ),
        icon: const Icon(Icons.looks_one),
        label: 'Red',
      ),
      NavigationItem(
        page: const Center(
          child: Text('Page 2: Green', style: TextStyle(fontSize: 24)),
        ),
        icon: const Icon(Icons.looks_two),
        label: 'Green',
      ),
      NavigationItem(
        page: const Center(
          child: Text('Page 3: Blue', style: TextStyle(fontSize: 24)),
        ),
        icon: const Icon(Icons.looks_3),
        label: 'Blue',
      ),
    ];

    final customSegmentedControlStyle = SegmentedControl.styleFrom(
      backgroundColor: Colors.grey.shade200,
      indicatorColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(5),
      elevation: 0,
      indicatorElevation: 4,
      selectedTextStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      unselectedTextStyle: TextStyle(color: Colors.grey.shade600),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Playground')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'SectionSwitcher Example (with Controller)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SectionSwitcher(
              // 4. Pass the controller to the widget
              controller: _sectionSwitcherController,
              items: demoItems,
              segmentedHeight: 50,
              segmentedMargin: const EdgeInsets.only(bottom: 16),
              segmentedControlStyle: customSegmentedControlStyle,
              onPageChanged: (index) {
                debugPrint('Page changed to index: $index');
              },
            ),

            // 5. Add external buttons to control the SectionSwitcher
            const SizedBox(height: 16),
            const Text(
              'External Controls',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _sectionSwitcherController.goTo(0),
                  child: const Text('Go to Red'),
                ),
                ElevatedButton(
                  onPressed: () => _sectionSwitcherController.goTo(1),
                  child: const Text('Go to Green'),
                ),
                ElevatedButton(
                  onPressed: () => _sectionSwitcherController.goTo(2),
                  child: const Text('Go to Blue'),
                ),
              ],
            ),

            const Divider(height: 40),

            const Text(
              'Standalone SegmentedControl Example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: SegmentedControl(
                segments: const [
                  Text('Option A'),
                  Text('Option B'),
                  Text('Option C'),
                ],
                onSegmentSelected: (index) {
                  debugPrint('SegmentedControl selected index: $index');
                },
                style: customSegmentedControlStyle,
              ),
            ),
            const Divider(height: 40),

            const Text(
              'Standalone SegmentedControl Example single segment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: SegmentedControl(
                segments: const [Text('Option A')],
                onSegmentSelected: (index) {
                  debugPrint('SegmentedControl selected index: $index');
                },
                style: customSegmentedControlStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
