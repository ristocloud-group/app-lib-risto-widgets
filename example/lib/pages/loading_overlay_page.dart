import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart'; // Ensure correct path

class LoadingOverlayPage extends StatefulWidget {
  const LoadingOverlayPage({super.key});

  @override
  State<LoadingOverlayPage> createState() => _LoadingOverlayPageState();
}

class _LoadingOverlayPageState extends State<LoadingOverlayPage> {
  bool _isLocalLoading = false;
  double? _localProgress;

  /// Simulates a global network request blocking the UI
  Future<void> _triggerGlobalLoading({
    RistoLoaderStyle style = RistoLoaderStyle.adaptive,
    String? message,
    double? progress,
  }) async {
    RistoLoadingOverlay.show(
      context,
      message: message,
      loaderStyle: style,
      progress: progress,
    );

    // Simulate work
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      RistoLoadingOverlay.hide(context);
    }
  }

  /// Simulates a local task with a dynamic progress bar
  Future<void> _triggerLocalProgressTask() async {
    setState(() {
      _isLocalLoading = true;
      _localProgress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _localProgress = i / 10;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLocalLoading = false;
        _localProgress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaddedChildrenList(
      children: [
        Text(
          'Global Loading Overlays',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'These block the entire screen and prevent user interaction.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        DoubleListTileButtons(
          firstButton: CustomActionButton.flat(
            onPressed:
                () => _triggerGlobalLoading(
                  message: 'Loading data...',
                  style: RistoLoaderStyle.adaptive,
                ),
            backgroundColor: Colors.blue.shade100,
            foregroundColor: Colors.blue.shade900,
            child: const Text('Adaptive Modal'),
          ),
          secondButton: CustomActionButton.flat(
            onPressed:
                () => _triggerGlobalLoading(
                  message: 'Syncing...',
                  style: RistoLoaderStyle.pulsingDots,
                ),
            backgroundColor: Colors.purple.shade100,
            foregroundColor: Colors.purple.shade900,
            child: const Text('Pulsing Dots'),
          ),
        ),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        Text(
          'Local Loading Overlays',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'These only block a specific widget/container.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),

        // Local Wrapper Example
        RistoLoadingOverlay(
          isLoading: _isLocalLoading,
          message: _localProgress != null ? 'Uploading...' : 'Processing...',
          progress: _localProgress,
          loaderStyle: RistoLoaderStyle.pulsingDots,
          child: RoundedContainer(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload your documents here',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CustomActionButton.elevated(
                  onPressed:
                      _isLocalLoading
                          ? null
                          : () {
                            setState(() {
                              _isLocalLoading = true;
                              _localProgress = null; // Indeterminate
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) {
                                setState(() => _isLocalLoading = false);
                              }
                            });
                          },
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  child: const Text('Indeterminate Task'),
                ),
                const SizedBox(height: 8),
                CustomActionButton.elevated(
                  onPressed: _isLocalLoading ? null : _triggerLocalProgressTask,
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  child: const Text('Simulate Progress Upload'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
