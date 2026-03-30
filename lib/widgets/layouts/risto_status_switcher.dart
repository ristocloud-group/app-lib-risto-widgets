import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// Semantic UI states for the Status Switcher.
enum RistoUiState { loading, content, empty, error }

class RistoStatusSwitcher extends StatelessWidget {
  final RistoUiState state;
  final WidgetBuilder contentBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? errorBuilder;
  final String? defaultEmptyTitle;
  final String? defaultEmptySubtitle;
  final String? defaultErrorTitle;
  final String? defaultErrorSubtitle;
  final VoidCallback? onRetry;
  final Duration duration;
  final Alignment alignment;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Clip clipBehavior;

  const RistoStatusSwitcher({
    super.key,
    required this.state,
    required this.contentBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.defaultEmptyTitle = 'No data available',
    this.defaultEmptySubtitle,
    this.defaultErrorTitle = 'An error occurred',
    this.defaultErrorSubtitle,
    this.onRetry,
    this.duration = const Duration(milliseconds: 400),
    this.alignment = Alignment.topCenter,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 16.0,
    this.elevation,
    this.shadowColor,
    this.clipBehavior = Clip.none,
  });

  factory RistoStatusSwitcher.computed({
    Key? key,
    bool isLoading = false,
    bool hasError = false,
    bool isEmpty = false,
    required WidgetBuilder contentBuilder,
    WidgetBuilder? loadingBuilder,
    WidgetBuilder? emptyBuilder,
    WidgetBuilder? errorBuilder,
    String? defaultEmptyTitle,
    String? defaultEmptySubtitle,
    String? defaultErrorTitle,
    String? defaultErrorSubtitle,
    VoidCallback? onRetry,
    Duration duration = const Duration(milliseconds: 400),
    Alignment alignment = Alignment.topCenter,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderRadius = 16.0,
    double? elevation,
    Color? shadowColor,
    Clip clipBehavior = Clip.none,
  }) {
    RistoUiState derivedState = RistoUiState.content;
    if (isLoading) {
      derivedState = RistoUiState.loading;
    } else if (hasError) {
      derivedState = RistoUiState.error;
    } else if (isEmpty) {
      derivedState = RistoUiState.empty;
    }

    return RistoStatusSwitcher(
      key: key,
      state: derivedState,
      contentBuilder: contentBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
      errorBuilder: errorBuilder,
      defaultEmptyTitle: defaultEmptyTitle,
      defaultEmptySubtitle: defaultEmptySubtitle,
      defaultErrorTitle: defaultErrorTitle,
      defaultErrorSubtitle: defaultErrorSubtitle,
      onRetry: onRetry,
      duration: duration,
      alignment: alignment,
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      elevation: elevation,
      shadowColor: shadowColor,
      clipBehavior: clipBehavior,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentChild;

    switch (state) {
      case RistoUiState.loading:
        currentChild =
            loadingBuilder?.call(context) ??
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
        break;
      case RistoUiState.empty:
        currentChild =
            emptyBuilder?.call(context) ??
            RistoNoticeCard.empty(
              title: defaultEmptyTitle,
              subtitle: defaultEmptySubtitle,
              compact: true,
            );
        break;
      case RistoUiState.error:
        currentChild =
            errorBuilder?.call(context) ??
            RistoNoticeCard.error(
              title: defaultErrorTitle,
              subtitle: defaultErrorSubtitle,
              compact: true,
              footerBuilder: onRetry != null
                  ? (ctx, color) => CustomActionButton.rounded(
                      onPressed: onRetry,
                      backgroundColor: color,
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: const Text('Retry'),
                    )
                  : null,
            );
        break;
      case RistoUiState.content:
        currentChild = contentBuilder(context);
        break;
    }

    final keyedChild = KeyedSubtree(key: ValueKey(state), child: currentChild);

    final switcher = AnimatedSize(
      duration: duration,
      curve: Curves.easeOutExpo,
      alignment: alignment,
      clipBehavior: Clip.none,
      child: AnimatedSwitcher(
        duration: (duration * 2) ~/ 3,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: alignment,
            clipBehavior: Clip.none,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: keyedChild,
      ),
    );

    return RoundedContainer(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      backgroundColor: backgroundColor ?? Colors.transparent,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      elevation: elevation ?? 0.0,
      shadowColor: shadowColor,
      clipBehavior: clipBehavior,
      child: switcher,
    );
  }
}
