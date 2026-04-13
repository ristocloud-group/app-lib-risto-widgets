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
                Text('Card Loading State', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Combining RistoSkeleton.circle and textLines inside a single RistoShimmer.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // --- Example 1: Standard Card Shimmer ---
                RistoShimmer(
                  child: RoundedContainer(
                    backgroundColor: theme.cardColor,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RistoSkeleton.circle(size: 60),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RistoSkeleton.block(
                                height: 20,
                                width: 150,
                                margin: const EdgeInsets.only(bottom: 12),
                              ),
                              RistoSkeleton.textLines(lines: 3, spacing: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text('List Loading State', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'A repeated list of skeletons sharing the same shimmer animation.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // --- Example 2: List Shimmer ---
                RistoShimmer(
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: RoundedContainer(
                          backgroundColor: theme.cardColor,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              RistoSkeleton.block(
                                height: 40,
                                width: 40,
                                borderRadius: 8,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RistoSkeleton.textLines(lines: 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Complex Pre-built Layouts',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Using the static factory methods to instantly generate full structural layouts.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // --- Example 3: Full Page Layout Shimmer ---
          // Notice we don't pad the outer wrapper so the horizontal list can edge-to-edge scroll
          RistoShimmer(child: RistoSkeleton.buttonsAndHorizontalCards()),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Custom Colors', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Overriding the default base and highlight colors for a unique theme.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // --- Example 4: Custom Colored Shimmer ---
                RistoShimmer(
                  baseColor: Colors.blueGrey.shade100,
                  highlightColor: Colors.white,
                  duration: const Duration(milliseconds: 2000),
                  // Slower animation
                  child: Row(
                    children: [
                      Expanded(child: RistoSkeleton.block(height: 100)),
                      const SizedBox(width: 16),
                      Expanded(child: RistoSkeleton.block(height: 100)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
