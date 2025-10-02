import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

// Assuming you import RistoToast and CustomIconText from your project files
// import 'path/to/risto_toast.dart';
// import 'path/to/custom_icon_text.dart';

class CustomDialogPage extends StatelessWidget {
  const CustomDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: const Text('Custom Dialog Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionTitle('Standard Dialogs'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.success(
                  context,
                  title: 'Operation Successful!',
                  subtitle:
                      'This dialog has no footer by default. It will auto-dismiss or can be closed with the X.',

                  noticeIcon: const Icon(
                    Icons.task_alt_rounded,
                    size: 48,
                    color: Colors.green,
                  ),
                  onClose:
                      (result) => RistoToast.info(
                        context,
                        message: 'Success dialog closed.',
                      ),
                ).show(context);
              },
              child: const Text('Open Success Dialog (No Footer)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  title: 'Information',
                  subtitle: 'This dialog has a custom confirmation button.',
                  confirmButtonText: 'Got it!',
                  onClose:
                      (result) => RistoToast.info(
                        context,
                        message: 'Info dialog closed.',
                      ),
                ).show(context);
              },
              child: const Text('Open Info Dialog (With Button)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.warning(
                  context,
                  title: 'Unsaved Changes',
                  subtitle:
                      'If you leave now, your changes will be lost. Are you sure?',
                  onClose: (confirmed) {
                    if (confirmed == true) {
                      RistoToast.success(context, message: 'Action continued.');
                    } else if (confirmed == false) {
                      RistoToast.warning(context, message: 'Action cancelled.');
                    }
                  },
                ).show(context);
              },
              child: const Text('Open Warning Dialog'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.confirm(
                  context,
                  title: 'Confirm Deletion',
                  subtitle:
                      'Are you sure you want to permanently delete this item?',
                  confirmButtonText: 'Delete',
                  cancelButtonText: 'Keep',
                  onClose: (confirmed) {
                    if (confirmed == true) {
                      RistoToast.error(
                        context,
                        message: 'Item has been deleted.',
                      );
                    } else if (confirmed == false) {
                      RistoToast.info(context, message: 'Deletion cancelled.');
                    }
                  },
                ).show(context);
              },
              child: const Text('Open Confirm Dialog'),
            ),

            const SizedBox(height: 24),
            const _SectionTitle('Customized Dialogs'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.error(
                  context,
                  title: 'Connection Failed',
                  subtitle:
                      'Please check your internet connection and try again.',
                  accentColor: Colors.deepOrange.shade700,
                  backgroundColor: Colors.orange.shade50,
                  confirmButtonText: 'Understood',
                  onClose:
                      (result) => RistoToast.info(
                        context,
                        message: 'Error dialog dismissed.',
                      ),
                ).show(context);
              },
              child: const Text('Open Error Dialog (Custom Colors)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  confirmButtonText: 'OK',
                  title: 'Left-Aligned Dialog',
                  subtitle: 'This dialog has its content aligned to the left.',
                  crossAxisAlignment: CrossAxisAlignment.start,
                ).show(context);
              },
              child: const Text('Open Left-Aligned Dialog'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  confirmButtonText: 'OK',
                  title: 'Compact Dialog',
                  subtitle:
                      'This dialog uses the compact flag for reduced spacing.',
                  compact: true,
                ).show(context);
              },
              child: const Text('Open Compact Dialog'),
            ),

            const SizedBox(height: 24),
            const _SectionTitle('Advanced Usage'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                final customNotice = RistoNoticeCard.info(
                  title: 'This is a Custom Notice',
                  subtitle:
                      'It was built separately with a custom footer and passed to the dialog using OpenCustomDialog.notice().',
                  showClose: true,
                  onClose: () => Navigator.pop(context, 'closed_with_x'),
                  footerBuilder: (ctx, color) {
                    return CustomActionButton.rounded(
                      minHeight: 0,
                      onPressed: () => Navigator.pop(ctx, 'dismissed_manually'),
                      backgroundColor: Colors.deepPurple,
                      child: const Text('Custom Dismiss'),
                    );
                  },
                );

                OpenCustomDialog.notice(
                  context,
                  notice: customNotice,
                  onClose: (result) {
                    RistoToast.info(
                      context,
                      message: 'Notice dialog closed with: $result',
                    );
                  },
                ).show(context);
              },
              child: const Text('Open with Pre-built Notice Card'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.success(
                  context,
                  title: 'Custom Footer',
                  subtitle:
                      'This success dialog has its default footer completely replaced.',
                  footerBuilder: (context, accentColor) {
                    return CustomActionButton.flat(
                      minHeight: 0,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('This is a custom footer!'),
                    );
                  },
                ).show(context);
              },
              child: const Text('Open with Custom Footer Override'),
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
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
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
