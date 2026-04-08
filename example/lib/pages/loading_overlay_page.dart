import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class LoadingOverlayPage extends StatefulWidget {
  const LoadingOverlayPage({super.key});

  @override
  State<LoadingOverlayPage> createState() => _LoadingOverlayPageState();
}

class _LoadingOverlayPageState extends State<LoadingOverlayPage> {
  bool _isLocalLoading = false;
  double? _localProgress;

  bool _isFactoriesLoading = true;

  Future<void> _triggerGlobalLoading({
    RistoLoaderStyle style = RistoLoaderStyle.adaptive,
    String? message,
    double? progress,
  }) async {
    LoadingPanel.show(
      context,
      message: message,
      loaderStyle: style,
      progress: progress,
    );

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      LoadingPanel.hide(context);
    }
  }

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
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Overlay Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Standalone Loaders',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Using the Loader widget independently with custom colors and alignments.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            RoundedContainer(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Loader.basic(color: Colors.redAccent),
                      const SizedBox(height: 8),
                      const Text('Basic'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        color: Colors.white,
                        child: Loader.fitted(
                          color: Colors.blue,
                          padding: const EdgeInsets.all(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('FittedBox'),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Loader.centered(color: Colors.purple),
                      ),
                      const SizedBox(height: 8),
                      const Text('Centered'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            Text(
              'Factory Styles (Local)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Using the .dark(), .glass(), and .clear() constructors with custom loader colors.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            CustomActionButton.flat(
              onPressed: () {
                setState(() {
                  _isFactoriesLoading = !_isFactoriesLoading;
                });
              },
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
              child: Text(
                _isFactoriesLoading
                    ? 'Stop Factory Loaders'
                    : 'Start Factory Loaders',
              ),
            ),
            const SizedBox(height: 16),

            LoadingPanel.dark(
              isLoading: _isFactoriesLoading,
              message: 'Dark Barrier...',
              loaderColor: Colors.deepOrangeAccent,
              child: _buildGradientCard('Dark Factory', [
                Colors.deepOrange,
                Colors.orange,
              ]),
            ),
            const SizedBox(height: 16),

            LoadingPanel.glass(
              isLoading: _isFactoriesLoading,
              message: 'Glass Barrier...',
              loaderStyle: RistoLoaderStyle.pulsingDots,
              loaderColor: Colors.teal,
              child: _buildGradientCard('Glass Factory (High Blur)', [
                Colors.teal,
                Colors.greenAccent,
              ]),
            ),
            const SizedBox(height: 16),

            LoadingPanel.clear(
              isLoading: _isFactoriesLoading,
              loaderColor: Colors.indigo,
              child: _buildGradientCard('Clear Factory (No Blur)', [
                Colors.indigo,
                Colors.blue,
              ]),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            Text(
              'Standard Local Loading Overlay',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Blocks a specific widget with an interactive state.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            LoadingPanel(
              isLoading: _isLocalLoading,
              message:
                  _localProgress != null ? 'Uploading...' : 'Processing...',
              progress: _localProgress,
              loaderStyle: RistoLoaderStyle.pulsingDots,
              loaderColor: Colors.indigo,
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
                                  _localProgress = null;
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
                      onPressed:
                          _isLocalLoading ? null : _triggerLocalProgressTask,
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      child: const Text('Simulate Progress Upload'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard(String title, List<Color> colors) {
    return RoundedContainer(
      backgroundGradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
