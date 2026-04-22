import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ExpandableListTilePage extends StatelessWidget {
  const ExpandableListTilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const whiteTextStyle = TextStyle(color: Colors.white);
    const white70TextStyle = TextStyle(color: Colors.white70);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Expandable List Tiles')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Continuous vs Floating Styles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 1. Continuous Default Tile
          ExpandableListTileButton.listTile(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.teal[700],
            expandedBodyColor: Colors.teal[100],
            elevation: 4.0,
            borderRadius: BorderRadius.circular(16),
            continuous: true,
            // Default: Corners flatten out
            headerPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            expanded: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Notice how the header perfectly flattens its bottom corners to merge with this body.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            title: const Text(
              'Continuous Style (Default)',
              style: whiteTextStyle,
            ),
            subtitle: const Text('continuous: true', style: white70TextStyle),
            leading: const Icon(Icons.merge_type, color: Colors.white),
            trailingIconColor: Colors.white,
          ),

          // 2. Floating / Layered Tile
          ExpandableListTileButton.iconListTile(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.indigo[600],
            expandedBodyColor: Colors.indigo[100],
            elevation: 8.0,
            borderRadius: BorderRadius.circular(16),
            continuous: false,
            // The header remains fully rounded
            expanded: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'The header above keeps its rounded corners, and this body slides out from underneath it!',
                style: TextStyle(fontSize: 16),
              ),
            ),
            title: const Text('Layered Floating Style', style: whiteTextStyle),
            subtitle: const Text('continuous: false', style: white70TextStyle),
            icon: Icons.layers,
            iconColor: Colors.amberAccent,
            leadingSizeFactor: 1.5,
            trailingIconColor: Colors.amberAccent,
          ),

          const SizedBox(height: 24),
          const Text(
            'Advanced Features',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 3. Custom Trailing Icons (Add/Remove)
          ExpandableListTileButton.listTile(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.blueGrey.shade800,
            expandedBodyColor: Colors.blueGrey.shade50,
            elevation: 4.0,
            shadowColor: Colors.blueGrey.shade200,
            borderRadius: BorderRadius.circular(16),
            continuous: false,
            trailingBuilder:
                (isExpanded, isDisabled) => Icon(
                  isExpanded ? Icons.close : Icons.add,
                  color: Colors.orangeAccent,
                ),
            animationDuration: const Duration(milliseconds: 600),
            animationCurve: Curves.elasticOut,
            title: const Text('Custom Trailing UI', style: whiteTextStyle),
            subtitle: const Text(
              'Elastic Out Animation Curve',
              style: white70TextStyle,
            ),
            expanded: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Notice how this opens with a fun bounce, and the trailing icon changes entirely!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          // 4. Overlay Menu (Floats above other UI)
          ExpandableListTileButton.overlayMenu(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.pink.shade700,
            expandedBodyColor: Colors.pink.shade50,
            elevation: 8.0,
            shadowColor: Colors.pink.shade200,
            borderRadius: BorderRadius.circular(12),
            continuous: false,
            // Overlays look great with the floating style
            title: const Text('Overlay Menu Tile', style: whiteTextStyle),
            subtitle: const Text(
              'My expanded body floats above everything!',
              style: white70TextStyle,
            ),
            trailingIconColor: Colors.white,
            expanded: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'This content is rendered in an OverlayEntry.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Action 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Action 2'),
                  ),
                ],
              ),
            ),
          ),

          // Filler content to prove the overlay floats above it
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade400,
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              'This box sits below the Overlay Menu. If you open the pink tile above, '
              'it will float right over this text without pushing it down!',
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Professional Patterns',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 5. The Lazy Loader (Async Data)
          const _AsyncTileDemo(),

          // 6. Accordion Group (Only one open)
          const SizedBox(height: 24),
          const Text(
            'Accordion Group',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const _AccordionGroupDemo(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ===========================================================================
// UTILITY DEMO 1: Lazy Loading Async Data
// ===========================================================================
class _AsyncTileDemo extends StatefulWidget {
  const _AsyncTileDemo();

  @override
  State<_AsyncTileDemo> createState() => _AsyncTileDemoState();
}

class _AsyncTileDemoState extends State<_AsyncTileDemo> {
  final ExpandableController _controller = ExpandableController();
  bool _hasFetchedData = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.expanded && !_hasFetchedData) {
        setState(() => _hasFetchedData = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "This data was securely fetched from the server *only* when you opened the tile!";
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableListTileButton.async(
      controller: _controller,
      headerBackgroundColor: Colors.black87,
      expandedBodyColor: Colors.grey.shade200,
      continuous: false,
      title: const Text(
        'Lazy Load Data',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: const Text(
        'Fetches server data only on first open',
        style: TextStyle(color: Colors.white70),
      ),
      leading: const Icon(
        Icons.cloud_download_outlined,
        color: Colors.blueAccent,
      ),
      trailingIconColor: Colors.white,
      fetchExpandedContent: () async {
        final data = await _fetchData();
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(data, style: const TextStyle(fontSize: 16)),
        );
      },
    );
  }
}

// ===========================================================================
// UTILITY DEMO 2: Accordion Controller Group
// ===========================================================================
class _AccordionGroupDemo extends StatelessWidget {
  const _AccordionGroupDemo();

  @override
  Widget build(BuildContext context) {
    return ExpandableAccordionGroup(
      children: List.generate(3, (index) {
        return ExpandableListTileButton.listTile(
          margin: const EdgeInsets.only(bottom: 8),
          headerBackgroundColor: Colors.brown.shade600,
          expandedBodyColor: Colors.brown.shade50,
          title: Text(
            'Settings Category ${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
          trailingIconColor: Colors.white,
          expanded: const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Only one of these settings categories can be open at a time. Opening another closes me automatically!',
            ),
          ),
        );
      }),
    );
  }
}
