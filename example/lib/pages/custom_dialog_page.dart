import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class CustomDialogPage extends StatelessWidget {
  const CustomDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Dialog Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Notice Dialogs'),

          CustomActionButton.flat(
            margin: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () {
              OpenCustomDialog.success(
                context,
                title: 'Operation Successful!',
                subtitle: 'Your data has been saved correctly.',
                onClose:
                    (result) => RistoToast.info(
                      context,
                      message: 'Success dialog closed.',
                    ),
              ).show(context);
            },
            child: const Text('Open Success Dialog'),
          ),

          CustomActionButton.flat(
            margin: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () {
              // Esempio di personalizzazione
              OpenCustomDialog.error(
                context,
                title: 'Connection Failed',
                subtitle:
                    'Please check your internet connection and try again.',
                // Personalizza l'aspetto della card
                elevation: 8.0,
                borderRadius: BorderRadius.circular(8),
                onClose:
                    (result) => RistoToast.info(
                      context,
                      message: 'Error dialog dismissed.',
                    ),
              ).show(context);
            },
            child: const Text('Open Error Dialog (Custom Style)'),
          ),

          const Divider(height: 32),
          _buildSectionHeader('Action Dialogs'),

          CustomActionButton.flat(
            margin: const EdgeInsets.symmetric(vertical: 8),
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

          CustomActionButton.flat(
            margin: const EdgeInsets.symmetric(vertical: 8),
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
                    RistoToast.success(
                      context,
                      message: 'Item has been deleted.',
                    );
                  } else if (confirmed == false) {
                    RistoToast.warning(context, message: 'Deletion cancelled.');
                  } else {
                    RistoToast.info(
                      context,
                      message: 'Confirmation closed without a choice.',
                    );
                  }
                },
              ).show(context);
            },
            child: const Text('Open Confirm Dialog'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}
