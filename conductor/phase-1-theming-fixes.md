# Phase 1: Theming & Compliance Fixes

## Objective
Standardize UI widgets to use `Theme.of(context)` for all default colors, removing hardcoded values as per `GEMINI.md`.

## Key Files
- `lib/widgets/feedback/risto_toast.dart`
- `lib/widgets/buttons/custom_action_button.dart`
- `lib/widgets/navigation/custom_nav_bars.dart`

## Implementation Steps

### 1. RistoToast Refactoring
- **Goal:** Remove `Colors.blue.shade800`, `Colors.green.shade700`, etc.
- **Changes:**
  - Create a private `_ToastDefaults` class.
  - Implement a static `_defaultsForKind(BuildContext context, ToastKind kind)` method inside `RistoToast` to return a `_ToastDefaults` object.
  - Update `info`, `success`, `warning`, and `error` methods to use these defaults if no override is provided.
  - Ensure `backgroundColor` and `textColor` in `show()` have sensible theme-aware fallbacks.

### 2. CustomActionButton Refactoring
- **Goal:** Replace hardcoded `Colors.white` and `Colors.black` fallbacks.
- **Changes:**
  - Update `_effectiveTextStyle` to use `theme.colorScheme.onPrimary` (for elevated/rounded) or `theme.colorScheme.primary` (for minimal/flat) as appropriate.
  - Ensure `shadowColor` defaults to `theme.colorScheme.shadow`.
  - Update factory constructors to remove hardcoded default colors where they conflict with theme-based logic.

### 3. BubbleBottomNavBar Refactoring
- **Goal:** Remove fixed blue `0xFF155FA0` and `Colors.grey`.
- **Changes:**
  - In `_buildItem`, derive `activeBackgroundColor` from `theme.colorScheme.primary` if null.
  - Derive `activeIconColor` from `theme.colorScheme.onPrimary`.
  - Derive `inactiveIconColor` from `theme.colorScheme.onSurfaceVariant` or `theme.disabledColor`.
  - Update `BoxShadow` to use `theme.colorScheme.shadow` with low opacity.

## Verification & Testing
- **Automated Tests:** Run `flutter test` to ensure existing tests still pass.
- **Visual Verification:** Use the `example` app to verify that all widgets correctly adapt to different themes (Light/Dark).
- **Static Analysis:** Run `flutter analyze` to ensure no new warnings are introduced.
