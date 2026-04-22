import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/custom_action_button.dart';
import '../layouts/risto_decorator.dart';

/// Semantic variations for the RistoNoticeCard.
enum RistoNoticeKind { info, success, warning, error, neutral, empty }

/// Builder for the footer area of the card, passing down the semantic accent color.
typedef RistoFooterBuilder =
    Widget Function(BuildContext context, Color accentColor);

/// A standardized, highly customizable card used to display semantic notices.
class RistoNoticeCard extends StatelessWidget {
  final RistoNoticeKind kind;
  final String? title;
  final String? subtitle;
  final List<InlineSpan>? subtitleSpan;
  final int titleMaxLines;
  final int subtitleMaxLines;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final RistoFooterBuilder? footerBuilder;
  final AlignmentGeometry? footerAlignment;
  final EdgeInsetsGeometry? footerPadding;
  final bool compact;
  final bool showClose;
  final VoidCallback? onClose;
  final bool invert;
  final Color? accentColor;
  final Widget? noticeIcon;

  /// Padding applied specifically around the icon.
  final EdgeInsetsGeometry? iconPadding;

  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
  final double borderOpacity;
  final BorderRadiusGeometry? borderRadius;

  /// The internal padding between the card's edges and its content.
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? shadowColor;
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final double? height;
  final double? minHeight;
  final double? maxHeight;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  /// The unified vertical spacing between the icon, title, subtitle, and footer.
  final double? runSpacing;

  const RistoNoticeCard({
    super.key,
    required this.kind,
    this.title,
    this.subtitle,
    this.subtitleSpan,
    this.titleMaxLines = 2,
    this.subtitleMaxLines = 10,
    this.titleStyle,
    this.subtitleStyle,
    this.footerBuilder,
    this.footerAlignment,
    this.footerPadding,
    this.compact = false,
    this.showClose = false,
    this.onClose,
    this.invert = false,
    this.accentColor,
    this.noticeIcon,
    this.iconPadding,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderOpacity = 0.5,
    this.borderRadius,
    this.padding,
    this.margin,
    this.elevation,
    this.shadowColor,
    this.width,
    this.minWidth,
    this.maxWidth,
    this.height,
    this.minHeight,
    this.maxHeight,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.runSpacing,
  });

  factory RistoNoticeCard.info({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  factory RistoNoticeCard.success({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  factory RistoNoticeCard.warning({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.warning,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  factory RistoNoticeCard.error({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  factory RistoNoticeCard.empty({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.empty,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  factory RistoNoticeCard.neutral({
    Key? key,
    String? title,
    String? subtitle,
    List<InlineSpan>? subtitleSpan,
    bool compact = false,
    bool showClose = false,
    VoidCallback? onClose,
    bool invert = false,
    RistoFooterBuilder? footerBuilder,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    Widget? noticeIcon,
    EdgeInsetsGeometry? iconPadding,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? borderColor,
    double borderWidth = 1.0,
    double borderOpacity = 0.5,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? minWidth,
    double? maxWidth,
    double? height,
    double? minHeight,
    double? maxHeight,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? runSpacing,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.neutral,
      title: title,
      subtitle: subtitle,
      subtitleSpan: subtitleSpan,
      compact: compact,
      showClose: showClose,
      onClose: onClose,
      invert: invert,
      footerBuilder: footerBuilder,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      noticeIcon: noticeIcon,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      elevation: elevation,
      shadowColor: shadowColor,
      width: width,
      minWidth: minWidth,
      maxWidth: maxWidth,
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      crossAxisAlignment: crossAxisAlignment,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      runSpacing: runSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaults = _defaultsForKind(theme, kind);
    final resolvedAccentColor = accentColor ?? defaults.accent;
    final resolvedRadius = borderRadius ?? BorderRadius.circular(16);
    final resolvedPadding = padding ?? const EdgeInsets.all(24);

    final resolvedTitleStyle =
        theme.textTheme.titleMedium?.merge(titleStyle) ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        );

    final resolvedSubtitleStyle =
        theme.textTheme.bodyMedium?.merge(subtitleStyle) ??
        TextStyle(
          fontSize: 14,
          color: theme.colorScheme.onSurface.withCustomOpacity(0.7),
        );

    final effectiveTextAlign = crossAxisAlignment == CrossAxisAlignment.start
        ? TextAlign.left
        : crossAxisAlignment == CrossAxisAlignment.end
        ? TextAlign.right
        : TextAlign.center;

    final double effectiveRunSpacing = runSpacing ?? (compact ? 12 : 24);

    Widget? resolvedIcon = noticeIcon;
    if (resolvedIcon == null && defaults.iconData != null) {
      resolvedIcon = Icon(
        defaults.iconData,
        size: compact ? 36 : 56,
        color: resolvedAccentColor,
      );
    }

    if (resolvedIcon != null && iconPadding != null) {
      resolvedIcon = Padding(padding: iconPadding!, child: resolvedIcon);
    }

    Widget? headerWidget;
    if (title != null) {
      headerWidget = Text(
        title!,
        style: resolvedTitleStyle,
        textAlign: effectiveTextAlign,
        maxLines: titleMaxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget? bodyWidget;
    if (subtitleSpan != null) {
      bodyWidget = RichText(
        textAlign: effectiveTextAlign,
        maxLines: subtitleMaxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(style: resolvedSubtitleStyle, children: subtitleSpan),
      );
    } else if (subtitle != null) {
      bodyWidget = Text(
        subtitle!,
        style: resolvedSubtitleStyle,
        textAlign: effectiveTextAlign,
        maxLines: subtitleMaxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget? footerWidget;
    if (footerBuilder != null) {
      final defaultAlign = crossAxisAlignment == CrossAxisAlignment.start
          ? Alignment.centerLeft
          : crossAxisAlignment == CrossAxisAlignment.end
          ? Alignment.centerRight
          : Alignment.center;

      footerWidget = Align(
        alignment: footerAlignment ?? defaultAlign,
        child: Padding(
          padding: footerPadding ?? EdgeInsets.only(top: compact ? 4.0 : 16.0),
          child: footerBuilder!(context, resolvedAccentColor),
        ),
      );
    }

    final List<Widget> bodyContent = [];
    if (invert) {
      if (headerWidget != null) bodyContent.add(headerWidget);
      if (headerWidget != null && resolvedIcon != null) {
        bodyContent.add(SizedBox(height: effectiveRunSpacing));
      }
      if (resolvedIcon != null) bodyContent.add(resolvedIcon);
    } else {
      if (resolvedIcon != null) bodyContent.add(resolvedIcon);
      if (resolvedIcon != null && headerWidget != null) {
        bodyContent.add(SizedBox(height: effectiveRunSpacing));
      }
      if (headerWidget != null) bodyContent.add(headerWidget);
    }

    if (bodyWidget != null) {
      if (bodyContent.isNotEmpty) {
        // Tighter grouping between title and subtitle
        bodyContent.add(SizedBox(height: effectiveRunSpacing / 2));
      }
      bodyContent.add(bodyWidget);
    }

    if (footerWidget != null) {
      if (bodyContent.isNotEmpty) {
        bodyContent.add(SizedBox(height: effectiveRunSpacing));
      }
      bodyContent.add(footerWidget);
    }

    final cardShell = RistoDecorator(
      margin: margin,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      borderRadius: resolvedRadius,
      borderColor: borderColor?.withCustomOpacity(borderOpacity),
      borderWidth: borderWidth,
      elevation: elevation ?? 0.0,
      shadowColor: shadowColor,
      padding: resolvedPadding,
      child: Column(
        mainAxisSize: (minHeight != null || maxHeight != null)
            ? MainAxisSize.max
            : MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: bodyContent,
      ),
    );

    Widget finalLayout = cardShell;
    if (showClose) {
      finalLayout = Stack(
        clipBehavior: Clip.none,
        children: [
          cardShell,
          Positioned(
            right: 8,
            top: 8,
            child: CustomActionButton.iconOnly(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              size: 40,
              baseType: ButtonType.minimal,
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.onSurface.withCustomOpacity(
                0.6,
              ),
              elevation: 0,
            ),
          ),
        ],
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: finalLayout,
    );
  }

  static _KindDefaults _defaultsForKind(ThemeData theme, RistoNoticeKind kind) {
    final cs = theme.colorScheme;
    switch (kind) {
      case RistoNoticeKind.success:
        return _KindDefaults(
          accent: Colors.green.shade600,
          iconData: Icons.check_circle_outline,
        );
      case RistoNoticeKind.warning:
        return _KindDefaults(
          accent: Colors.orange.shade700,
          iconData: Icons.warning_amber_rounded,
        );
      case RistoNoticeKind.error:
        return _KindDefaults(
          accent: cs.error,
          iconData: Icons.error_outline_rounded,
        );
      case RistoNoticeKind.info:
        return _KindDefaults(
          accent: cs.primary,
          iconData: Icons.info_outline_rounded,
        );
      case RistoNoticeKind.neutral:
        return _KindDefaults(
          accent: cs.onSurface.withCustomOpacity(0.8),
          iconData: Icons.feed_outlined,
        );
      case RistoNoticeKind.empty:
        return _KindDefaults(
          accent: cs.secondary,
          iconData: Icons.inbox_outlined,
        );
    }
  }
}

class _KindDefaults {
  final Color accent;
  final IconData? iconData;

  _KindDefaults({required this.accent, this.iconData});
}
