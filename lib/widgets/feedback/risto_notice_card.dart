import 'package:flutter/material.dart';
import 'package:risto_widgets/extensions.dart';

import '../buttons/custom_action_button.dart';
import '../buttons/list_tile_button.dart';

enum RistoNoticeKind { info, success, warning, error, neutral, empty }

// Footer builder type, providing the card's accent color
typedef RistoFooterBuilder = Widget Function(
    BuildContext context, Color accentColor);

class RistoNoticeCard extends StatelessWidget {
  // Content
  final RistoNoticeKind kind;
  final String title;
  final String? subtitle;

  // Footer customization
  final RistoFooterBuilder? footerBuilder;

  // Visual overrides
  final IconData? icon;
  final Color? accentColor;

  // Close
  final bool showClose;
  final VoidCallback? onClose;

  // Layout
  final double? minHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool dense;
  final BorderRadius? borderRadius;

  // Card styling
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? borderColor;
  final double borderWidth;
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
    this.footerBuilder,
    this.showClose = false,
    this.onClose,
    this.icon,
    this.accentColor,
    this.minHeight,
    this.padding,
    this.margin,
    this.dense = true,
    this.borderRadius,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.elevation,
    this.shadowColor,
    this.layoutAnimDuration = const Duration(milliseconds: 180),
    this.layoutAnimCurve = Curves.easeInOut,
  });

  factory RistoNoticeCard.info({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.info,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  factory RistoNoticeCard.success({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.success,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  factory RistoNoticeCard.warning({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.warning,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  factory RistoNoticeCard.error({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.error,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  factory RistoNoticeCard.neutral({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.neutral,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  factory RistoNoticeCard.empty({
    Key? key,
    required String title,
    String? subtitle,
    RistoFooterBuilder? footerBuilder,
    bool showClose = false,
    VoidCallback? onClose,
  }) {
    return RistoNoticeCard(
      key: key,
      kind: RistoNoticeKind.empty,
      title: title,
      subtitle: subtitle,
      footerBuilder: footerBuilder,
      showClose: showClose,
      onClose: onClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = _defaultsForKind(theme, kind);
    final stripeColor = accentColor ?? d.accent;
    final leadingIcon = icon ?? d.icon;
    final r = borderRadius ?? BorderRadius.circular(12);
    final resolvedMinHeight = minHeight ?? 64.0;
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 14);
    const gapX = 12.0;
    const gapTitleToSubtitle = 6.0;

    final body = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: r.topLeft,
              bottomLeft: r.bottomLeft,
            ),
            child: Container(
                width: 8, height: resolvedMinHeight, color: stripeColor),
          ),
          const SizedBox(width: gapX),
          Expanded(
            child: Padding(
              padding: resolvedPadding,
              child: Column(
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
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  if ((subtitle ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: gapTitleToSubtitle),
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withCustomOpacity(0.8),
                        ),
                      ),
                    ),
                  if (footerBuilder != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: footerBuilder!(context, stripeColor),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(12);

    if (!showClose) {
      return RoundedContainer(
        margin: margin,
        borderRadius: resolvedBorderRadius.topLeft.x,
        backgroundColor: backgroundColor ?? theme.colorScheme.surface,
        backgroundGradient: backgroundGradient,
        borderColor: borderColor ?? theme.colorScheme.outlineVariant,
        borderWidth: borderWidth,
        elevation: elevation ?? (kind == RistoNoticeKind.error ? 1.5 : 0),
        shadowColor: shadowColor ?? theme.colorScheme.shadow,
        child: body,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        RoundedContainer(
          margin: margin,
          borderRadius: resolvedBorderRadius.topLeft.x,
          backgroundColor: backgroundColor ?? theme.colorScheme.surface,
          backgroundGradient: backgroundGradient,
          borderColor: borderColor ?? theme.colorScheme.outlineVariant,
          borderWidth: borderWidth,
          elevation: elevation ?? (kind == RistoNoticeKind.error ? 1.5 : 0),
          shadowColor: shadowColor ?? theme.colorScheme.shadow,
          child: body,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: CustomActionButton.icon(
            icon: Icons.close_rounded,
            onPressed: onClose,
            baseType: ButtonType.rounded,
            size: 40,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
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
