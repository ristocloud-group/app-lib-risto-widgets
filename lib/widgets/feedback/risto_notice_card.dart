import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/custom_action_button.dart';

enum RistoNoticeKind { info, success, warning, error, neutral, empty }

/// Footer builder type, providing the card's accent color
typedef RistoFooterBuilder = Widget Function(
    BuildContext context, Color accentColor);

class RistoNoticeCard extends StatelessWidget {
  /// The semantic type of the notice (success, warning, etc.).
  /// This determines the default color and icon.
  final RistoNoticeKind kind;

  /// The main title of the notice.
  final String title;

  /// The secondary text displayed below the title.
  final String? subtitle;

  final int titleMaxLines;
  final int subtitleMaxLines;

  /// Custom [TextStyle] for the title. Merged with the default theme style.
  final TextStyle? titleStyle;

  /// Custom [TextStyle] for the subtitle. Merged with the default theme style.
  final TextStyle? subtitleStyle;

  /// A builder function to create a custom footer widget, typically for buttons.
  final RistoFooterBuilder? footerBuilder;

  /// Controls the alignment of the footer widget.
  /// If null, the footer takes the alignment of the column.
  final AlignmentGeometry? footerAlignment;

  /// Padding applied to the footer widget. Defaults to no padding.
  final EdgeInsetsGeometry? footerPadding;

  /// A flag to explicitly control the footer's visibility.
  /// If false, the footer will be hidden even if [footerBuilder] is provided.
  /// Defaults to true.
  final bool showFooter;

  /// An optional widget to display as the header icon.
  /// Overrides the default icon for the specified [kind].
  /// This can be an [Icon], [Image], or any other widget.
  final Widget? noticeIcon;

  /// Whether to display the icon. Defaults to `true`.
  final bool showIcon;

  /// A color to override the default accent color for the specified [kind].
  final Color? accentColor;

  /// Whether to show the top-right close button.
  final bool showClose;

  /// A callback triggered when the close button is tapped.
  final VoidCallback? onClose;

  /// The horizontal alignment of the content within the card.
  /// Defaults to [CrossAxisAlignment.center]. Use [CrossAxisAlignment.start]
  /// for a left-aligned layout.
  final CrossAxisAlignment crossAxisAlignment;

  /// If true, reduces vertical spacing for a more compact layout.
  /// Defaults to false.
  final bool compact;

  /// The vertical spacing between elements in the card.
  /// Overrides [compact] defaults.
  final double? runSpacing;

  /// The minimum width of the card.
  final double? minWidth;

  /// The maximum width of the card.
  final double? maxWidth;

  /// The minimum height of the card.
  final double? minHeight;

  /// The maximum height of the card.
  final double? maxHeight;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  // Card styling
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;

  /// The opacity of the colored border. Defaults to `0.5`.
  final double borderOpacity;
  final double? elevation;
  final Color? shadowColor;

  // Anim
  final Duration layoutAnimDuration;
  final Curve layoutAnimCurve;

  const RistoNoticeCard({
    super.key,
    required this.kind,
    required this.title,
    this.subtitle,
    this.titleMaxLines = 2,
    this.subtitleMaxLines = 4,
    this.titleStyle,
    this.subtitleStyle,
    this.footerBuilder,
    this.footerAlignment,
    this.footerPadding,
    this.showFooter = true,
    this.showClose = false,
    this.onClose,
    this.noticeIcon,
    this.showIcon = true,
    this.accentColor,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.compact = false,
    this.runSpacing,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderOpacity = 0.5,
    this.elevation,
    this.shadowColor,
    this.layoutAnimDuration = const Duration(milliseconds: 180),
    this.layoutAnimCurve = Curves.easeInOut,
  });

  factory RistoNoticeCard.info({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  factory RistoNoticeCard.success({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  factory RistoNoticeCard.warning({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.warning,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  factory RistoNoticeCard.error({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  factory RistoNoticeCard.neutral({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.neutral,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  factory RistoNoticeCard.empty({
    Key? key,
    required String title,
    String? subtitle,
    Widget? noticeIcon,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool compact = false,
    bool showIcon = true,
    double? runSpacing,
    Color? accentColor,
    Color? backgroundColor,
    AlignmentGeometry? footerAlignment,
    EdgeInsetsGeometry? footerPadding,
    bool showFooter = true,
    double? minHeight,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? margin,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.empty,
      title: title,
      subtitle: subtitle,
      noticeIcon: noticeIcon,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      crossAxisAlignment: crossAxisAlignment,
      compact: compact,
      showIcon: showIcon,
      runSpacing: runSpacing,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      footerAlignment: footerAlignment,
      footerPadding: footerPadding,
      showFooter: showFooter,
      minHeight: minHeight,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = _defaultsForKind(theme, kind);
    final resolvedAccentColor = accentColor ?? d.accent;
    final r = borderRadius ?? BorderRadius.circular(16);
    final resolvedPadding =
        padding ?? const EdgeInsets.fromLTRB(24, 24, 24, 24);

    final TextAlign textAlign;
    switch (crossAxisAlignment) {
      case CrossAxisAlignment.start:
        textAlign = TextAlign.start;
        break;
      case CrossAxisAlignment.end:
        textAlign = TextAlign.end;
        break;
      default:
        textAlign = TextAlign.center;
    }

    // Use provided spacing values, or fall back to defaults based on `compact` flag.
    final finalRunSpacing = runSpacing ?? (compact ? 8.0 : 16.0);

    final Widget headerIcon;
    if (noticeIcon != null) {
      headerIcon = noticeIcon!;
    } else {
      switch (kind) {
        case RistoNoticeKind.success:
          headerIcon = Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: resolvedAccentColor,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check_rounded, color: Colors.white, size: 40),
          );
          break;
        default:
          headerIcon = Icon(d.icon, color: resolvedAccentColor, size: 48);
      }
    }

    Widget? footerWidget;
    if (showFooter && footerBuilder != null) {
      Widget footerContent = footerBuilder!(context, resolvedAccentColor);
      if (footerPadding != null) {
        footerContent = Padding(padding: footerPadding!, child: footerContent);
      }
      if (footerAlignment != null) {
        footerContent =
            Align(alignment: footerAlignment!, child: footerContent);
      }
      footerWidget = footerContent;
    }

    final List<Widget> children = [];
    if (showIcon) {
      children.add(headerIcon);
    }
    children.add(
      Text(
        title,
        textAlign: textAlign,
        style: theme.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold)
            .merge(titleStyle),
        maxLines: titleMaxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (subtitle != null && subtitle!.isNotEmpty) {
      children.add(
        Text(
          subtitle!,
          textAlign: textAlign,
          style: theme.textTheme.bodyLarge
              ?.copyWith(
                  color: theme.colorScheme.onSurface.withCustomOpacity(0.7))
              .merge(subtitleStyle),
          maxLines: subtitleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    if (footerWidget != null) {
      children.add(footerWidget);
    }

    final bodyContent = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      bodyContent.add(children[i]);
      if (i < children.length - 1) {
        bodyContent.add(SizedBox(height: finalRunSpacing));
      }
    }

    final cardShell = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        gradient: backgroundGradient,
        borderRadius: r,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        elevation: elevation ?? 0,
        shadowColor: shadowColor ?? theme.colorScheme.shadow,
        shape: RoundedRectangleBorder(borderRadius: r),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: resolvedPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: bodyContent,
          ),
        ),
      ),
    );

    Widget finalLayout = cardShell;
    if (showClose) {
      finalLayout = Stack(
        alignment: Alignment.topRight,
        children: [
          cardShell,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomActionButton.icon(
              icon: Icons.close_rounded,
              onPressed: onClose,
              baseType: ButtonType.rounded,
              size: 40,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconColor: theme.colorScheme.onSurface.withCustomOpacity(0.6),
            ),
          ),
        ],
      );
    }

    // Apply sizing constraints to the entire widget
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
          icon: Icons.check_circle_outline_rounded,
        );
      case RistoNoticeKind.warning:
        return _KindDefaults(
          accent: Colors.orange.shade700,
          icon: Icons.warning_amber_rounded,
        );
      case RistoNoticeKind.error:
        return _KindDefaults(
          accent: cs.error,
          icon: Icons.error_outline_rounded,
        );
      case RistoNoticeKind.info:
        return _KindDefaults(
          accent: cs.primary,
          icon: Icons.info_outline_rounded,
        );
      case RistoNoticeKind.neutral:
        return _KindDefaults(
          accent: cs.onSurface.withCustomOpacity(0.8),
          icon: Icons.info_outline_rounded,
        );
      case RistoNoticeKind.empty:
        return _KindDefaults(
          accent: cs.secondary,
          icon: Icons.inbox_outlined,
        );
    }
  }
}

class _KindDefaults {
  final Color accent;
  final IconData icon;

  const _KindDefaults({required this.accent, required this.icon});
}
