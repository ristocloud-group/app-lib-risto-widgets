import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// A playground for your NavSwitcher widget.
class NavigationWidgetPage extends StatelessWidget {
  const NavigationWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demoItems = <NavigationItem>[
      NavigationItem(
        page: Container(height: 200, color: Colors.red),
        icon: const Icon(Icons.stop),
        label: 'Red',
      ),
      NavigationItem(
        page: Container(height: 1000, color: Colors.green),
        icon: const Icon(Icons.stop),
        label: 'Green',
      ),
      NavigationItem(
        page: Container(height: 500, color: Colors.blueAccent),
        icon: const Icon(Icons.stop),
        label: 'Blue',
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Navigation Widget Playground'),

          SectionSwitcher(
            items: demoItems,
            segmentedBackgroundColor: Colors.grey.shade100,
            segmentedIndicatorColor: Colors.white,
            segmentedIndicatorShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            segmentedIndicatorMargin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 2,
            ),
            segmentedUnselectedTextStyle: TextStyle(color: Colors.blueGrey),
            segmentedSelectedTextStyle: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text('Navigation Widget Playground'),
        ],
      ),
    );
  }
}
