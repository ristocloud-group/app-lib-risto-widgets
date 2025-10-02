import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class RistoNoticeCardPage extends StatelessWidget {
  const RistoNoticeCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: const Text('Risto Notice Card Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Default Styles'),

            // Using .rounded for a softer look, and minHeight: 0 for proper sizing.
            RistoNoticeCard.success(
              title: 'Operation Successful',
              subtitle:
                  'Your operation completed successfully and the data was saved.',

              footerBuilder: (context, accentColor) {
                return CustomActionButton.rounded(
                  minHeight: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 24,
                  ),
                  onPressed:
                      () => RistoToast.success(context, message: 'View tapped'),
                  backgroundColor: accentColor,
                  child: const Text('View Details'),
                );
              },
            ),
            const SizedBox(height: 24),

            // A combination of .minimal and .rounded in a two-button layout.
            RistoNoticeCard.warning(
              title: 'Warning',
              subtitle:
                  'This may have unintended consequences. Please review your changes before proceeding.',
              footerBuilder: (context, accentColor) {
                return Row(
                  children: [
                    Expanded(
                      child: CustomActionButton.minimal(
                        minHeight: 0, // Let button size to its content
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        onPressed:
                            () => RistoToast.warning(
                              context,
                              message: 'Ignore tapped',
                            ),
                        child: const Text('Ignore'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomActionButton.rounded(
                        minHeight: 0,
                        // Let button size to its content
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        onPressed:
                            () =>
                                RistoToast.info(context, message: 'Fix tapped'),
                        backgroundColor: accentColor,
                        child: const Text('Fix'),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),

            const _SectionTitle('Alignment & Padding'),

            RistoNoticeCard.info(
              title: 'Left-Aligned Content',
              subtitle:
                  'Using crossAxisAlignment: CrossAxisAlignment.start to align all content to the left.',
              crossAxisAlignment: CrossAxisAlignment.start,
              noticeIcon: Icon(
                Icons.align_horizontal_left,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),

            RistoNoticeCard.neutral(
              title: 'Right-Aligned Footer',
              subtitle:
                  'Content is left-aligned, but the footer is aligned to the right using footerAlignment.',
              crossAxisAlignment: CrossAxisAlignment.start,
              footerAlignment: Alignment.centerRight,
              footerBuilder:
                  (context, accentColor) => CustomActionButton.rounded(
                    minHeight: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    onPressed:
                        () => RistoToast.info(
                          context,
                          message: 'Next Step tapped',
                        ),
                    child: const Text('Next Step'),
                  ),
            ),
            const SizedBox(height: 24),

            RistoNoticeCard.neutral(
              title: 'Custom Footer Padding',
              subtitle:
                  'Using footerPadding to add extra space around the button.',
              footerPadding: const EdgeInsets.only(top: 20, right: 10),
              footerAlignment: Alignment.centerRight,
              footerBuilder:
                  (context, accentColor) => CustomActionButton.rounded(
                    minHeight: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    onPressed:
                        () => RistoToast.info(
                          context,
                          message: 'Submit button tapped',
                        ),
                    child: const Text('Submit'),
                  ),
            ),
            const SizedBox(height: 48),

            const _SectionTitle('Sizing & Compact Mode'),

            RistoNoticeCard.info(
              title: 'Compact Mode',
              subtitle:
                  'Using compact: true to reduce vertical spacing between elements.',
              compact: true,
              crossAxisAlignment: CrossAxisAlignment.start,
              footerBuilder:
                  (context, accentColor) => CustomActionButton.rounded(
                    minHeight: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    // Smaller padding for compact
                    onPressed:
                        () => RistoToast.info(context, message: 'OK tapped'),
                    child: const Text('OK'),
                  ),
            ),
            const SizedBox(height: 24),

            RistoNoticeCard.empty(
              title: 'Minimum Height',
              subtitle:
                  'This card has a minHeight of 250, forcing it to be taller than its content.',
              minHeight: 250,
              footerBuilder:
                  (context, accentColor) => CustomActionButton.rounded(
                    minHeight: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 24,
                    ),
                    onPressed:
                        () => RistoToast.success(
                          context,
                          message: 'Add item tapped',
                        ),
                    backgroundColor: accentColor,
                    child: const Text('Add Item'),
                  ),
            ),
            const SizedBox(height: 24),

            Center(
              child: RistoNoticeCard.error(
                title: 'Maximum Width',
                subtitle:
                    'This card has a maxWidth of 400. Click the button to see an error toast.',
                maxWidth: 400,
                footerBuilder:
                    (context, accentColor) => CustomActionButton.rounded(
                      minHeight: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      onPressed:
                          () => RistoToast.error(
                            context,
                            message: 'This is an error toast!',
                          ),
                      backgroundColor: accentColor,
                      child: const Text('Trigger Error'),
                    ),
              ),
            ),
            const SizedBox(height: 48),

            const _SectionTitle('Custom Layout'),
            
            RistoNoticeCard.info(
              invert: true,
              title: 'Inverted Layout',
              subtitle: 'The title is displayed above the icon.',
              noticeIcon: Icon(
                Icons.info_outline,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),

            RistoNoticeCard.info(
              title: 'Rich Text Subtitle',
              subtitleSpan: const [
                TextSpan(text: 'You can use '),
                TextSpan(
                  text: 'InlineSpan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to style your subtitle.'),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            const SizedBox(height: 24),

            // Using the main constructor to access fine-grained spacing controls.
            RistoNoticeCard(
              kind: RistoNoticeKind.neutral,
              title: 'Custom Spacing',
              subtitle: 'This card has custom spacing between its elements.',
              crossAxisAlignment: CrossAxisAlignment.start,
              runSpacing: 32,
              footerBuilder:
                  (context, accentColor) =>
                      const Text('Notice the large gaps above!'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple helper widget to create section titles for the example page.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}
