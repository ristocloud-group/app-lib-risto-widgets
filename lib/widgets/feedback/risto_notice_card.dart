import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

enum RistoNoticeKind { info, success, warning, error, neutral, empty }

// ---- Action customization API ----
enum RistoButtonVariant {
  flat,
  elevated,
  minimal,
  rounded,
  custom,
}

typedef RistoActionBuilder = Widget Function(
  BuildContext context, {
  required VoidCallback? onPressed,
  required String label,
  IconData? icon,
  required RistoNoticeKind kind,
  required bool inline,
});

class RistoNoticeCard extends StatelessWidget {
  // Content
  final RistoNoticeKind kind;
  final String title;
  final String? subtitle;

  // Actions
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  // Action customization
  final RistoButtonVariant primaryVariant;
  final RistoButtonVariant secondaryVariant;
  final IconData? primaryIcon;
  final IconData? secondaryIcon;
  final RistoActionBuilder? primaryBuilder;
  final RistoActionBuilder? secondaryBuilder;
  final double actionsSpacing;
  final double actionsRunSpacing;
  final EdgeInsetsGeometry? actionsInset;

  // Close
  final bool showClose;
  final VoidCallback? onClose;

  // Visual overrides
  final IconData? icon;
  final Color? accentColor;

  // Layout
  final double? minHeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double actionsInlineBreakpoint;
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

    // Actions
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,

    // Customization
    this.primaryVariant = RistoButtonVariant.flat,
    this.secondaryVariant = RistoButtonVariant.flat,
    this.primaryIcon,
    this.secondaryIcon,
    this.primaryBuilder,
    this.secondaryBuilder,
    this.actionsSpacing = 8,
    this.actionsRunSpacing = 8,
    this.actionsInset,

    // Close
    this.showClose = false,
    this.onClose,

    // Visuals
    this.icon,
    this.accentColor,

    // Layout
    this.minHeight,
    this.padding,
    this.margin,
    this.actionsInlineBreakpoint = 520,
    this.dense = true,
    this.borderRadius,

    // Card styling
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.elevation,
    this.shadowColor,

    // Anim
    this.layoutAnimDuration = const Duration(milliseconds: 180),
    this.layoutAnimCurve = Curves.easeInOut,
  });

  bool get _hasPrimary => primaryActionLabel != null && onPrimaryAction != null;

  bool get _hasSecondary =>
      secondaryActionLabel != null && onSecondaryAction != null;

  bool get _hasButtons => _hasPrimary || _hasSecondary;

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
    final resolvedMargin = margin ?? EdgeInsets.zero;
    final radiusAsDouble = r.topLeft.x;

    // gaps
    const gapX = 12.0;
    const gapTitleToSubtitle = 6.0;

    Widget buildButton({
      required bool isPrimary,
      required bool inline,
    }) {
      final label = isPrimary ? primaryActionLabel : secondaryActionLabel;
      final onPressed = isPrimary ? onPrimaryAction : onSecondaryAction;
      final variant = isPrimary ? primaryVariant : secondaryVariant;
      final icon = isPrimary ? primaryIcon : secondaryIcon;
      final builder = isPrimary ? primaryBuilder : secondaryBuilder;

      if (label == null) return const SizedBox.shrink();

      // builder full control
      if (variant == RistoButtonVariant.custom && builder != null) {
        return builder(
          context,
          onPressed: onPressed,
          label: label,
          icon: icon,
          kind: kind,
          inline: inline,
        );
      }

      final child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      );

      switch (variant) {
        case RistoButtonVariant.flat:
          return CustomActionButton.flat(
            onPressed: onPressed,
            minHeight: 0,
            child: child,
          );
        case RistoButtonVariant.elevated:
          return CustomActionButton.elevated(
            onPressed: onPressed,
            elevation: 2,
            minHeight: 0,
            child: child,
          );
        case RistoButtonVariant.minimal:
          return CustomActionButton.minimal(
            onPressed: onPressed,
            minHeight: 0,
            child: child,
          );
        case RistoButtonVariant.rounded:
          return CustomActionButton.rounded(
            onPressed: onPressed,
            height: 36,
            child: child,
          );
        case RistoButtonVariant.custom:
          return CustomActionButton.flat(
            onPressed: onPressed,
            minHeight: 0,
            child: child,
          );
      }
    }

    Widget inlineButtons() {
      if (!_hasButtons) return const SizedBox.shrink();
      final items = <Widget>[
        if (_hasPrimary) buildButton(isPrimary: true, inline: true),
        if (_hasSecondary) buildButton(isPrimary: false, inline: true),
      ];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _spaced(items, SizedBox(width: actionsSpacing)),
      );
    }

    Widget stackedButtons() {
      if (!_hasButtons) return const SizedBox.shrink();
      return Padding(
        padding: actionsInset ?? const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: actionsSpacing,
          runSpacing: actionsRunSpacing,
          children: [
            if (_hasPrimary) buildButton(isPrimary: true, inline: false),
            if (_hasSecondary) buildButton(isPrimary: false, inline: false),
          ],
        ),
      );
    }

    Widget getContent(bool inlineActions) {
      final titleRow = Row(
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
          AnimatedCrossFade(
            duration: layoutAnimDuration,
            firstCurve: layoutAnimCurve,
            secondCurve: layoutAnimCurve,
            sizeCurve: layoutAnimCurve,
            crossFadeState: (inlineActions && _hasButtons)
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: inlineButtons(),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      );

      final subtitleWidget = (subtitle ?? '').isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: gapTitleToSubtitle),
              child: Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withCustomOpacity(.8),
                ),
              ),
            )
          : const SizedBox.shrink();

      final belowActions =
          (!inlineActions) ? stackedButtons() : const SizedBox.shrink();

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
                  children: [titleRow, subtitleWidget, belowActions],
                ),
              ),
            ),
          ],
        ),
      );

      if (!showClose) return body;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          body,
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
              iconColor: Colors.black,
            ),
          ),
        ],
      );
    }

    return Semantics(
      container: true,
      label: 'notice-card',
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: resolvedMinHeight),
        child: RoundedContainer(
          margin: resolvedMargin,
          backgroundColor: backgroundColor ?? theme.colorScheme.surface,
          backgroundGradient: backgroundGradient,
          borderColor: borderColor ?? theme.colorScheme.outlineVariant,
          borderWidth: borderWidth,
          borderRadius: radiusAsDouble,
          elevation: elevation ?? (kind == RistoNoticeKind.error ? 1.5 : 0),
          shadowColor: shadowColor ?? theme.colorScheme.shadow,
          child: LayoutBuilder(
            builder: (context, c) {
              final inline = c.maxWidth >= actionsInlineBreakpoint;
              return AnimatedCrossFade(
                duration: const Duration(milliseconds: 180),
                reverseDuration: const Duration(milliseconds: 140),
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeOut,
                sizeCurve: Curves.easeInOut,
                crossFadeState: inline
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: KeyedSubtree(
                  key: ValueKey('inline=true|$title'),
                  child: getContent(true),
                ),
                secondChild: KeyedSubtree(
                  key: ValueKey('inline=false|$title'),
                  child: getContent(false),
                ),
              );
            },
          ),
        ),
      ),
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

  static List<Widget> _spaced(List<Widget> items, Widget gap) {
    if (items.length < 2) return items;
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(gap);
    }
    return out;
  }
}

class _KindDefaults {
  final Color accent;
  final IconData icon;

  const _KindDefaults({required this.accent, required this.icon});
}
