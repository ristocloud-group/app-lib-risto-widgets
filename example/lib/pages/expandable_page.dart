import 'package:flutter/material.dart';

import 'expandable_animated_card_page.dart';
import 'expandable_list_tile_page.dart';

class ExpandablePage extends StatelessWidget {
  const ExpandablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Expandable Components')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            title: '1. Expandable List Tiles',
            subtitle: 'Inline expanding accordions and buttons.',
            icon: Icons.unfold_more,
            destination: const ExpandableListTilePage(),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            context,
            title: '2. Animated Overlay Cards',
            subtitle: 'Floating menus, Bottom Sheets, and Fullscreen overlays.',
            icon: Icons.layers,
            destination: const ExpandableAnimatedCardPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade50,
          child: Icon(icon, color: Colors.deepPurple.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            ),
      ),
    );
  }
}
