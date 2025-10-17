import 'package:flutter/material.dart';

/// A callback function for a navigation item action.
///
/// It can return a `Future<bool?>`. If it returns `true`, the default
/// page navigation will proceed after the action is complete. If it returns
/// `false` or `null`, only the action will be performed.
typedef NavigationActionCallback = Future<bool?> Function();

/// Represents an individual navigation item within the [CustomBottomNavBar].
///
/// The [NavigationItem] class encapsulates the information required for each
/// item in the bottom navigation bar, including the target page, icon, label,
/// and an optional custom action.
class NavigationItem {
  /// The page to navigate to when this item is selected.
  ///
  /// This should be a widget that represents the content associated with the navigation item.
  /// It is still required even if an `onPress` action is provided, as the [PageView]
  /// needs a widget for every index.
  final Widget page;

  /// The icon to display for this navigation item.
  ///
  /// Typically, this is an [Icon] widget that visually represents the item's purpose.
  final Icon icon;

  /// The label text for this navigation item.
  ///
  /// This text appears below the icon and provides a descriptive name for the item.
  final String label;

  /// An optional callback to execute when the item is tapped.
  ///
  /// If this function returns `true`, the default page navigation will occur
  /// after the action completes. If it returns `false` or `null`, the
  /// navigation is prevented.
  final NavigationActionCallback? onPress;

  /// Creates a [NavigationItem] with the specified properties.
  ///
  /// The [page], [icon], and [label] parameters are required.
  const NavigationItem({
    required this.page,
    required this.icon,
    required this.label,
    this.onPress,
  });
}

/// A customizable bottom navigation bar that manages navigation between different pages.
///
/// The [CustomBottomNavBar] widget provides a styled bottom navigation bar that allows
/// users to switch between various pages in the app. It integrates seamlessly with a
/// [PageView] to handle page transitions and maintains the selected index state.
///
/// **Example usage:**
/// ```dart
/// List<NavigationItem> navItems = [
///   NavigationItem(
///     page: HomePage(),
///     icon: Icon(Icons.home),
///     label: 'Home',
///   ),
///   NavigationItem(
///     page: SearchPage(), // A page is still needed for the PageView
///     icon: Icon(Icons.add_circle_outline),
///     label: 'Add',
///     onPress: () async {
///       // Show a dialog and decide whether to navigate based on the result.
///       final bool shouldNavigate = await showConfirmationDialog(context);
///       return shouldNavigate; // Returning true will also switch the page.
///     },
///   ),
///   NavigationItem(
///     page: ProfilePage(),
///     icon: Icon(Icons.person),
///     label: 'Profile',
///   ),
/// ];
///
/// CustomBottomNavBar(
///   items: navItems,
///   backgroundColor: Colors.white,
///   selectedItemColor: Colors.blue,
///   unselectedItemColor: Colors.grey,
/// );
/// ```
class CustomBottomNavBar extends StatefulWidget {
  /// A list of [NavigationItem]s to display in the bottom navigation bar.
  ///
  /// Each [NavigationItem] defines a page, icon, and label for a navigation tab.
  final List<NavigationItem> items;

  /// The background color of the bottom navigation bar.
  ///
  /// If not specified, it defaults to the theme's `colorScheme.surface`.
  final Color? backgroundColor;

  /// The color of the selected navigation item.
  ///
  /// If not specified, it defaults to the theme's `colorScheme.primary`.
  final Color? selectedItemColor;

  /// The color of the unselected navigation items.
  ///
  /// If not specified, it defaults to the theme's `unselectedWidgetColor`.
  final Color? unselectedItemColor;

  /// The elevation (shadow depth) of the bottom navigation bar.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.elevation`
  /// or `8.0` if the theme does not provide one.
  final double? elevation;

  /// The type of the bottom navigation bar.
  ///
  /// Determines the layout behavior of the items. If not specified, it defaults
  /// to the theme's `bottomNavigationBarTheme.type` or `BottomNavigationBarType.shifting`.
  final BottomNavigationBarType? type;

  /// The font size of the selected item's label.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.selectedLabelStyle.fontSize`
  /// or `14.0`.
  final double? selectedFontSize;

  /// The font size of the unselected items' labels.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.unselectedLabelStyle.fontSize`
  /// or `12.0`.
  final double? unselectedFontSize;

  /// Whether to show labels for the selected items.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.showSelectedLabels`
  /// or `true`.
  final bool? showSelectedLabels;

  /// Whether to show labels for the unselected items.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.showUnselectedLabels`
  /// or `true`.
  final bool? showUnselectedLabels;

  /// The icon theme for the selected navigation item.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.selectedIconTheme`
  /// or an [IconThemeData] with size `24.0`.
  final IconThemeData? selectedIconTheme;

  /// The icon theme for the unselected navigation items.
  ///
  /// If not specified, it defaults to the theme's `bottomNavigationBarTheme.unselectedIconTheme`
  /// or an [IconThemeData] with size `20.0`.
  final IconThemeData? unselectedIconTheme;

  /// The padding to apply around each navigation item's icon.
  ///
  /// If not specified, it defaults to `EdgeInsets.zero`.
  final EdgeInsetsGeometry? itemPadding;

  /// The external margin around the bottom navigation bar.
  ///
  /// If not specified, it defaults to `EdgeInsets.all(0)`.
  final EdgeInsetsGeometry? margin;

  /// Creates a [CustomBottomNavBar] with the specified properties.
  ///
  /// The [items] parameter is required and must contain at least two [NavigationItem]s.
  const CustomBottomNavBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.type,
    this.selectedFontSize,
    this.unselectedFontSize,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.itemPadding,
    this.margin,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  /// The index of the currently selected navigation item.
  int _selectedIndex = 0;

  /// Controller for managing page transitions in the [PageView].
  final PageController pageController = PageController();

  /// Switches the displayed page.
  void _navigateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Handles taps on navigation items.
  ///
  /// If the tapped item has a custom `onPress` action, it is executed. If the
  /// action returns `true`, the default navigation will also occur. Otherwise,
  /// only the action is performed. If no action is provided, it navigates directly.
  void _onItemTapped(int index) async {
    final tappedItem = widget.items[index];

    if (tappedItem.onPress != null) {
      // If a custom action exists, execute it and await its result.
      final bool? shouldNavigate = await tappedItem.onPress!();

      // Proceed with navigation ONLY if the action explicitly returns true.
      if (shouldNavigate == true) {
        _navigateToPage(index);
      }
    } else {
      // No custom action, so perform the default page navigation.
      _navigateToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBarTheme = Theme.of(context).bottomNavigationBarTheme;

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.items.map((e) => e.page).toList(),
      ),
      bottomNavigationBar: Card(
        margin: widget.margin ?? const EdgeInsets.all(0),
        elevation: widget.elevation ?? bottomNavBarTheme.elevation ?? 8.0,
        color:
            widget.backgroundColor ??
            bottomNavBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            type:
                widget.type ??
                bottomNavBarTheme.type ??
                BottomNavigationBarType.shifting,
            selectedItemColor:
                widget.selectedItemColor ??
                bottomNavBarTheme.selectedItemColor ??
                Theme.of(context).colorScheme.primary,
            unselectedItemColor:
                widget.unselectedItemColor ??
                bottomNavBarTheme.unselectedItemColor ??
                Theme.of(context).unselectedWidgetColor,
            selectedFontSize:
                widget.selectedFontSize ??
                bottomNavBarTheme.selectedLabelStyle?.fontSize ??
                14.0,
            unselectedFontSize:
                widget.unselectedFontSize ??
                bottomNavBarTheme.unselectedLabelStyle?.fontSize ??
                12.0,
            showSelectedLabels:
                widget.showSelectedLabels ??
                bottomNavBarTheme.showSelectedLabels ??
                true,
            showUnselectedLabels:
                widget.showUnselectedLabels ??
                bottomNavBarTheme.showUnselectedLabels ??
                true,
            selectedIconTheme:
                widget.selectedIconTheme ??
                bottomNavBarTheme.selectedIconTheme ??
                const IconThemeData(size: 24.0),
            unselectedIconTheme:
                widget.unselectedIconTheme ??
                bottomNavBarTheme.unselectedIconTheme ??
                const IconThemeData(size: 20.0),
            items: widget.items.map((item) {
              return BottomNavigationBarItem(
                icon: Container(
                  padding: widget.itemPadding ?? EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: item.icon,
                ),
                label: item.label,
              );
            }).toList(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
