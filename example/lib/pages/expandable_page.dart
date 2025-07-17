import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ExpandablePage extends StatelessWidget {
  const ExpandablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    const whiteTextStyle = TextStyle(color: Colors.white);
    const white70TextStyle = TextStyle(color: Colors.white70);

    return PaddedChildrenList(
      // Assuming PaddedChildrenList handles padding
      children: [
        Text('Expandable List Tile Button Examples', style: titleStyle),
        const SizedBox(height: 20),

        // --- Example 1: .listTile with Alignment & BorderRadius ---
        Text(
          '1. ListTile with Body Alignment & BorderRadius',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.listTile(
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.teal[700],
          expandedBodyColor: Colors.teal[100],
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          bodyAlignment: Alignment.bottomCenter,
          expanded: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Expanded content aligned to bottom center',
              textAlign: TextAlign.center,
            ),
          ),
          title: const Text('Aligned Body Content', style: whiteTextStyle),
          subtitle: const Text('Using bodyAlignment', style: white70TextStyle),
          leading: const Icon(Icons.format_align_center, color: Colors.white),
          // Updated Icon
          trailingIconColor: Colors.white,
        ),
        const SizedBox(height: 20),

        // --- Example 2: .iconListTile with Size Factors & Colors ---
        Text(
          '2. IconListTile with Size Factors & Colors',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.iconListTile(
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.indigo[600],
          expandedBodyColor: Colors.indigo[100],
          elevation: 6.0,
          borderRadius: BorderRadius.circular(8),
          expanded: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Expanded content with scaled icon.'),
          ),
          title: const Text(
            'Scaled Icon & Custom Colors',
            style: whiteTextStyle,
          ),
          subtitle: const Text(
            'Using leadingSizeFactor',
            style: white70TextStyle,
          ),
          icon: Icons.account_circle,
          iconColor: Colors.amberAccent,
          leadingSizeFactor: 1.5,
          trailingIconColor: Colors.amberAccent,
        ),
        const SizedBox(height: 20),

        // --- Example 3: .custom with Border & Disabled state passed ---
        Text(
          '3. Custom Header with Border',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.custom(
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.transparent,
          expandedBodyColor: Colors.deepPurple[100],
          elevation: 0,
          borderColor: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16),
          expanded: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Expanded content for custom header.'),
          ),
          customHeaderBuilder:
              (tapAction, isExpanded, isDisabled) => CustomActionButton(
                backgroundColor:
                    isDisabled ? Colors.grey[700] : Colors.deepPurple[700],
                margin: EdgeInsets.zero,
                onPressed: tapAction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Custom Header (Tap to ${isExpanded ? "Collapse" : "Expand"})',
                        style: whiteTextStyle,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
        ),
        const SizedBox(height: 20),

        // --- Example 4: .overlayMenu floats expanded under header, above other UI ---
        Text(
          '4. Overlay Menu Example',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.overlayMenu(
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.deepPurple[700],
          expandedBodyColor: Colors.deepPurple[50],
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          leading: CircleAvatar(radius: 80, backgroundColor: Colors.pink),
          bodyAlignment: Alignment.center,
          leadingSizeFactor: 1.5,
          title: const Text('Overlay Header', style: whiteTextStyle),
          subtitle: const Text('Tap to show overlay', style: white70TextStyle),
          trailingIconColor: Colors.white,
          expanded: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'This content is rendered in an OverlayEntry, staying under the header '
                  'but floating above the rest of the UI.',
                  textAlign: TextAlign.center,
                ),
              ),
              ListTileButton(
                padding: const EdgeInsets.all(16.0),
                body: const Text(
                  'This content is rendered in an OverlayEntry, staying under the header',
                  textAlign: TextAlign.center,
                ),
                onPressed: () => debugPrint('Press!'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // --- Example 5: Disabled .listTile ---
        Text(
          '5. Disabled ListTile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.listTile(
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.blueGrey[800],
          expandedBodyColor: Colors.blueGrey[400],
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10),
          disabled: true,
          // Correctly set to disabled
          expanded: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('This content should not be reachable.'),
          ),
          title: const Text('Disabled Button', style: whiteTextStyle),
          subtitle: const Text('Cannot be expanded', style: white70TextStyle),
          leading: const Icon(Icons.block, color: Colors.white70),
          trailingIconColor: Colors.white70,
        ),
        const SizedBox(height: 20),

        // --- Example 6: Using ExpandableController ---
        Text(
          '6. Controlled Expansion',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const ExpandableControllerExample(),
        const SizedBox(height: 20),

        // --- Original Expandable Animated Card Example (With Fix) ---
        Text('Expandable Animated Card Example', style: titleStyle),
        const SizedBox(height: 20),
        ExpandableAnimatedCard(
          // Explicitly setting a consistent border radius for the expanded state
          borderRadius: BorderRadius.circular(20),
          backgroundColor: Colors.blueGrey.shade700,
          // Slightly darker shade
          headerBackgroundColor: Colors.blueGrey.shade100,
          // Light header
          headerTextColor: Colors.black87,
          overlayBackgroundColor: Colors.white.withCustomOpacity(0.7),
          // Darker scrim
          bottomMargin: MediaQuery.of(context).padding.bottom + 16,

          // Dynamic bottom margin
          collapsedBuilder: (context) {
            // Keep consistent styling with the expanded view if desired
            return Container(
              decoration: BoxDecoration(
                // Match the borderRadius specified for the expanded card
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[700], // Match background color
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Breaking News",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap to read the full story...",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            );
          },
          expandedBuilder: (context) {
            // Ensure the expanded content itself doesn't clash with card background
            // Often good to have the Container here manage padding/color if needed,
            // or ensure children handle their own text colors etc.
            return SingleChildScrollView(
              // Essential for long content
              physics: const AlwaysScrollableScrollPhysics(),
              // Ensure scrolling works even if content is short
              child: Padding(
                // Add padding *inside* the scroll view
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Breaking News",
                      style: TextStyle(
                        fontSize: 22, // Slightly larger in expanded view
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "A brief summary of the news goes here, providing a bit more context than the collapsed view.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Full Article",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Here is the full detailed content of the article. It includes more details, background information, "
                      "and additional commentary that provides a deeper insight into the story. "
                      "The transition is smooth and fluid, ensuring the animation feels persistent and natural. "
                      "This section can be quite long, hence the need for SingleChildScrollView. "
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Additional Information:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "• Detail 1: More data points.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Text(
                      "• Detail 2: Related links or sources.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Text(
                      "• Detail 3: Author information.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    // Add more content to test scrolling
                    const SizedBox(height: 300),
                    const Text(
                      "End of Content",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
          onClose: () {
            debugPrint("Expandable card overlay was closed!");
          },
        ),
      ],
    );
  }
}

/// StatefulWidget to demonstrate using ExpandableController
class ExpandableControllerExample extends StatefulWidget {
  const ExpandableControllerExample({super.key});

  @override
  State<ExpandableControllerExample> createState() =>
      _ExpandableControllerExampleState();
}

class _ExpandableControllerExampleState
    extends State<ExpandableControllerExample> {
  // Create and manage the controller
  late final ExpandableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController(initialExpanded: false);
    _controller.addListener(() {
      // Optional: React to state changes if needed
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // IMPORTANT: Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpandableListTileButton.listTile(
          controller: _controller,
          margin: const EdgeInsets.symmetric(vertical: 8),
          headerBackgroundColor: Colors.orange[700],
          expandedBodyColor: Colors.orange[100],
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10),
          expanded: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('This expansion is controlled externally.'),
          ),
          title: const Text(
            'Externally Controlled',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'Use buttons below',
            style: TextStyle(color: Colors.white70),
          ),
          leading: const Icon(Icons.settings_remote, color: Colors.white),
          trailingIconColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _controller.toggle(),
              child: const Text('Toggle'),
            ),
          ],
        ),
      ],
    );
  }
}
