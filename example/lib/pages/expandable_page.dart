import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ExpandablePage extends StatelessWidget {
  const ExpandablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    const whiteTextStyle = TextStyle(color: Colors.white);
    const white70TextStyle = TextStyle(color: Colors.white70);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Expandables')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Expandable List Tile Button Examples', style: titleStyle),
          const SizedBox(height: 20),

          // --- Example 1: .listTile with Alignment & BorderRadius ---
          Text(
            '1. ListTile with Body Alignment & Padding',
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
            headerPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            headerBodyPadding: const EdgeInsets.only(left: 16),
            expanded: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Expanded content aligned to bottom center',
                textAlign: TextAlign.center,
              ),
            ),
            title: const Text('Spacious Header', style: whiteTextStyle),
            subtitle: const Text(
              'Using headerPadding & headerBodyPadding',
              style: white70TextStyle,
            ),
            leading: const Icon(Icons.format_align_center, color: Colors.white),
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
                  backgroundColor: Colors.deepPurple[700],
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
            leading: const CircleAvatar(
              radius: 80,
              backgroundColor: Colors.pink,
            ),
            bodyAlignment: Alignment.center,
            leadingSizeFactor: 1.5,
            title: const Text('Overlay Header', style: whiteTextStyle),
            subtitle: const Text(
              'Tap to show overlay',
              style: white70TextStyle,
            ),
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

          // --- Example 5: Disabled Expansion vs Fully Disabled ---
          Text(
            '5. Disabled States',
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
            expanded: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('This content should not be reachable.'),
            ),
            title: const Text(
              'Active Header, Disabled Expansion',
              style: whiteTextStyle,
            ),
            subtitle: const Text(
              'Tap me! I show a ripple effect, but I do not expand and the chevron is hidden.',
              style: white70TextStyle,
            ),
            leading: const Icon(Icons.block, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          ExpandableListTileButton.listTile(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.blueGrey[800],
            expandedBodyColor: Colors.blueGrey[400],
            elevation: 2.0,
            borderRadius: BorderRadius.circular(10),
            headerDisabled: true,
            expanded: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('This content should not be reachable.'),
            ),
            title: const Text('Fully Disabled Header', style: whiteTextStyle),
            subtitle: const Text(
              'Semi-transparent, completely ignores touches.',
              style: white70TextStyle,
            ),
            leading: const Icon(Icons.close, color: Colors.white70),
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

          // --- Example 7: Constrained Sizing & Padding ---
          Text(
            '7. Constrained Sizing & Padding',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ExpandableListTileButton.listTile(
            margin: const EdgeInsets.symmetric(vertical: 8),
            headerBackgroundColor: Colors.brown[600],
            expandedBodyColor: Colors.brown[100],
            headerMinHeight: 120,
            headerContentAlignment: Alignment.center,
            leadingPadding: const EdgeInsets.only(left: 32),
            trailingPadding: const EdgeInsets.only(right: 32),
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            expanded: Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Expanded content.'),
            ),
            title: const Text('Constrained Header', style: whiteTextStyle),
            subtitle: const Text(
              'minHeight 120, centered content',
              style: white70TextStyle,
            ),
            leading: const Icon(Icons.height, color: Colors.white),
            trailingIconColor: Colors.white,
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),

          Text('Animated Overlay Cards', style: titleStyle),
          const SizedBox(height: 8),
          Text(
            'Cards that break out of the layout hierarchy to animate over the entire screen, utilizing RistoDecorator for perfect shadows and our new blurSigma glass effect.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // --- Animated Card 1: Standard Overlay with Blur ---
          ExpandableAnimatedCard(
            backgroundColor: Colors.blueGrey.shade700,
            borderRadius: BorderRadius.circular(20),
            elevation: 8.0,
            blurSigma: 6.0,
            overlayBackgroundColor: Colors.black.withCustomOpacity(0.4),
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
            collapsedBuilder:
                (_) => const _DemoTile(
                  color: Color(0xFF455A64),
                  title: 'Standard Overlay Card (Blurred)',
                ),
            expandedBuilder:
                (_) => const SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This card perfectly scales up, blurring the background underneath it via blurSigma: 6.0.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          ),

          const SizedBox(height: 24),

          // --- Animated Card 2: Fullscreen ---
          ExpandableAnimatedCard.fullscreen(
            barrierColor: Colors.blue.withCustomOpacity(0.5),
            overlayBackgroundColor: Colors.black.withCustomOpacity(0.8),
            blurSigma: 8.0,
            collapsedBuilder:
                (_) => const _DemoTile(
                  color: Color(0xFF303F9F),
                  title: 'Fullscreen Story Style',
                ),
            expandedBuilder:
                (_) => Container(
                  margin: const EdgeInsets.all(20),
                  color: const Color(0xFF121212),
                  alignment: Alignment.center,
                  child: const Text(
                    'Fullscreen edge-to-edge content...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          ),

          const SizedBox(height: 24),

          // --- Animated Card 3: Bottom Sheet ---
          ExpandableAnimatedCard.sheet(
            margin: const EdgeInsets.all(16),
            maxHeightFraction: 0.60,
            dragDismissThresholdFraction: 0.20,
            overlayBackgroundColor: Colors.blue.withCustomOpacity(0.6),
            blurSigma: 12.0,
            elevation: 12.0,
            dragToClose: true,
            backgroundColor: Colors.brown.shade700,
            collapsedBuilder:
                (_) => const _DemoTile(
                  color: Color(0xFF5D4037),
                  title: 'Bottom Sheet Style',
                ),
            expandedBuilder:
                (_) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'This behaves exactly like a bottom sheet. You can drag it down to dismiss it!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
          ),

          const SizedBox(height: 24),

          // --- Animated Card 4: Action Menu ---
          Text(
            '8. Bubble Menu Style',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ExpandableAnimatedCard.menu(
              menuWidth: 220,
              menuHeight: 280,
              menuOffset: 24.0,
              // Floating slightly above the button
              backgroundColor: Colors.pink.shade100,
              // Matching your screenshot
              corner: 24.0,
              elevation: 12.0,
              overlayBackgroundColor: Colors.black12,
              collapsedBuilder:
                  (context) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu, color: Colors.indigo),
                  ),
              expandedBuilder:
                  (context) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Menu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile'),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final Color color;
  final String title;

  const _DemoTile({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return RistoDecorator(
      backgroundColor: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 4.0,
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
            'Tap to expand',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ExpandableControllerExample extends StatefulWidget {
  const ExpandableControllerExample({super.key});

  @override
  State<ExpandableControllerExample> createState() =>
      _ExpandableControllerExampleState();
}

class _ExpandableControllerExampleState
    extends State<ExpandableControllerExample> {
  late final ExpandableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController(initialExpanded: false);
  }

  @override
  void dispose() {
    _controller.dispose();
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
        CustomActionButton.elevated(
          onPressed: () => _controller.toggle(),
          minHeight: 40,
          child: const Text('Toggle State'),
        ),
      ],
    );
  }
}
