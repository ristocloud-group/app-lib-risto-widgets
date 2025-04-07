import 'dart:ui';

import 'package:flutter/material.dart';

// TODO: Update this import path if necessary for your project structure
import '../layouts/size_reporting_widget.dart';

/// A Flutter widget that displays content in a card that can be tapped to
/// animate its expansion into a detailed overlay view.
///
/// The transition includes animating the card's bounds from its original position
/// to a larger view covering a significant portion of the screen, accompanied by
/// a fading background scrim and header. The dismissal is also animated.
class ExpandableAnimatedCard extends StatefulWidget {
  /// A builder function for the widget's appearance when collapsed.
  /// This is the initial view that the user taps.
  final WidgetBuilder collapsedBuilder;

  /// A builder function for the widget's appearance when expanded in the overlay.
  /// This typically shows more detailed content.
  final WidgetBuilder expandedBuilder;

  /// The total duration of the expansion and collapse animations.
  final Duration animationDuration;

  /// The curve that controls the rate of change for the card's size and position
  /// animation during expansion and collapse.
  final Curve animationCurve;

  /// The interval of the animation duration during which the background scrim
  /// and header fade in or out. Allows the fade effect to occur during a
  /// specific portion of the main expansion/collapse animation.
  /// For example, `Interval(0.4, 1.0)` means the fade occurs between 40% and 100%
  /// of the [animationDuration].
  final Interval fadeInterval;

  /// The vertical margin applied *inside* the expanded card's boundaries
  /// during the animation, creating a padding effect that interpolates from 0.
  final double verticalMargin;

  /// The margin reserved at the bottom of the screen for the final expanded
  /// position of the card. Useful for avoiding overlap with bottom navigation
  /// bars or other persistent UI elements.
  final double bottomMargin;

  /// The background color of the expanded card's content area.
  final Color backgroundColor;

  /// The border radius applied to the corners of the expanded card.
  final BorderRadius borderRadius;

  /// The height of the header displayed at the top of the overlay when expanded.
  final double headerHeight;

  /// The color of the text and icons within the default header.
  final Color headerTextColor;

  /// The background color of the default header.
  final Color headerBackgroundColor;

  /// The title text displayed in the default header.
  final String headerTitle;

  /// The text style applied to the [headerTitle] in the default header.
  final TextStyle headerTextStyle;

  /// The icon data for the leading icon button in the default header
  /// (typically a back or close icon).
  final IconData headerIcon;

  /// The size of the icon specified by [headerIcon].
  final double headerIconSize;

  /// The color of the semi-transparent background scrim that fades in behind
  /// the expanded card overlay.
  final Color overlayBackgroundColor;

  /// An optional builder function to provide a custom header widget instead of
  /// the default one. It receives the [BuildContext] and a `closeCallback`
  /// function that *must* be called to initiate the overlay dismissal.
  final Widget Function(BuildContext context, VoidCallback closeCallback)?
      headerBuilder;

  /// An optional callback function that is invoked *after* the overlay route
  /// has been popped (dismissed). Useful for performing cleanup or state updates.
  final VoidCallback? onClose;

  /// An optional callback invoked just before the overlay route is pushed.
  /// If provided, the widget will not push the route itself, allowing the caller
  /// to manage the navigation (e.g., using a different navigator or transition).
  /// The callback receives the overlay widget instance that should be pushed.
  final void Function(Widget overlayWidget)? onShowOverlay;

  /// Creates an instance of [ExpandableAnimatedCard].
  ///
  /// Requires [collapsedBuilder] and [expandedBuilder]. All other parameters
  /// have default values.
  const ExpandableAnimatedCard({
    super.key,
    required this.collapsedBuilder,
    required this.expandedBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
    this.fadeInterval =
        const Interval(0.4, 1.0, curve: Cubic(0.5, 0.0, 0.3, 1.0)),
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
    this.headerIcon = Icons.arrow_back_ios_new,
    this.headerIconSize = 18.0,
    this.overlayBackgroundColor = Colors.black54,
    this.headerBuilder,
    this.onClose,
    this.onShowOverlay,
  });

  @override
  State<ExpandableAnimatedCard> createState() => _ExpandableAnimatedCardState();
}

/// The state associated with the [ExpandableAnimatedCard] widget.
/// Manages the size reporting of the collapsed widget and handles triggering
/// the overlay display.
class _ExpandableAnimatedCardState extends State<ExpandableAnimatedCard> {
  /// The measured size of the collapsed widget, used to determine the starting
  /// rectangle for the expansion animation.
  Size? _widgetSize;

  /// A global key attached to the collapsed widget to find its position and size.
  final GlobalKey _widgetKey = GlobalKey();

  /// Calculates the initial position and size, builds the overlay widget,
  /// and pushes a [PageRouteBuilder] route to display the expansion animation.
  ///
  /// If [widget.onShowOverlay] is provided, it calls that instead of pushing
  /// the route directly.
  void _showOverlay() {
    final currentContext = _widgetKey.currentContext;
    // Ensure the widget has been laid out and has a measurable size.
    if (_widgetSize != null &&
        currentContext != null &&
        currentContext.mounted) {
      final navigator = Navigator.of(currentContext);
      final RenderBox? box = currentContext.findRenderObject() as RenderBox?;
      // Ensure the RenderBox is available.
      if (box == null) return;

      // Find the nearest navigator ancestor to calculate the global position correctly.
      final RenderObject? navigatorRenderObject =
          navigator.context.findRenderObject();
      if (navigatorRenderObject == null) return;

      // Get the global position of the collapsed widget relative to the navigator.
      final Offset position =
          box.localToGlobal(Offset.zero, ancestor: navigatorRenderObject);

      // Define the starting rectangle for the animation.
      final Rect initialRect = Rect.fromLTWH(
        position.dx,
        position.dy,
        _widgetSize!.width,
        _widgetSize!.height,
      );

      // Create the internal widget that handles the overlay's appearance and animation.
      final overlayWidget = _ExpandableAnimatedOverlay(
        initialRect: initialRect,
        headerHeight: widget.headerHeight,
        backgroundColor: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        detailsMargin: widget.verticalMargin,
        expandedBuilder: widget.expandedBuilder,
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
        animationCurve: widget.animationCurve,
      );

      // Create a non-opaque route with a transparent barrier.
      // The overlayWidget itself handles the background scrim and transitions.
      final route = PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        // Internal widget handles scrim
        transitionDuration: widget.animationDuration,
        reverseTransitionDuration: widget.animationDuration,
        pageBuilder: (context, animation, secondaryAnimation) => overlayWidget,
        // No transitionsBuilder needed here as animations are internal to overlayWidget
      );

      // Either push the route or delegate to the onShowOverlay callback.
      if (widget.onShowOverlay != null) {
        widget.onShowOverlay!(overlayWidget);
      } else {
        navigator.push(route);
      }
    } else {
      // Log a warning if the overlay cannot be shown (e.g., widget not laid out yet).
      debugPrint("ExpandableAnimatedCard: Cannot show overlay. "
          "Widget size: $_widgetSize, Context: $currentContext, Mounted: ${currentContext?.mounted}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TickerMode can potentially optimize by pausing animations in the collapsed
    // widget when the overlay is active, though its effect might be minimal here.
    return TickerMode(
      enabled: true, // Keep tickers enabled for the collapsed view
      child: GestureDetector(
        key: _widgetKey,
        // Assign key to measure the widget
        onTap: _showOverlay,
        // Trigger expansion on tap
        // Use SizeReportingWidget to get the dimensions of the collapsedBuilder content.
        child: SizeReportingWidget(
          onSizeChange: (size) {
            // Update the measured size state variable after the frame is built.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check if the widget is still mounted before calling setState.
              if (mounted && _widgetSize != size) {
                setState(() {
                  _widgetSize = size;
                });
              }
            });
          },
          // Build the collapsed view provided by the user.
          child: widget.collapsedBuilder(context),
        ),
      ),
    );
  }
}

/// Internal widget responsible for rendering the animated overlay.
///
/// This widget is pushed onto the Navigator stack via a [PageRouteBuilder].
/// It uses the route's animation controller to drive the expansion/collapse
/// animation of the card bounds, the background scrim fade, and the header fade.
class _ExpandableAnimatedOverlay extends StatefulWidget {
  /// The initial rectangle (position and size) where the animation starts,
  /// corresponding to the collapsed card's bounds.
  final Rect initialRect;

  /// The height of the header area.
  final double headerHeight;

  /// The background color of the expanding card content area.
  final Color backgroundColor;

  /// The border radius for the expanding card.
  final BorderRadius borderRadius;

  /// The target vertical margin inside the card during animation.
  final double detailsMargin;

  /// Builder for the expanded content displayed inside the card.
  final WidgetBuilder expandedBuilder;

  /// The curve applied to the card's expansion/collapse animation.
  final Curve animationCurve;

  /// The interval defining when the background and header fade occurs.
  final Interval fadeInterval;

  /// Text color for the default header.
  final Color headerTextColor;

  /// Background color for the default header.
  final Color headerBackgroundColor;

  /// Title for the default header.
  final String headerTitle;

  /// Text style for the default header title.
  final TextStyle headerTextStyle;

  /// Icon for the default header's leading button.
  final IconData headerIcon;

  /// Size for the default header's icon.
  final double headerIconSize;

  /// Color for the background scrim.
  final Color overlayBackgroundColor;

  /// Optional builder for a custom header widget.
  final Widget Function(BuildContext, VoidCallback)? headerBuilder;

  /// Callback invoked after the overlay is popped.
  final VoidCallback? onClose;

  /// Bottom margin for the final expanded card position.
  final double bottomMargin;

  /// Creates an [_ExpandableAnimatedOverlay].
  const _ExpandableAnimatedOverlay({
    required this.initialRect,
    required this.headerHeight,
    required this.backgroundColor,
    required this.borderRadius,
    required this.detailsMargin,
    required this.expandedBuilder,
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
    // No key needed as it's typically instantiated uniquely per overlay push
  });

  @override
  _ExpandableAnimatedOverlayState createState() =>
      _ExpandableAnimatedOverlayState();
}

/// State for the [_ExpandableAnimatedOverlay]. Manages the closing action and
/// builds the animated elements based on the route's animation progress.
class _ExpandableAnimatedOverlayState
    extends State<_ExpandableAnimatedOverlay> {
  /// Initiates the pop action on the current route and calls the [widget.onClose]
  /// callback if provided.
  void _closeOverlay() {
    // Ensure the widget is still in the tree before interacting with Navigator.
    if (mounted) {
      Navigator.of(context).pop(); // Pop the overlay route
      widget.onClose?.call(); // Call the optional callback
    }
  }

  /// Builds the default header widget with a leading icon button and title.
  Widget _buildDefaultHeader(BuildContext context) {
    // Use Material to ensure proper theme and ink effects for IconButton.
    return Material(
      type: MaterialType.transparency, // Avoids drawing its own background
      child: Container(
        color: widget.headerBackgroundColor, // Set header background
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close/Back button
            IconButton(
              iconSize: widget.headerIconSize,
              icon: Icon(
                widget.headerIcon,
                color: widget.headerTextColor,
              ),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: _closeOverlay, // Trigger dismissal
            ),
            const SizedBox(width: 8), // Spacing between icon and title
            // Title text that takes remaining space
            Expanded(
              child: Text(
                widget.headerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Handle long titles
                style: widget.headerTextStyle.copyWith(
                  color: widget.headerTextColor, // Apply text color
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
    // Get the animation controller provided by the PageRouteBuilder/ModalRoute.
    // This drives all animations within the overlay.
    final Animation<double> animation = ModalRoute.of(context)!.animation!;

    // Get screen size and safe area padding for layout calculations.
    final Size screenSize = MediaQuery.sizeOf(context);
    final EdgeInsets safePadding = MediaQuery.paddingOf(context);

    // Calculate the target rectangle for the fully expanded card.
    final Rect finalRect = Rect.fromLTWH(
      safePadding.left + 16, // Horizontal padding
      safePadding.top + widget.headerHeight,
      // Position below safe area & header
      screenSize.width - safePadding.left - safePadding.right - 32, // Width
      screenSize.height -
          safePadding.top -
          safePadding.bottom -
          widget.headerHeight -
          widget.bottomMargin, // Height adjusted for margins/safe areas
    );
    // The starting rectangle is passed from the state of the collapsed widget.
    final Rect initialRect = widget.initialRect;

    // Create derived animations for fading elements based on the fadeInterval.
    final Animation<double> backgroundFadeAnimation = animation.drive(
      CurveTween(curve: widget.fadeInterval),
    );
    final Animation<double> headerFadeAnimation = animation.drive(
      CurveTween(curve: widget.fadeInterval),
    );

    // NOTE: Based on user edits, we are using Material + Container for background.
    // If background issues persist, consider ModalBarrier again.
    return Material(
      color: Colors.transparent,
      // Ensure Material itself doesn't draw a background
      child: Stack(
        children: [
          // 1. Background Scrim Layer
          Positioned.fill(
            child: FadeTransition(
              opacity: backgroundFadeAnimation,
              // Use a simple Container for the background color.
              child: Container(
                color: widget.overlayBackgroundColor,
              ),
            ),
          ),

          // 2. Animated Card Content Layer
          AnimatedBuilder(
            animation: animation,
            // Listen to the main animation progress
            builder: (context, child) {
              // Apply the specific curve for the card expansion/collapse.
              final double curveValue =
                  widget.animationCurve.transform(animation.value);

              // Interpolate the card's bounds (position and size).
              final Rect currentRect =
                  Rect.lerp(initialRect, finalRect, curveValue)!;

              // Interpolate the internal vertical margin.
              final double currentDetailsMargin =
                  lerpDouble(0, widget.detailsMargin, curveValue) ?? 0;

              // Position the animated container.
              return Positioned(
                left: currentRect.left,
                top: currentRect.top,
                width: currentRect.width,
                height: currentRect.height,
                // Apply the animated padding inside the positioned container.
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: currentDetailsMargin),
                  child:
                      child!, // The actual content container (ClipRRect > Container > builder)
                ),
              );
            },
            // The non-animated part of the content layer (structure remains constant).
            child: ClipRRect(
              borderRadius: widget.borderRadius, // Apply rounded corners
              child: Container(
                color: widget.backgroundColor, // Set card background
                // Build the user-provided expanded content.
                child: widget.expandedBuilder(context),
              ),
            ),
          ),

          // 3. Header Layer
          Positioned(
            left: 0,
            right: 0,
            top: safePadding.top,
            // Position below top safe area
            height: widget.headerHeight,
            child: FadeTransition(
              opacity: headerFadeAnimation, // Apply fade animation to header
              // Display custom or default header.
              child: widget.headerBuilder != null
                  ? widget.headerBuilder!(context, _closeOverlay)
                  : _buildDefaultHeader(context),
            ),
          ),
        ],
      ),
    );
  }
}
