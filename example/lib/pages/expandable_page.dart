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
          headerBackgroundColor: Colors.blueGrey,
          expandedBodyColor: Colors.grey,
          elevation: 1,
          borderColor: Colors.blue,
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

        // 1) Overlay card (free ctor) with custom header
        ExpandableAnimatedCard(
          expandedDecoration: BoxDecoration(
            color: Colors.blueGrey.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          expandedMargin: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          headerMode: HeaderMode.overlay,
          headerHeight: 40,
          headerBuilder:
              (ctx, close) => Material(
                color: Colors.blueGrey.shade100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.black87,
                      iconSize: 18,
                      onPressed: close,
                      tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Details',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          overlayBackgroundColor: Colors.black.withCustomOpacity(0.6),
          collapsedBuilder:
              (_) => _DemoTile(
                color: Colors.blueGrey.shade700,
                title: 'Breaking News',
              ),
          expandedBuilder:
              (_) => const SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Full article...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          onOpened: () => debugPrint('Default: opened'),
          onClosed: () => debugPrint('Default: closed'),
          onStateChanged: (open) => debugPrint('Default: state=$open'),
        ),

        const SizedBox(height: 24),

        // 2) Fullscreen factory (header OFF, no drag-to-dismiss)
        ExpandableAnimatedCard.fullscreen(
          collapsedBuilder:
              (_) => _DemoTile(
                color: Colors.indigo.shade700,
                title: 'Fullscreen Story',
              ),
          expandedBuilder:
              (_) => Container(
                color: const Color(0xFF121212),
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                child: const Text(
                  'Fullscreen content...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
        ),

        const SizedBox(height: 24),

        // Sheet clamped to 60% of screen height, dismiss if user drags ≥ 20% of that height
        ExpandableAnimatedCard.sheet(
          margin: const EdgeInsets.all(16),
          maxHeightFraction: 0.60,
          // or: maxHeight: 480,
          dragDismissThresholdFraction: 0.20,
          // 20% of final clamped height
          dragToClose: true,
          collapsedBuilder:
              (_) =>
                  _DemoTile(color: Colors.brown.shade700, title: 'Sheet Style'),
          expandedBuilder:
              (_) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sheet content...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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

// Tiny helper for the examples
class _DemoTile extends StatelessWidget {
  final Color color;
  final String title;

  const _DemoTile({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap to open',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
