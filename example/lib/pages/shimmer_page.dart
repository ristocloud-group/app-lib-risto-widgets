import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shimmers & Skeletons')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Global Wrapper Strategy',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Wrapping a whole card (with background and padding) in a single RistoShimmer. The beam sweeps across everything smoothly.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // --- Example 1: Standard Card Shimmer (Global Wrapper) ---
                RistoShimmer(
                  child: RoundedContainer(
                    backgroundColor: theme.cardColor,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RistoShimmer.circle(size: 60),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RistoShimmer.block(
                                height: 20,
                                width: 150,
                                margin: const EdgeInsets.only(bottom: 12),
                              ),
                              RistoShimmer.textLines(lines: 3, spacing: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  '2. Pre-built Layouts (Built-in Shimmer)',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Using the factory methods with applyShimmer: true. No external wrapper needed!',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // --- Example 2: Full Page Layout Shimmer ---
          // Notice we don't pad the outer wrapper so the horizontal list can edge-to-edge scroll.
          RistoShimmer.layoutButtonsAndCards(),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3. Custom Colored Factories',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Passing custom base and highlight colors directly into the skeleton factories.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // --- Example 3: Custom Colored Skeleton Blocks ---
                Row(
                  children: [
                    Expanded(
                      child: RistoShimmer.block(
                        height: 100,
                        baseColor: Colors.blue.shade100,
                        highlightColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RistoShimmer.block(
                        height: 100,
                        baseColor: Colors.purple.shade100,
                        highlightColor: Colors.purple.shade50,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Text(
                  '4. Static Skeletons (No Shimmer)',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sometimes you just want the shapes with a static color and no animation.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // --- Example 4: Static Skeletons ---
                RoundedContainer(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withCustomOpacity(0.3),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      RistoShimmer.circle(
                        size: 50,
                        staticColor: Colors.blueGrey.shade200, // Static color
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RistoShimmer.textLines(
                          lines: 2,
                          staticColor: Colors.blueGrey.shade200, // Static color
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text('5. Shimmer Factories', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Quickly deploy light, dark, or auto-calculated colored shimmers using the new RistoShimmer factories.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // --- Example 5a: Auto-Calculated Primary Color Shimmer ---
                RistoShimmer.fromColor(
                  color: Colors.indigo.shade200,
                  // It will automatically use .lighter() for the sweeping highlight!
                  child: Row(
                    children: [
                      RistoShimmer.circle(size: 50),
                      const SizedBox(width: 16),
                      Expanded(child: RistoShimmer.textLines(lines: 2)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Example 5b: Dark Mode Factory Shimmer ---
                RoundedContainer(
                  backgroundColor: Colors.grey.shade900,
                  padding: const EdgeInsets.all(16),
                  child: RistoShimmer.dark(
                    child: Row(
                      children: [
                        RistoShimmer.circle(size: 50),
                        const SizedBox(width: 16),
                        Expanded(child: RistoShimmer.textLines(lines: 2)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
