import 'dart:ui';

import 'package:flutter/material.dart';

import '../layouts/size_reporting_widget.dart';

/// A widget that displays an animated expansion of content, featuring
/// both a collapsed view and an expanded view defined via [WidgetBuilder]s.
///
/// The [ExpandableAnimatedCard] is highly customizable in terms of animation,
/// layout, and styling. It can be adapted to various use cases where a smooth,
/// fluid expansion effect is desired.
class ExpandableAnimatedCard extends StatefulWidget {
  /// The builder for the collapsed (initial) view of the card.
  final WidgetBuilder collapsedBuilder;

  /// The builder for the expanded view of the card.
  final WidgetBuilder expandedBuilder;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  /// The curve that defines the animation's easing.
  final Curve animationCurve;

  /// The interval used to drive the fade-in effect for the header and background.
  final Interval fadeInterval;

  /// The vertical margin applied between the card's content.
  final double verticalMargin;

  /// The bottom margin to accommodate navigation or other UI elements.
  final double bottomMargin;

  /// The background color of the card when it is expanded.
  final Color backgroundColor;

  /// The border radius of the card when it is expanded.
  final BorderRadius borderRadius;

  /// The height of the header shown during the expansion.
  final double headerHeight;

  /// The text color used in the header.
  final Color headerTextColor;

  /// The background color of the header.
  final Color headerBackgroundColor;

  /// The title displayed in the header.
  final String headerTitle;

  /// The text style for the header title.
  final TextStyle headerTextStyle;

  /// The icon displayed in the header.
  final IconData headerIcon;

  /// The size of the header icon.
  final double headerIconSize;

  /// The background color for the overlay that appears during expansion.
  final Color overlayBackgroundColor;

  /// An optional custom header builder. If provided, it overrides the default header.
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  /// Callback invoked when the overlay is closed.
  final VoidCallback onClose;

  /// Callback invoked when the overlay is shown, providing the overlay widget.
  final void Function(Widget overlay)? onShowOverlay;

  /// Creates an [ExpandableAnimatedCard] with the specified parameters.
  const ExpandableAnimatedCard({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
    this.fadeInterval = const Interval(0.8, 1.0, curve: Curves.easeIn),
    this.verticalMargin = 12.0,
    this.bottomMargin = 76.0,
    this.backgroundColor = const Color(0xFF5D5D5D),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.headerHeight = 40.0,
    this.headerTextColor = const Color(0xFF424242),
    this.headerBackgroundColor = Colors.white,
    this.headerTitle = "Details",
    this.headerTextStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    this.headerIcon = Icons.arrow_back,
    this.headerIconSize = 15.0,
    this.overlayBackgroundColor = Colors.white,
    this.headerBuilder,
    required this.onClose,
    this.onShowOverlay,
  });

  @override
  State<ExpandableAnimatedCard> createState() => _ExpandableAnimatedCardState();
}

class _ExpandableAnimatedCardState extends State<ExpandableAnimatedCard> {
  Size? _widgetSize;
  final GlobalKey _widgetKey = GlobalKey();

  /// Displays the expanded overlay starting from the current position of this widget.
  ///
  /// The overlay is built using [_ExpandableAnimatedOverlay] and is pushed onto the
  /// Navigator. If an [onShowOverlay] callback is provided, it is invoked with the
  /// overlay widget.
  void _showOverlay() {
    if (_widgetSize != null) {
      final RenderBox box =
          _widgetKey.currentContext!.findRenderObject() as RenderBox;
      final Offset position = box.localToGlobal(Offset.zero);
      final Rect initialRect = Rect.fromLTWH(
        position.dx,
        position.dy,
        _widgetSize!.width,
        _widgetSize!.height,
      );
      final overlayWidget = _ExpandableAnimatedOverlay(
        initialRect: initialRect,
        headerHeight: widget.headerHeight,
        backgroundColor: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        detailsMargin: widget.verticalMargin,
        expandedBuilder: widget.expandedBuilder,
        animationDuration: widget.animationDuration,
        animationCurve: widget.animationCurve,
        fadeInterval: widget.fadeInterval,
        headerTextColor: widget.headerTextColor,
        headerBackgroundColor: widget.headerBackgroundColor,
        headerTitle: widget.headerTitle,
        headerTextStyle: widget.headerTextStyle,
        headerIcon: widget.headerIcon,
        headerIconSize: widget.headerIconSize,
        overlayBackgroundColor: widget.overlayBackgroundColor,
        onClose: widget.onClose,
        bottomMargin: widget.bottomMargin,
        headerBuilder: widget.headerBuilder,
      );
      if (widget.onShowOverlay != null) {
        widget.onShowOverlay!(overlayWidget);
      } else {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (context, animation, secondaryAnimation) =>
              overlayWidget,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _widgetKey,
      onTap: _showOverlay,
      child: SizeReportingWidget(
        onSizeChange: (size) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_widgetSize != size) {
              setState(() {
                _widgetSize = size;
              });
            }
          });
        },
        child: widget.collapsedBuilder(context),
      ),
    );
  }
}

/// An internal widget that displays the animated overlay with expanded content.
///
/// The overlay covers the screen (respecting Safe Area insets) and animates from an
/// initial rectangle (corresponding to the collapsed widget) to a final rectangle
/// computed based on screen size and Safe Area.
class _ExpandableAnimatedOverlay extends StatefulWidget {
  /// The initial rectangle of the widget before expansion.
  final Rect initialRect;

  /// The height of the header.
  final double headerHeight;

  /// The background color for the expanded container.
  final Color backgroundColor;

  /// The border radius for the expanded container.
  final BorderRadius borderRadius;

  /// The vertical margin applied to the expanded content.
  final double detailsMargin;

  /// The builder for the expanded view.
  final WidgetBuilder expandedBuilder;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  /// The animation curve.
  final Curve animationCurve;

  /// The interval used for the fade-in effect.
  final Interval fadeInterval;

  /// The text color for the header.
  final Color headerTextColor;

  /// The background color for the header.
  final Color headerBackgroundColor;

  /// The title displayed in the header.
  final String headerTitle;

  /// The text style for the header title.
  final TextStyle headerTextStyle;

  /// The icon displayed in the header.
  final IconData headerIcon;

  /// The size of the header icon.
  final double headerIconSize;

  /// The background color of the overlay.
  final Color overlayBackgroundColor;

  /// An optional custom header builder that overrides the default header.
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  /// Callback invoked when the overlay is closed.
  final VoidCallback onClose;

  /// The bottom margin to accommodate navigation or other UI elements.
  final double bottomMargin;

  /// Creates an [_ExpandableAnimatedOverlay] with the specified parameters.
  const _ExpandableAnimatedOverlay({
    required this.initialRect,
    required this.headerHeight,
    required this.backgroundColor,
    required this.borderRadius,
    required this.detailsMargin,
    required this.expandedBuilder,
    required this.animationDuration,
    required this.animationCurve,
    required this.fadeInterval,
    required this.headerTextColor,
    required this.headerBackgroundColor,
    required this.headerTitle,
    required this.headerTextStyle,
    required this.headerIcon,
    required this.headerIconSize,
    required this.overlayBackgroundColor,
    required this.onClose,
    required this.bottomMargin,
    this.headerBuilder,
  });

  @override
  _ExpandableAnimatedOverlayState createState() =>
      _ExpandableAnimatedOverlayState();
}

class _ExpandableAnimatedOverlayState extends State<_ExpandableAnimatedOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    // Start the animation on the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the default header if no custom header is provided.
  ///
  /// The header displays an icon button (to close the overlay) and a title.
  Widget _buildDefaultHeader(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: widget.headerBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: widget.headerIconSize,
              icon: Icon(
                widget.headerIcon,
                color: widget.headerTextColor,
              ),
              onPressed: () {
                _controller.reverse().then((_) {
                  widget.onClose();
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  widget.headerTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.headerTextStyle.copyWith(
                    color: widget.headerTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final EdgeInsets safePadding = MediaQuery.of(context).padding;

    // Calculate the final rectangle for the expansion animation, accounting for Safe Area insets.
    final Rect finalRect = Rect.fromLTWH(
      safePadding.left + 16,
      safePadding.top + widget.headerHeight,
      screenSize.width - safePadding.left - safePadding.right - 32,
      screenSize.height -
          safePadding.top -
          safePadding.bottom -
          widget.headerHeight -
          widget.bottomMargin,
    );
    final Rect initialRect = widget.initialRect;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background with a fade-in animation.
          Positioned.fill(
            child: FadeTransition(
              opacity: _controller.drive(
                Tween<double>(begin: 0, end: 1).chain(
                  CurveTween(curve: widget.fadeInterval),
                ),
              ),
              child: Container(color: widget.overlayBackgroundColor),
            ),
          ),
          // Header positioned within the Safe Area.
          Positioned(
            left: 0,
            right: 0,
            top: safePadding.top,
            height: widget.headerHeight,
            child: FadeTransition(
              opacity: _controller.drive(
                Tween<double>(begin: 0, end: 1).chain(
                  CurveTween(curve: widget.fadeInterval),
                ),
              ),
              child: widget.headerBuilder != null
                  ? widget.headerBuilder!(
                      context,
                      () {
                        _controller.reverse().then((_) {
                          Navigator.of(context).pop();
                          widget.onClose();
                        });
                      },
                    )
                  : _buildDefaultHeader(context),
            ),
          ),
          // Animated expanded content.
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double curveValue =
                  widget.animationCurve.transform(_controller.value);
              final Rect currentRect =
                  Rect.lerp(initialRect, finalRect, curveValue)!;
              return Positioned(
                left: currentRect.left,
                top: currentRect.top,
                width: currentRect.width,
                height: currentRect.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical:
                        lerpDouble(0, widget.detailsMargin, curveValue) ?? 0,
                  ),
                  child: child!,
                ),
              );
            },
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Container(
                color: widget.backgroundColor,
                child: widget.expandedBuilder(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
