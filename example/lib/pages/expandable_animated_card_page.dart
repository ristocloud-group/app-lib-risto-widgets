import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ExpandableAnimatedCardPage extends StatefulWidget {
  const ExpandableAnimatedCardPage({super.key});

  @override
  State<ExpandableAnimatedCardPage> createState() =>
      _ExpandableAnimatedCardPageState();
}

class _ExpandableAnimatedCardPageState
    extends State<ExpandableAnimatedCardPage> {
  // Controller for demonstrating programmatic interaction
  late final ExpandableAnimatedCardController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = ExpandableAnimatedCardController();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Animated Overlay Cards')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ===================================================================
          // 1. STANDARD OVERLAYS
          // ===================================================================
          const _SectionHeader(
            title: '1. Dialogs & Overlays',
            icon: Icons.layers,
          ),

          // --- Overlay A: Standard Dark Blur ---
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
              MediaQuery.paddingOf(context).bottom + 16,
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
                  title: 'Standard Overlay (Dark Blur)',
                  subtitle: 'Uses headerBuilder & blurSigma',
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
          const SizedBox(height: 16),

          // --- Overlay B: Gradient & Light Glassmorphism ---
          ExpandableAnimatedCard(
            backgroundGradient: const LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            elevation: 16.0,
            blurSigma: 12.0,
            // Heavy blur
            overlayBackgroundColor: Colors.white.withCustomOpacity(0.2),
            // Light glass scrim
            headerMode: HeaderMode.none,
            // Disable default header to build our own
            collapsedBuilder:
                (_) => const _DemoTile(
                  color: Color(0xFF8E2DE2),
                  title: 'Gradient & Light Glass',
                  subtitle: 'HeaderMode.none & backgroundGradient',
                ),
            expandedBuilder:
                (context) => Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Stunning Gradients!\nNo default header required.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
          const SizedBox(height: 32),

          // ===================================================================
          // 2. FULLSCREEN
          // ===================================================================
          const _SectionHeader(title: '2. Fullscreen', icon: Icons.fullscreen),

          ExpandableAnimatedCard.fullscreen(
            barrierColor: Colors.blue.withCustomOpacity(0.5),
            overlayBackgroundColor: Colors.black.withCustomOpacity(0.8),
            blurSigma: 8.0,
            collapsedBuilder:
                (_) => const _DemoTile(
                  color: Color(0xFF303F9F),
                  title: 'Fullscreen Story Style',
                  subtitle: 'Edge-to-edge content',
                ),
            expandedBuilder:
                (context) => Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      color: const Color(0xFF121212),
                      alignment: Alignment.center,
                      child: const Text(
                        'Fullscreen edge-to-edge content...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.paddingOf(context).top + 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
          ),
          const SizedBox(height: 32),

          // ===================================================================
          // 3. BOTTOM SHEETS
          // ===================================================================
          const _SectionHeader(
            title: '3. Bottom Sheets',
            icon: Icons.vertical_align_bottom,
          ),

          // --- Sheet A: Drag to Dismiss ---
          ExpandableAnimatedCard.sheet(
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
                  title: 'Draggable Bottom Sheet',
                  subtitle: 'dragToClose: true',
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
          const SizedBox(height: 16),

          // --- Sheet B: Programmatically Controlled ---
          ExpandableAnimatedCard.sheet(
            controller: _sheetController,
            autoOpenOnTap: false,
            // Prevent normal tap from opening it
            maxHeightFraction: 0.40,
            backgroundColor: Colors.indigo.shade700,
            collapsedBuilder:
                (_) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade100,
                      foregroundColor: Colors.indigo.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _sheetController.open(),
                    // Open programmatically!
                    icon: const Icon(Icons.gamepad),
                    label: const Text('Open Sheet via Controller'),
                  ),
                ),
            expandedBuilder:
                (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Controlled Externally',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _sheetController.close(),
                      // Close programmatically!
                      child: const Text('Close via Controller'),
                    ),
                  ],
                ),
          ),
          const SizedBox(height: 32),

          // ===================================================================
          // 4. POP-UP MENUS
          // ===================================================================
          const _SectionHeader(title: '4. Pop-up Menus', icon: Icons.ads_click),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4B4A54),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Anchoring Demonstrations',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),

                // --- TOP ROW (Anchors Upwards) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Left
                    ExpandableAnimatedCard.menu(
                      menuWidth: 180,
                      menuHeight: 180,
                      menuOffset: 12.0,
                      menuAlignment: Alignment.topLeft,
                      // Grows UP and RIGHT
                      backgroundColor: Colors.teal.shade50,
                      elevation: 12.0,
                      collapsedBuilder:
                          (context) => const _CircleButton(
                            icon: Icons.filter_alt,
                            color: Colors.teal,
                          ),
                      expandedBuilder:
                          (context) => const Center(
                            child: Text(
                              'Top-Left\nAnchor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    ),

                    // Top Right
                    ExpandableAnimatedCard.menu(
                      menuWidth: 180,
                      menuHeight: 180,
                      menuOffset: 12.0,
                      menuAlignment: Alignment.topRight,
                      // Grows UP and LEFT
                      backgroundColor: Colors.pink.shade50,
                      elevation: 12.0,
                      collapsedBuilder:
                          (context) => const _CircleButton(
                            icon: Icons.person,
                            color: Colors.pink,
                          ),
                      expandedBuilder:
                          (context) => const Center(
                            child: Text(
                              'Top-Right\nAnchor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // --- BOTTOM ROW (Anchors Downwards - Dark Mode) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bottom Left
                    ExpandableAnimatedCard.menu(
                      menuWidth: 180,
                      menuHeight: 250,
                      menuOffset: 8.0,
                      menuAlignment: Alignment.bottomLeft,
                      // Grows DOWN and RIGHT
                      backgroundColor: const Color(0xFF28292D),
                      elevation: 12.0,
                      overlayBackgroundColor: Colors.transparent,
                      collapsedBuilder:
                          (context) => const _CircleButton(
                            icon: Icons.more_vert,
                            color: Color(0xFF4A3298),
                            bgColor: Color(0xFFD0C4F4),
                          ),
                      expandedBuilder:
                          (context) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _DarkMenuItem(
                                  title: 'Refresh',
                                  trailing: Icons.refresh,
                                  onTap: () => Navigator.pop(context),
                                ),
                                _DarkMenuItem(
                                  title: 'Settings',
                                  trailing: Icons.settings_outlined,
                                  onTap: () => Navigator.pop(context),
                                ),
                                _DarkMenuItem(
                                  title: 'Help',
                                  trailing: Icons.help_outline,
                                  onTap: () => Navigator.pop(context),
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 16,
                                ),
                                _DarkMenuItem(
                                  title: 'More',
                                  trailing: Icons.more_vert,
                                  onTap: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                    ),

                    // Bottom Right
                    ExpandableAnimatedCard.menu(
                      menuWidth: 220,
                      menuHeight: 280,
                      menuOffset: 8.0,
                      menuAlignment: Alignment.bottomRight,
                      // Grows DOWN and LEFT
                      backgroundColor: const Color(0xFF28292D),
                      elevation: 12.0,
                      overlayBackgroundColor: Colors.transparent,
                      collapsedBuilder:
                          (context) => Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD0C4F4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color(0xFF4A3298),
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Label',
                                      style: TextStyle(
                                        color: Color(0xFF4A3298),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const _CircleButton(
                                icon: Icons.keyboard_arrow_up,
                                color: Color(0xFF4A3298),
                                bgColor: Color(0xFFD0C4F4),
                              ),
                            ],
                          ),
                      expandedBuilder:
                          (context) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _DarkMenuItem(
                                  title: 'Item 1',
                                  leading: Icons.remove_red_eye_outlined,
                                  onTap: () => Navigator.pop(context),
                                ),
                                _DarkMenuItem(
                                  title: 'Item 2',
                                  leading: Icons.content_copy,
                                  trailingText: '⌘C',
                                  onTap: () => Navigator.pop(context),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6B4A55),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: _DarkMenuItem(
                                    title: 'Item 3',
                                    leading: Icons.check,
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white12,
                                  height: 16,
                                ),
                                _DarkMenuItem(
                                  title: 'Item 4',
                                  leading: Icons.person_outline,
                                  trailing: Icons.arrow_right,
                                  onTap: () => Navigator.pop(context),
                                ),
                                _DarkMenuItem(
                                  title: 'Item 5',
                                  leading: Icons.settings_outlined,
                                  onTap: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ===========================================================================
// UTILITY WIDGETS FOR DEMO
// ===========================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const _DemoTile({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
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
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? bgColor;

  const _CircleButton({required this.icon, required this.color, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor ?? color,
        shape: BoxShape.circle,
        boxShadow:
            bgColor == null
                ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Icon(icon, color: bgColor == null ? Colors.white : color),
    );
  }
}

class _DarkMenuItem extends StatelessWidget {
  final String title;
  final IconData? leading;
  final IconData? trailing;
  final String? trailingText;
  final VoidCallback onTap;

  const _DarkMenuItem({
    required this.title,
    this.leading,
    this.trailing,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[
              Icon(leading, color: Colors.white70, size: 20),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            if (trailing != null)
              Icon(trailing, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
