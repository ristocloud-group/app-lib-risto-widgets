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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info card with close button
          RistoNoticeCard.info(
            title: 'Information',
            subtitle: 'Some useful contextual information.',
            footerBuilder:
                (context, accentColor) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomActionButton.rounded(
                      minHeight: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      onPressed: () => _snack(context, 'Learn more tapped'),
                      child: Text(
                        'Learn more',
                        style: TextStyle(color: accentColor),
                      ),
                    ),
                  ],
                ),
            showClose: true,
            onClose: () => _snack(context, 'Info closed'),
          ),
          const SizedBox(height: 12),

          // Success card with a filled style
          RistoNoticeCard.success(
            title: 'Success',
            subtitle: 'Your operation completed successfully.',
            footerBuilder:
                (context, accentColor) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomActionButton.rounded(
                      minHeight: 0,
                      onPressed: () => _snack(context, 'View tapped'),
                      backgroundColor: accentColor,
                      child: const Text('View'),
                    ),
                  ],
                ),
            showClose: true,
            onClose: () => _snack(context, 'Success closed'),
          ),
          const SizedBox(height: 12),

          // Warning with 2 actions
          RistoNoticeCard.warning(
            title: 'Warning',
            subtitle: 'This may have unintended consequences.',
            footerBuilder:
                (context, accentColor) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomActionButton.minimal(
                      minHeight: 0,
                      onPressed: () => _snack(context, 'Ignore tapped'),
                      child: const Text('Ignore'),
                    ),
                    const SizedBox(width: 8),
                    CustomActionButton.elevated(
                      minHeight: 0,
                      onPressed: () => _snack(context, 'Fix tapped'),
                      backgroundColor: accentColor,
                      child: const Text('Fix'),
                    ),
                  ],
                ),
            showClose: true,
            onClose: () => _snack(context, 'Warning closed'),
          ),
          const SizedBox(height: 12),

          // Error card with icons on actions
          RistoNoticeCard.error(
            title: 'Error',
            subtitle: 'Something went wrong, please retry.',
            footerBuilder:
                (context, accentColor) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomActionButton.minimal(
                      minHeight: 0,
                      onPressed: () => _snack(context, 'Show details'),
                      child: const CustomIconText(
                        icon: Icons.info_outline,
                        iconSize: 18,
                        text: 'Details',
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomActionButton.elevated(
                      minHeight: 0,
                      onPressed: () => _snack(context, 'Retry tapped'),
                      backgroundColor: accentColor,
                      child: const CustomIconText(
                        icon: Icons.refresh,
                        iconSize: 18,
                        text: 'Retry',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            showClose: true,
            onClose: () => _snack(context, 'Error closed'),
          ),
          const SizedBox(height: 12),

          // Neutral card (no actions)
          const RistoNoticeCard(
            kind: RistoNoticeKind.neutral,
            title: 'Heads up',
            subtitle: 'Neutral informational message.',
          ),
          const SizedBox(height: 12),

          // Empty card with a custom button
          RistoNoticeCard(
            kind: RistoNoticeKind.empty,
            title: 'No items found',
            subtitle: 'Try adjusting your filters or adding a new item.',
            minHeight: 200,
            footerAlignment: AlignmentGeometry.bottomRight,
            footerBuilder:
                (context, accentColor) => CustomActionButton.elevated(
                  minHeight: 0,
                  onPressed: () => _snack(context, 'Add item tapped'),
                  backgroundColor: accentColor,
                  child: const CustomIconText(
                    icon: Icons.add,
                    iconSize: 18,
                    text: 'Add item',
                    color: Colors.white,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
