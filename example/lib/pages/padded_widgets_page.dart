import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class PaddedWidgetsPage extends StatelessWidget {
  const PaddedWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Padded Widgets Demo')),
      body: PaddedChildrenList.only(
        top: 24,
        children: [
          _sectionTitle('PaddingWrapper examples'),
          
          PaddingWrapper.all(
            padding: 24,
            child: const RistoDecorator(
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(16),
              child: Text('Uniform padding (24.0) via PaddingWrapper.all'),
            ),
          ),

          PaddingWrapper.symmetric(
            horizontal: 40,
            vertical: 12,
            child: RistoDecorator(
              backgroundColor: Colors.blue.shade50,
              padding: const EdgeInsets.all(16),
              child: const Text('Symmetric padding (H:40, V:12)'),
            ),
          ),

          PaddingWrapper.only(
            left: 64,
            child: RistoDecorator(
              backgroundColor: Colors.orange.shade50,
              padding: const EdgeInsets.all(16),
              child: const Text('Specific side padding (Left: 64)'),
            ),
          ),

          const SizedBox(height: 32),
          _sectionTitle('PaddedChildrenList layout'),
          const Text(
            'The items below are children of a PaddedChildrenList, '
            'which automatically handles spacing and standard page margins.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          
          ...List.generate(3, (index) => ListTileButton(
            body: Text('List Item ${index + 1}'),
            subtitle: const Text('Automatically padded by the parent list'),
            leading: CircleAvatar(child: Text('${index + 1}')),
            onPressed: () {},
          )),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
