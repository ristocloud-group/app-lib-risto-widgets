import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';
import 'package:risto_widgets_example/pages/infinite_snap_list_page.dart';
import 'package:risto_widgets_example/pages/navigation_widget_page.dart';
import 'package:risto_widgets_example/pages/percent_indicators_page.dart';
import 'package:risto_widgets_example/pages/risto_toast_page.dart';

// Import the pages
import 'pages/action_button_page.dart';
import 'pages/custom_sheet_page.dart';
import 'pages/expandable_page.dart';
import 'pages/increment_decrement_page.dart';
import 'pages/list_tile_button_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Widgets Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<NavigationItem> _navigationItems = [];

  @override
  void initState() {
    super.initState();

    _navigationItems.addAll([
      const NavigationItem(
        page: IncrementDecrementPage(),
        icon: Icon(Icons.home),
        label: 'Increment/Decrement',
      ),
      const NavigationItem(
        page: ActionButtonPage(),
        icon: Icon(Icons.search),
        label: 'Action Buttons',
      ),
      const NavigationItem(
        page: ListTileButtonPage(),
        icon: Icon(Icons.list),
        label: 'List Tile Buttons',
      ),
      const NavigationItem(
        page: ExpandablePage(),
        icon: Icon(Icons.expand),
        label: 'Expandable',
      ),
      const NavigationItem(
        page: CustomSheetPage(),
        icon: Icon(Icons.open_in_new),
        label: 'Custom Sheets',
      ),
      const NavigationItem(
        page: InfiniteSnapDemoPage(),
        icon: Icon(Icons.repeat),
        label: 'Infinite Snap List',
      ),
      const NavigationItem(
        page: NavigationWidgetPage(),
        icon: Icon(Icons.swap_horiz),
        label: 'Nav Switcher',
      ),
      const NavigationItem(
        page: RistoToastPage(),
        icon: Icon(Icons.notification_important),
        label: 'RistoToast',
      ),
      const NavigationItem(
        page: PercentIndicatorsPage(),
        icon: Icon(Icons.pie_chart),
        label: 'Percent Indicators',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Widgets Demo')),
      body: CustomBottomNavBar(
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.blue,
        elevation: 8.0,
        itemPadding: const EdgeInsets.all(5),
        items: _navigationItems,
      ),
    );
  }
}
