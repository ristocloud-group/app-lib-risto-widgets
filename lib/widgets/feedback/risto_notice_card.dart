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
  final AlignmentGeometry footerAlignment;
  final EdgeInsetsGeometry footerPadding;

  /// An optional icon to override the default for the specified [kind].
  final IconData? icon;

  /// A color to override the default accent color for the specified [kind].
  final Color? accentColor;

  /// Whether to show the top-right close button.
  final bool showClose;

  /// A callback triggered when the close button is tapped.
  final VoidCallback? onClose;

  final double? minHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool dense;
  final BorderRadius? borderRadius;

  /// The width of the colored stripe on the left.
  /// If null, it defaults to the corner radius.
  final double? stripeWidth;

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
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 2,
    this.titleStyle,
    this.subtitleStyle,
    this.footerBuilder,
    this.footerAlignment = Alignment.bottomRight,
    this.footerPadding = const EdgeInsets.only(top: 12),
    this.showClose = false,
    this.onClose,
    this.icon,
    this.accentColor,
    this.minHeight,
    this.padding,
    this.margin,
    this.dense = true,
    this.borderRadius,
    this.stripeWidth,
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
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  factory RistoNoticeCard.success({
    Key? key,
    required String title,
    String? subtitle,
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  factory RistoNoticeCard.warning({
    Key? key,
    required String title,
    String? subtitle,
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.warning,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  factory RistoNoticeCard.error({
    Key? key,
    required String title,
    String? subtitle,
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  factory RistoNoticeCard.neutral({
    Key? key,
    required String title,
    String? subtitle,
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.neutral,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  factory RistoNoticeCard.empty({
    Key? key,
    required String title,
    String? subtitle,
    int titleMaxLines = 1,
    int subtitleMaxLines = 2,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
    BorderRadius? borderRadius,
    double borderOpacity = 0.5,
    double? stripeWidth,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.empty,
      title: title,
      subtitle: subtitle,
      titleMaxLines: titleMaxLines,
      subtitleMaxLines: subtitleMaxLines,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
      borderRadius: borderRadius,
      borderOpacity: borderOpacity,
      stripeWidth: stripeWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = _defaultsForKind(theme, kind);
    final stripeColor = accentColor ?? d.accent;
    final leadingIcon = icon ?? d.icon;
    final r = borderRadius ?? BorderRadius.circular(12);
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 14);
    const gapTitleToSubtitle = 6.0;

    final innerLayout = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: stripeWidth ?? r.topLeft.x, color: stripeColor),
          Expanded(
            child: Padding(
              padding: resolvedPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(leadingIcon, color: stripeColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)
                              .merge(titleStyle),
                          maxLines: titleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if ((subtitle ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: gapTitleToSubtitle),
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withCustomOpacity(0.8),
                            )
                            .merge(subtitleStyle),
                        maxLines: subtitleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (footerBuilder != null) const Spacer(),
                  if (footerBuilder != null)
                    Align(
                      alignment: footerAlignment,
                      child: Padding(
                        padding: footerPadding,
                        child: footerBuilder!(context, stripeColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final cardShell = Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? theme.colorScheme.surface,
        elevation: elevation ?? (kind == RistoNoticeKind.error ? 1.5 : 0),
        shadowColor: shadowColor ?? theme.colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: r,
          side: BorderSide(
            color: borderColor ?? stripeColor.withCustomOpacity(borderOpacity),
            width: borderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: innerLayout,
      ),
    );

    if (!showClose) {
      return cardShell;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        cardShell,
        Positioned(
          top: 0,
          right: 0,
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

  static _KindDefaults _defaultsForKind(ThemeData theme, RistoNoticeKind kind) {
    final cs = theme.colorScheme;
    switch (kind) {
      case RistoNoticeKind.success:
        return _KindDefaults(
          accent: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      case RistoNoticeKind.warning:
        return _KindDefaults(
          accent: Colors.orange.shade700,
          icon: Icons.warning_amber_rounded,
        );
      case RistoNoticeKind.error:
        return _KindDefaults(
          accent: cs.error,
          icon: Icons.error_outline,
        );
      case RistoNoticeKind.info:
        return _KindDefaults(
          accent: cs.primary,
          icon: Icons.info_outline,
        );
      case RistoNoticeKind.neutral:
        return _KindDefaults(
          accent: cs.outline,
          icon: Icons.info_outline,
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
