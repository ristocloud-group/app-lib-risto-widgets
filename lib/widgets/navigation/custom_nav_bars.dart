import 'package:flutter/material.dart';

// ===========================================================================
// SHARED TYPES
// ===========================================================================

/// A callback function for a navigation item action.
/// Return `true` to proceed with page navigation, `false` or `null` to prevent it.
typedef NavigationActionCallback = Future<bool?> Function();

// ===========================================================================
// CLASSIC CUSTOM BOTTOM NAV BAR (Original Implementation)
// ===========================================================================

class NavigationItem {
  final Widget page;
  final Icon icon;
  final String label;
  final NavigationActionCallback? onPress;

  const NavigationItem({
    required this.page,
    required this.icon,
    required this.label,
    this.onPress,
  });
}

class CustomBottomNavBar extends StatefulWidget {
  final List<NavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final BottomNavigationBarType? type;
  final double? selectedFontSize;
  final double? unselectedFontSize;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? margin;

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
  int _selectedIndex = 0;
  final PageController pageController = PageController();

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

  void _onItemTapped(int index) async {
    final tappedItem = widget.items[index];
    if (tappedItem.onPress != null) {
      final bool? shouldNavigate = await tappedItem.onPress!();
      if (shouldNavigate == true) {
        _navigateToPage(index);
      }
    } else {
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

/// ===========================================================================
// BUBBLE BOTTOM NAV BAR (Split / Multiple Groups)
// ===========================================================================
class BubbleNavItem {
  /// The page to display. If null, this item acts purely as a trigger button (e.g. open a menu).
  final Widget? page;

  /// The default icon.
  final Widget? icon;

  /// The icon to show when selected (optional).
  final Widget? activeIcon;

  /// Tooltip label for accessibility.
  final String? label;

  /// Entirely overrides the bubble item UI (useful for avatars or complex widgets).
  final Widget? customWidget;

  /// Callback triggered on press. Return false/null to prevent page navigation.
  final NavigationActionCallback? onPress;

  const BubbleNavItem({
    this.page,
    this.icon,
    this.activeIcon,
    this.label,
    this.customWidget,
    this.onPress,
  }) : assert(
         icon != null || customWidget != null,
         'Must provide an icon or customWidget',
       );
}

class BubbleGroup {
  final List<BubbleNavItem> items;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<BoxShadow>? shadows;

  const BubbleGroup({
    required this.items,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.all(4.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 6.0),
    this.shadows,
  });
}

class BubbleBottomNavBar extends StatefulWidget {
  final List<BubbleGroup> groups;
  final Color? activeIconColor;
  final Color? inactiveIconColor;
  final Color? activeBackgroundColor;
  final Color? defaultGroupBackgroundColor;
  final int initialIndex;

  /// Set to true if you are displaying maps/images behind the navbar
  final bool extendBody;

  const BubbleBottomNavBar({
    super.key,
    required this.groups,
    this.activeIconColor = Colors.white,
    this.inactiveIconColor = Colors.grey,
    this.activeBackgroundColor = const Color(0xFF155FA0), // Standard deep blue
    this.defaultGroupBackgroundColor = Colors.white,
    this.initialIndex = 0,
    this.extendBody = true,
  });

  @override
  State<BubbleBottomNavBar> createState() => _BubbleBottomNavBarState();
}

class _BubbleBottomNavBarState extends State<BubbleBottomNavBar> {
  late int _selectedIndex;
  late PageController _pageController;

  late List<BubbleNavItem> _allItems;
  final List<Widget> _pages = [];

  // Maps the overall global index of the button to the PageView index
  final Map<int, int> _globalToPage = {};

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initItems();

    int initialPage = _globalToPage[_selectedIndex] ?? 0;
    _pageController = PageController(initialPage: initialPage);
  }

  void _initItems() {
    _allItems = widget.groups.expand((g) => g.items).toList();
    int pageIdx = 0;
    for (int i = 0; i < _allItems.length; i++) {
      if (_allItems[i].page != null) {
        _pages.add(_allItems[i].page!);
        _globalToPage[i] = pageIdx;
        pageIdx++;
      }
    }
  }

  void _onItemTapped(int index) async {
    final item = _allItems[index];
    bool shouldNavigate = true;

    if (item.onPress != null) {
      shouldNavigate = (await item.onPress!()) ?? false;
    }

    if (shouldNavigate && item.page != null) {
      int pageIndex = _globalToPage[index]!;
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int globalCounter = 0;

    return Scaffold(
      extendBody: widget.extendBody,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: widget.groups.map((group) {
              final groupWidget = _buildGroup(group, globalCounter);
              globalCounter += group.items.length;
              return groupWidget;
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(BubbleGroup group, int startIndex) {
    return Container(
      margin: group.margin,
      padding: group.padding,
      decoration: BoxDecoration(
        color: group.backgroundColor ?? widget.defaultGroupBackgroundColor,
        borderRadius: group.borderRadius ?? BorderRadius.circular(40),
        boxShadow:
            group.shadows ??
            [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: group.items.asMap().entries.map((entry) {
          int globalIdx = startIndex + entry.key;
          return _buildItem(entry.value, globalIdx);
        }).toList(),
      ),
    );
  }

  Widget _buildItem(BubbleNavItem item, int globalIndex) {
    if (item.customWidget != null) {
      return GestureDetector(
        onTap: () => _onItemTapped(globalIndex),
        child: item.customWidget!,
      );
    }

    bool isSelected = _selectedIndex == globalIndex;

    Widget iconWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isSelected ? widget.activeBackgroundColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: isSelected ? widget.activeIconColor : widget.inactiveIconColor,
          size: 28,
        ),
        child: isSelected ? (item.activeIcon ?? item.icon!) : item.icon!,
      ),
    );

    if (item.label != null) {
      iconWidget = Tooltip(message: item.label!, child: iconWidget);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(globalIndex),
      child: iconWidget,
    );
  }
}
