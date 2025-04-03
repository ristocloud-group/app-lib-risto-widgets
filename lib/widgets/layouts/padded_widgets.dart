import 'package:flutter/material.dart';

/// A customizable wrapper that applies padding to its child widget.
///
/// The [PaddingWrapper] widget simplifies the application of padding around a child widget.
/// It provides multiple factory constructors to handle different padding configurations,
/// such as uniform padding on all sides, symmetric padding, or padding on specific sides.
///
/// Example usage:
/// ```dart
/// PaddingWrapper.all(
///   padding: 20.0,
///   child: Text('Padded Text'),
/// );
/// ```
class PaddingWrapper extends StatelessWidget {
  /// The widget below this widget in the tree.
  ///
  /// Typically, this is the content that requires padding.
  final Widget child;

  /// The padding to apply around the [child].
  ///
  /// Defaults to 16.0 logical pixels on all sides.
  final EdgeInsetsGeometry padding;

  /// Creates a [PaddingWrapper] with customizable padding.
  ///
  /// The [child] parameter is required and must not be null.
  /// The [padding] parameter defaults to 16.0 pixels on all sides if not specified.
  const PaddingWrapper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0), // Default padding value
  });

  /// Factory constructor for applying the same padding to all sides.
  ///
  /// The [padding] parameter specifies the uniform padding to apply.
  ///
  /// Example usage:
  /// ```dart
  /// PaddingWrapper.all(
  ///   padding: 20.0,
  ///   child: Text('Uniformly Padded Text'),
  /// );
  /// ```
  factory PaddingWrapper.all({
    required Widget child,
    double padding = 16.0,
  }) {
    return PaddingWrapper(
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }

  /// Factory constructor for symmetric padding (vertical and horizontal).
  ///
  /// The [vertical] and [horizontal] parameters specify the padding for vertical
  /// and horizontal sides, respectively.
  ///
  /// Example usage:
  /// ```dart
  /// PaddingWrapper.symmetric(
  ///   vertical: 10.0,
  ///   horizontal: 20.0,
  ///   child: Text('Symmetrically Padded Text'),
  /// );
  /// ```
  factory PaddingWrapper.symmetric({
    required Widget child,
    double vertical = 16.0,
    double horizontal = 16.0,
  }) {
    return PaddingWrapper(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: child,
    );
  }

  /// Factory constructor for specific padding on each side.
  ///
  /// Allows setting padding individually for the left, right, top, and bottom sides.
  ///
  /// Example usage:
  /// ```dart
  /// PaddingWrapper.only(
  ///   left: 10.0,
  ///   right: 20.0,
  ///   top: 5.0,
  ///   bottom: 15.0,
  ///   child: Text('Custom Side Padded Text'),
  /// );
  /// ```
  factory PaddingWrapper.only({
    required Widget child,
    double left = 16.0,
    double right = 16.0,
    double top = 0.0,
    double bottom = 0.0,
  }) {
    return PaddingWrapper(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: child,
    );
  }

  /// Factory constructor for horizontal padding only.
  ///
  /// Applies padding to the left and right sides while leaving the top and bottom unpadded.
  ///
  /// Example usage:
  /// ```dart
  /// PaddingWrapper.horizontal(
  ///   horizontal: 25.0,
  ///   child: Text('Horizontally Padded Text'),
  /// );
  /// ```
  factory PaddingWrapper.horizontal({
    required Widget child,
    double horizontal = 16.0,
  }) {
    return PaddingWrapper(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: child,
    );
  }

  /// Factory constructor for vertical padding only.
  ///
  /// Applies padding to the top and bottom sides while leaving the left and right unpadded.
  ///
  /// Example usage:
  /// ```dart
  /// PaddingWrapper.vertical(
  ///   vertical: 30.0,
  ///   child: Text('Vertically Padded Text'),
  /// );
  /// ```
  factory PaddingWrapper.vertical({
    required Widget child,
    double vertical = 16.0,
  }) {
    return PaddingWrapper(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// A customizable list with padded children, providing default or custom padding.
///
/// The [PaddedChildrenList] widget is designed to display a vertical list of widgets
/// with consistent padding. It offers multiple factory constructors to handle different
/// padding configurations, ensuring flexibility in various layout scenarios.
///
/// Example usage:
/// ```dart
/// PaddedChildrenList.symmetric(
///   vertical: 10.0,
///   horizontal: 20.0,
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
/// );
/// ```
class PaddedChildrenList extends StatelessWidget {
  /// The list of child widgets to display.
  ///
  /// These widgets are arranged vertically within the list.
  final List<Widget> children;

  /// The padding to apply around the entire list.
  ///
  /// Defaults to 16.0 pixels on the left, right, and bottom sides.
  final EdgeInsetsGeometry padding;

  /// The alignment of the children along the main axis (vertical).
  ///
  /// Defaults to [MainAxisAlignment.start], aligning children to the top.
  final MainAxisAlignment mainAxisAlignment;

  /// The alignment of the children along the cross axis (horizontal).
  ///
  /// Defaults to [CrossAxisAlignment.start], aligning children to the start (left).
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a [PaddedChildrenList] with customizable padding and alignment.
  ///
  /// The [children] parameter is required and must not be null.
  /// The [padding] parameter defaults to 16.0 pixels on the left, right, and bottom sides
  /// if not specified.
  /// The [mainAxisAlignment] and [crossAxisAlignment] parameters control the alignment
  /// of the child widgets within the list.
  const PaddedChildrenList({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Factory constructor for default padding (all sides equal).
  ///
  /// Applies the same padding value to all sides of the list.
  ///
  /// Example usage:
  /// ```dart
  /// PaddedChildrenList.all(
  ///   padding: 20.0,
  ///   children: [
  ///     Text('Item 1'),
  ///     Text('Item 2'),
  ///     Text('Item 3'),
  ///   ],
  /// );
  /// ```
  factory PaddedChildrenList.all({
    required List<Widget> children,
    double padding = 16.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return PaddedChildrenList(
      padding: EdgeInsets.all(padding),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  /// Factory constructor for symmetric padding (vertical and horizontal).
  ///
  /// Applies different padding values for vertical and horizontal sides.
  ///
  /// Example usage:
  /// ```dart
  /// PaddedChildrenList.symmetric(
  ///   vertical: 10.0,
  ///   horizontal: 20.0,
  ///   children: [
  ///     Text('Item 1'),
  ///     Text('Item 2'),
  ///     Text('Item 3'),
  ///   ],
  /// );
  /// ```
  factory PaddedChildrenList.symmetric({
    required List<Widget> children,
    double vertical = 16.0,
    double horizontal = 16.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return PaddedChildrenList(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  /// Factory constructor for custom padding (only specific sides).
  ///
  /// Allows setting padding individually for the left, right, top, and bottom sides.
  ///
  /// Example usage:
  /// ```dart
  /// PaddedChildrenList.only(
  ///   left: 10.0,
  ///   right: 20.0,
  ///   top: 5.0,
  ///   bottom: 15.0,
  ///   children: [
  ///     Text('Item 1'),
  ///     Text('Item 2'),
  ///     Text('Item 3'),
  ///   ],
  /// );
  /// ```
  factory PaddedChildrenList.only({
    required List<Widget> children,
    double left = 16.0,
    double right = 16.0,
    double top = 0.0,
    double bottom = 16.0, // Ensure the bottom defaults to 16.0
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return PaddedChildrenList(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
