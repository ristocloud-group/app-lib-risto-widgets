import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

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
            const _SectionTitle('Standard Dialogs (With Blur!)'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.success(
                  context,
                  blurSigma: 6.0,
                  title: 'Operation Successful!',
                  subtitle:
                      'This dialog has no footer and blurs the background. It will auto-dismiss or can be closed with the X.',
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
              child: const Text('Open Success Dialog (Blurred Background)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  blurSigma: 10.0,
                  title: 'Information',
                  subtitle:
                      'This dialog has a heavy background blur and a custom confirmation button.',
                  confirmButtonText: 'Got it!',
                  onClose:
                      (result) => RistoToast.info(
                        context,
                        message: 'Info dialog closed.',
                      ),
                ).show(context);
              },
              child: const Text('Open Info Dialog (Heavy Blur)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.warning(
                  context,
                  blurSigma: 3.0,
                  // Light blur
                  title: 'Unsaved Changes',
                  subtitle:
                      'If you leave now, your changes will be lost. Are you sure?',
                  confirmButtonText: 'Continue',
                  cancelButtonText: 'Cancel',
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

            const SizedBox(height: 24),
            const _SectionTitle('Layout & Personalization Examples'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.error(
                  context,
                  blurSigma: 8.0,
                  title: 'Custom Themed Error',
                  subtitle:
                      'This error dialog uses a custom purple accent color instead of the default red, and aligns content to the bottom!',
                  confirmButtonText: 'Understood',
                  accentColor: Colors.deepPurple,
                  // Overrides the default red!
                  mainAxisAlignment: MainAxisAlignment.end,
                  minHeight: 300,
                ).show(context);
              },
              child: const Text(
                'Open Error Dialog (Custom Accent Color & Alignment)',
              ),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.error(
                  context,
                  blurSigma: 8.0,
                  title: 'Strict Error',
                  subtitle:
                      'You cannot dismiss this by tapping outside or using the X. You must click the button.',
                  confirmButtonText: 'Understood',
                  showClose: false,
                  barrierDismissible: false,
                ).show(context);
              },
              child: const Text('Force Action (No X, Not Dismissible)'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.confirm(
                  context,
                  blurSigma: 4.0,
                  title: 'Aligned Buttons',
                  subtitle:
                      'These buttons are aligned to the right and shrink-wrapped instead of expanded.',
                  confirmButtonText: 'Yes',
                  cancelButtonText: 'No',
                  expandButtons: false,
                  footerAlignment: MainAxisAlignment.end,
                  confirmButtonBackgroundColor: Colors.blueAccent,
                  confirmButtonForegroundColor: Colors.white,
                  cancelButtonForegroundColor: Colors.blueAccent,
                ).show(context);
              },
              child: const Text('Shrink-wrapped & Right-Aligned Buttons'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.warning(
                  context,
                  title: 'Space Between Layout',
                  subtitle: 'Buttons are pushed to the opposite edges.',
                  confirmButtonText: 'Proceed',
                  cancelButtonText: 'Go Back',
                  expandButtons: false,
                  footerAlignment: MainAxisAlignment.spaceBetween,
                ).show(context);
              },
              child: const Text('Space-Between Footer Alignment'),
            ),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  title: 'Full Screen Edge Dialog',
                  subtitle:
                      'This dialog ignores safe area insets (useful for edge-to-edge custom designs).',
                  confirmButtonText: 'Close',
                  useSafeArea: false,
                ).show(context);
              },
              child: const Text('Ignore Safe Area'),
            ),

            const SizedBox(height: 24),
            const _SectionTitle('Advanced Usage'),

            CustomActionButton.elevated(
              margin: const EdgeInsets.symmetric(vertical: 8),
              minHeight: 0,
              onPressed: () {
                OpenCustomDialog.info(
                  context,
                  blurSigma: 12.0,
                  title: 'Custom Animation Overlay',
                  subtitle:
                      'This dialog and its blur slide up from the bottom instead of using the default scale transition.',
                  confirmButtonText: 'Awesome',
                ).show(
                  context,
                  transitionDuration: const Duration(milliseconds: 400),
                  transitionBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    final tween = Tween(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic));

                    // OpenCustomDialog handles the blur layer below it!
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                );
              },
              child: const Text('Open with Slide-Up Animation & Blur'),
            ),

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
                  blurSigma: 5.0,
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
          ],
        ),
      ),
    );
  }
}

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
