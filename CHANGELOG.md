## 0.3.0

**New Widgets & Features**

- **RistoTextField:** Introduced a standardized input widget with specialized factories (`.search`,
  `.password`, `.email`, `.number`).
- **SnapList & InfiniteSnapList:** Extracted core logic into a finite `SnapList` with `.carousel`
  and `.picker` factories. Added `SnapScrollPhysics`, `SnapBehavior`, and `SnapListDotIndicator`.
- **InteractiveMap:** Added new map integration widget.
- **State & Loading Management:** Introduced `LoadingPanel` (including an `.asOverlay` factory) and
  `StatusSwitcher`.
- **RistoDecorator:** Added a universal styling wrapper for standardizing backgrounds, borders, and
  shadows.
- **RistoShimmer:** Unified skeleton loading with new factories (`.block`, `.circle`, `.textLines`),
  replacing the legacy `RistoSkeleton`.
- **Navigation:** Added a new Bubble Navigation Bar style.
- **ExpandableAccordionGroup:** Added a controller manager to ensure only one expandable tile opens
  at a time.

**Enhancements & Refactoring**

- **ExpandableAnimatedCard:** Added the `.menu` factory to support floating, anchored overlay menus.
- **ExpandableListTileButton:** Added `headerDisabled` state, constrained sizing, and rebuilt the
  layout engine for flawless corner radii and shadow rendering.
- **OpenCustomDialog:** Added `barrierDismissible`, `barrierColor`, `useRootNavigator`,
  `useSafeArea`, `onConfirm`, and opening animations.
- **Dependencies:** Updated `package_info_plus`, `geolocator_linux`, and `font_awesome_flutter`.

**Fixes**

- Fixed `onItemSelected` callbacks not triggering on programmatic jumps in snap lists.
- Fixed scroll velocity limits and snapping alignment in `InfiniteSnapList`.
- Fixed alignment, shadow clipping, and stack rendering issues across expandable widgets.
- Expanded widget tests and example pages to cover all new factories and edge cases.

## 0.2.2

- Improve `ExpandableListTileButton` to handle bottom inerts.
- Solved `CustomActionButton` bugs.
- Updated tests files.
- Solved multiples bug and enhance the already existing widgets.

## 0.2.1

- Improve `CustomBottomNavBar` to handle `onPress` action.
- Improve `CustomActionButton` by adding new `iconOnly` factory.
- Solved `CustomActionButton` bugs.
- Enhanced documentation across all major classes and widgets.
- Solved multiples bug and enhance the already existing widgets.

## 0.2.0

- Added `RistoToast` widget with multiple factory constructors (`info`, `success`, `warning`,
  `error`, `neutral`, `empty`).
- Added `RistoNoticeCard` widget with multiple static function (`info`, `success`, `warning`,
  `error`).
- Added `LinearPercentIndicator` widget.
- Added `CircularPercentIndicator` widget.
- Added `OpenCustomDialog` with factory constructors `custom` and `notice`, supporting
  `RistoNoticeCard` as body.
- Improved `CustomActionButton` with the new `rounded` and `icon` factory constructors.
- Improved `CustomActionButton` and `ListTileButton` widgets with additional customization options.
- Added `SinglePressButton` widget with factory constructors (`rounded`).
- Added `InfiniteSnapList` widget and `InfiniteSnapListController` for manage SnapList states.
- Added `SizeReportingWidget` for getting widget size.
- Added `SectionSwitcher` with `SegmentedControl` and `SegmentedControlStyle`.
- Enhanced documentation across all major classes and widgets.
- Solved multiples bug and enhance the already existing widgets.

## 0.1.0

- Added `PaddingWrapper` widget with multiple factory constructors (`all`, `symmetric`, `only`,
  `horizontal`, `vertical`).
- Added `PaddedChildrenList` widget for vertical lists with consistent padding and factory
  constructors.
- Introduced `NavigationItem` class and `CustomBottomNavBar` for customizable bottom navigation
  integrated with `PageView`.
- Enhanced `OpenCustomSheet` with factory constructors `openConfirmSheet` and `scrollableSheet`,
  supporting customizable appearance and optional default buttons.
- Added `DoubleListTileButtons` widget for arranging two buttons side by side with customizable
  spacing.
- Improved `CustomActionButton` and `ListTileButton` widgets with additional customization options.
- Updated `IncrementDecrementWidget` with `typedef ValueUpdate = dynamic Function(int updateValue);`
  for flexible callback handling.
- Enhanced documentation across all major classes and widgets.

## 0.0.5

- Update ExpandableListTileButton.

## 0.0.4

- Update actions.

## 0.0.3

- Update dependencies.

## 0.0.2

- Refactoring.

## 0.0.1

- **Expandable ListTile Button:** Combines an expandable panel with a custom list tile button for
  interactive headers and bodies.
- **Increment/Decrement Widget:** Allows increasing or decreasing a value with customizable buttons
  and dynamic display.
- **Custom Action Button:** Versatile button with various styling options for different contexts.
- **ListTile Button:** Customizable list tile button with support for leading icons, titles,
  subtitles, and trailing widgets.
- **Open Custom Sheet:** Displays customizable bottom sheets for presenting modal content.