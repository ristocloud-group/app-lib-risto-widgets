import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class RistoNoticeCardPage extends StatelessWidget {
  const RistoNoticeCardPage({super.key});

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RistoNoticeCard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Info card with close button ----
          RistoNoticeCard(
            kind: RistoNoticeKind.info,
            title: 'Information',
            subtitle: 'Some useful contextual information.',
            primaryActionLabel: 'Learn more',
            onPrimaryAction: () => _snack(context, 'Learn more tapped'),
            primaryVariant: RistoButtonVariant.flat,
            showClose: true,
            onClose: () => _snack(context, 'Info closed'),
          ),
          const SizedBox(height: 12),

          // ---- Success card with filled style ----
          RistoNoticeCard(
            kind: RistoNoticeKind.success,
            title: 'Success',
            subtitle: 'Your operation completed successfully.',
            primaryActionLabel: 'View',
            onPrimaryAction: () => _snack(context, 'View tapped'),
            primaryVariant: RistoButtonVariant.elevated,
            showClose: true,
            onClose: () => _snack(context, 'Success closed'),
          ),
          const SizedBox(height: 12),

          // ---- Warning with 2 actions ----
          RistoNoticeCard(
            kind: RistoNoticeKind.warning,
            title: 'Warning',
            subtitle: 'This may have unintended consequences.',
            primaryActionLabel: 'Fix',
            onPrimaryAction: () => _snack(context, 'Fix tapped'),
            secondaryActionLabel: 'Ignore',
            onSecondaryAction: () => _snack(context, 'Ignore tapped'),
            primaryVariant: RistoButtonVariant.rounded,
            secondaryVariant: RistoButtonVariant.flat,
            showClose: true,
            onClose: () => _snack(context, 'Warning closed'),
          ),
          const SizedBox(height: 12),

          // ---- Error card with icons on actions ----
          RistoNoticeCard(
            kind: RistoNoticeKind.error,
            title: 'Error',
            subtitle: 'Something went wrong, please retry.',
            primaryActionLabel: 'Retry',
            onPrimaryAction: () => _snack(context, 'Retry tapped'),
            secondaryActionLabel: 'Details',
            onSecondaryAction: () => _snack(context, 'Show details'),
            primaryVariant: RistoButtonVariant.elevated,
            primaryIcon: Icons.refresh,
            secondaryVariant: RistoButtonVariant.flat,
            secondaryIcon: Icons.info_outline,
            showClose: true,
            onClose: () => _snack(context, 'Error closed'),
          ),
          const SizedBox(height: 12),

          // ---- Neutral card (no actions) ----
          const RistoNoticeCard(
            kind: RistoNoticeKind.neutral,
            title: 'Heads up',
            subtitle: 'Neutral informational message.',
          ),
          const SizedBox(height: 12),

          // ---- Empty card with custom builder ----
          RistoNoticeCard(
            kind: RistoNoticeKind.empty,
            title: 'No items found',
            subtitle: 'Try adjusting your filters or adding a new item.',
            primaryActionLabel: 'Add item',
            onPrimaryAction: () => _snack(context, 'Add item tapped'),
            primaryVariant: RistoButtonVariant.custom,
            primaryBuilder: (
              context, {
              required onPressed,
              required label,
              IconData? icon,
              required kind,
              required inline,
            }) {
              return CustomActionButton.elevated(
                onPressed: onPressed,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                minHeight: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon ?? Icons.add, size: 18),
                    const SizedBox(width: 6),
                    Text(label),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
