import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart'; // Assuming this imports ExpandableListTileButton, PaddedChildrenList, etc.

// Assuming CustomActionButton exists and accepts onPressed and child.
// If it needs isDisabled, you'll need to modify it.
class CustomActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final bool disabled; // Assuming it might accept disabled

  const CustomActionButton({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.margin,
    this.disabled = false, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Example border radius
          ),
        ),
        onPressed: disabled ? null : onPressed,
        child: child,
      ),
    );
  }
}

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
          // Use preferred parameter names
          headerBackgroundColor: Colors.teal[700],
          expandedBodyColor: Colors.teal[100],
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          // Custom border radius
          // Align content in the expanded body
          bodyAlignment: Alignment.bottomCenter,
          expanded: Container(
            // No need for width: double.infinity; Column stretches horizontally
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Expanded content aligned to bottom center',
              textAlign: TextAlign.center, // Text alignment within Text widget
            ),
          ),
          title: const Text('Aligned Body Content', style: whiteTextStyle),
          subtitle: const Text('Using bodyAlignment', style: white70TextStyle),
          leading: const Icon(Icons.format_align_center, color: Colors.white),
          trailingIconColor: Colors.white, // Color for the expand/collapse icon
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
          // Use preferred parameter names
          headerBackgroundColor: Colors.indigo[600],
          expandedBodyColor: Colors.indigo[100],
          elevation: 6.0,
          borderRadius: BorderRadius.circular(8),
          // Different radius
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
          // Custom icon color
          leadingSizeFactor: 1.5,
          // Make icon larger
          trailingIconColor: Colors.amberAccent, // Match icon color
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
          // Use preferred parameter names
          // Set header bg to transparent if custom header has its own bg
          headerBackgroundColor: Colors.transparent,
          expandedBodyColor: Colors.deepPurple[100],
          elevation: 0,
          // Set elevation to 0 to see border clearly
          borderColor: Colors.deepPurple,
          // Add a border
          borderRadius: BorderRadius.circular(16),
          // Larger radius
          expanded: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Expanded content for custom header.'),
          ),
          // Pass disabled state to the custom builder
          customHeaderBuilder:
              (tapAction, isExpanded, isDisabled) => CustomActionButton(
                // Example: Custom header handles its own background and disabled state
                backgroundColor:
                    isDisabled ? Colors.grey[700] : Colors.deepPurple[700],
                margin: EdgeInsets.zero,
                // Let Expandable handle margin
                onPressed: tapAction,
                // Use the provided tapAction
                disabled: isDisabled,
                // Pass disabled state
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  // Add padding inside button
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

        // --- Example 4: Disabled .listTile ---
        Text(
          '4. Disabled ListTile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpandableListTileButton.listTile(
          margin: const EdgeInsets.symmetric(vertical: 8),
          // Use preferred parameter names
          headerBackgroundColor: Colors.blueGrey[800],
          // Darker when disabled
          expandedBodyColor: Colors.blueGrey[400],
          elevation: 2.0,
          // Lower elevation maybe
          borderRadius: BorderRadius.circular(10),
          // Explicitly set disabled to true
          disabled: true,
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

        // --- Example 5: Using ExpandableController ---
        Text(
          '5. Controlled Expansion',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Use a StatefulWidget to manage the controller
        const ExpandableControllerExample(),
        const SizedBox(height: 20),

        // --- Original Expandable Animated Card Example (Unchanged) ---
        Text('Expandable Animated Card Example', style: titleStyle),
        const SizedBox(height: 20),
        ExpandableAnimatedCard(
          backgroundColor: Colors.blueGrey,
          collapsedBuilder: (context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey,
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
                    "A brief summary of the news goes here...",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            );
          },
          expandedBuilder: (context) {
            // Note: expandedBuilder in ExpandableAnimatedCard might not need SingleChildScrollView
            // if the card itself handles scrolling or sizing appropriately.
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.blueGrey[100], // Lighter background when expanded
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Breaking News",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A brief summary of the news goes here...",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Full Article",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Here is the full detailed content of the article. It includes more details, background information, "
                    "and additional commentary that provides a deeper insight into the story. "
                    "The transition is smooth and fluid, ensuring the animation feels persistent and natural.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Additional Information:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("• Detail 1", style: TextStyle(fontSize: 16)),
                  Text("• Detail 2", style: TextStyle(fontSize: 16)),
                  Text("• Detail 3", style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
          onClose: () {
            // Example: Show a snackbar or just log
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Expandable Card Closed')),
            );
            // If used in an overlay, pop: Navigator.of(context).pop();
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
    // Optional: Add listener to react to state changes
    _controller.addListener(() {
      // print("Controller state changed: ${_controller.isExpanded}");
      // You might call setState here if external UI needs to update based on controller state
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
          // Pass the controller to the widget
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
        // Buttons to control the ExpandableListTileButton via the controller
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _controller.expand(),
              child: const Text('Expand'),
            ),
            ElevatedButton(
              onPressed: () => _controller.toggle(),
              child: const Text('Toggle'),
            ),
            ElevatedButton(
              onPressed: () => _controller.collapse(),
              child: const Text('Collapse'),
            ),
          ],
        ),
      ],
    );
  }
}
