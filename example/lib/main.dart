import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

import 'pages/action_button_page.dart';
import 'pages/custom_dialog_page.dart';
import 'pages/custom_sheet_page.dart';
import 'pages/expandable_page.dart';
import 'pages/increment_decrement_page.dart';
import 'pages/infinite_snap_list_page.dart';
import 'pages/inputs_page.dart';
import 'pages/list_tile_button_page.dart';
import 'pages/loading_overlay_page.dart';
import 'pages/navigation_widget_page.dart';
import 'pages/percent_indicators_page.dart';
import 'pages/risto_notice_card_page.dart';
import 'pages/risto_toast_page.dart';
import 'pages/shimmer_page.dart';
import 'pages/status_switcher_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risto Widgets Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      home: const HomePage(),
    );
  }
}

/// A simple data class to hold our routing information
class _DemoRoute {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  const _DemoRoute({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Centralized list of all demo routes. Infinitely scalable!
  static const List<_DemoRoute> _routes = [
    _DemoRoute(
      title: 'Inputs',
      subtitle: 'RistoTextField forms and layouts',
      icon: Icons.text_fields,
      page: InputsPage(),
    ),
    _DemoRoute(
      title: 'Shimmers & Skeletons',
      subtitle: 'Animated loading placeholders',
      icon: Icons.gradient,
      page: ShimmerPage(),
    ),
    _DemoRoute(
      title: 'Status Switcher',
      subtitle: 'Bloc-driven state views (Loading, Error, Content)',
      icon: Icons.switch_access_shortcut,
      page: StatusSwitcherPage(),
    ),
    _DemoRoute(
      title: 'Loading Overlay',
      subtitle: 'Global and Local blurred loading barriers',
      icon: Icons.blur_on,
      page: LoadingOverlayPage(),
    ),
    _DemoRoute(
      title: 'Notice Cards',
      subtitle: 'Semantic info, success, warning, and error cards',
      icon: Icons.note_alt_outlined,
      page: RistoNoticeCardPage(),
    ),
    _DemoRoute(
      title: 'RistoToast',
      subtitle: 'Animated floating snackbar alternatives',
      icon: Icons.notification_important,
      page: RistoToastPage(),
    ),
    _DemoRoute(
      title: 'Action Buttons',
      subtitle: 'Elevated, Flat, Minimal, Rounded & Icon buttons',
      icon: Icons.ads_click,
      page: ActionButtonPage(),
    ),
    _DemoRoute(
      title: 'List Tile Buttons',
      subtitle: 'Customizable cards acting as buttons',
      icon: Icons.view_list,
      page: ListTileButtonPage(),
    ),
    _DemoRoute(
      title: 'Expandable',
      subtitle: 'Expandable tiles and custom overlay menus',
      icon: Icons.expand,
      page: ExpandablePage(),
    ),
    _DemoRoute(
      title: 'Custom Sheets',
      subtitle: 'Draggable bottom sheets',
      icon: Icons.call_to_action,
      page: CustomSheetPage(),
    ),
    _DemoRoute(
      title: 'Custom Dialogs',
      subtitle: 'Alerts and confirmation dialogs',
      icon: Icons.present_to_all_sharp,
      page: CustomDialogPage(),
    ),
    _DemoRoute(
      title: 'Infinite Snap List',
      subtitle: 'Horizontal & vertical snapping lists',
      icon: Icons.repeat,
      page: InfiniteSnapDemoPage(),
    ),
    _DemoRoute(
      title: 'Increment / Decrement',
      subtitle: 'Number steppers and selectors',
      icon: Icons.add_circle_outline,
      page: IncrementDecrementPage(),
    ),
    _DemoRoute(
      title: 'Percent Indicators',
      subtitle: 'Circular and linear progress',
      icon: Icons.pie_chart,
      page: PercentIndicatorsPage(),
    ),
    _DemoRoute(
      title: 'Nav Switcher',
      subtitle: 'Segmented controls and tabs',
      icon: Icons.swap_horiz,
      page: NavigationWidgetPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risto Component Library')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _routes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final route = _routes[index];

          // Using your own component to build the menu!
          return IconListTileButton(
            icon: route.icon,
            title: Text(
              route.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              route.subtitle,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            iconColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            elevation: 2.0,
            borderRadius: 12.0,
            leadingSizeFactor: 1.2,
            trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => route.page),
              );
            },
          );
        },
      ),
    );
  }
}
