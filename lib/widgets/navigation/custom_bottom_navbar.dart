import 'package:flutter/material.dart';

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
  /// If provided, this function will be called instead of navigating to the [page].
  /// This is useful for items that trigger actions, such as opening a dialog,
  /// without changing the currently displayed page.
  final VoidCallback? onPress;

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
///     onPress: () {
///       // Show a dialog instead of navigating
///       showDialog(context: context, builder: (_) => MyDialog());
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
  ///
  /// Initialized to `0`, representing the first item in the [widget.items] list.
  int _selectedIndex = 0;

  /// Controller for managing page transitions in the [PageView].
  ///
  /// Prevents users from swiping between pages manually by setting
  /// [physics] to [NeverScrollableScrollPhysics].
  final PageController pageController = PageController();

  /// Handles taps on navigation items.
  ///
  /// If the tapped item has a custom `onPress` action, it is executed.
  /// Otherwise, it animates the [PageView] to the selected page and updates the selected index.
  void _onItemTapped(int index) {
    final tappedItem = widget.items[index];

    if (tappedItem.onPress != null) {
      // If a custom action exists, execute it and do not change the page.
      tappedItem.onPress!();
    } else {
      // Otherwise, perform the default page navigation.
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme's BottomNavigationBarThemeData.
    final bottomNavBarTheme = Theme.of(context).bottomNavigationBarTheme;

    return Scaffold(
      // The main content area that displays the selected page.
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        // Disables swipe navigation.
        children: widget.items.map((e) => e.page).toList(),
      ),
      // The bottom navigation bar wrapped in a styled Card.
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
            // Allows Card's color to show.
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
