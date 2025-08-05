import 'package:flutter/material.dart';
// Assuming your widgets are in this library/file
import 'package:risto_widgets/risto_widgets.dart';

/// A playground for your refactored SectionSwitcher and SegmentedControl widgets.
class NavigationWidgetPage extends StatelessWidget {
  const NavigationWidgetPage({super.key});

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
      // The old `indicatorShadow` is now handled by Card's elevation.
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
              'SectionSwitcher Example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SectionSwitcher(
              items: demoItems,
              segmentedHeight: 50,
              segmentedMargin: const EdgeInsets.only(bottom: 16),
              segmentedControlStyle: customSegmentedControlStyle,
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
          ],
        ),
      ),
    );
  }
}
