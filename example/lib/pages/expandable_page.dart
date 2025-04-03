import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ExpandablePage extends StatelessWidget {
  const ExpandablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedChildrenList(
      children: [
        Text(
          'Expandable List Tile Button',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),

        // Standard Expandable List Tile Button
        ExpandableListTileButton.listTile(
          backgroundColor: Colors.blueGrey[600],
          expandedColor: Colors.blue[300],
          expanded: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text('Expanded content goes here'),
          ),
          title: const Text(
            'Expandable ListTile Button',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'Subtitle Text',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 20),

        // Icon List Tile Button with Expandable
        ExpandableListTileButton.iconListTile(
          backgroundColor: Colors.blueGrey[600],
          expandedColor: Colors.blue[300],
          expanded: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text('Expanded content goes here'),
          ),
          title: const Text(
            'Expandable IconListTile Button',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'Subtitle Text',
            style: TextStyle(color: Colors.white70),
          ),
          icon: Icons.account_circle,
          iconColor: Colors.white,
          sizeFactor: 2,
        ),
        const SizedBox(height: 20),

        // Custom Header with Expandable Content
        ExpandableListTileButton.custom(
          backgroundColor: Colors.blueGrey[600],
          expandedColor: Colors.blue[300],
          expanded: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text('Expanded content goes here'),
          ),
          customHeader: (tapAction, isExpanded) => CustomActionButton(
            backgroundColor: Colors.blueGrey[600],
            margin: EdgeInsets.zero,
            onPressed: () => tapAction.call(),
            child: const Center(
              child: Text(
                'Expandable CustomHeader Button',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Expandable Animated Card Example
        Text(
          'Expandable Animated Card Example',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        ExpandableAnimatedCard(
          // Explicitly setting a consistent border radius
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A brief summary of the news goes here...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
          expandedBuilder: (context) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blueGrey,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Breaking News",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "A brief summary of the news goes here...",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Full Article",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text("• Detail 1", style: TextStyle(fontSize: 16)),
                    Text("• Detail 2", style: TextStyle(fontSize: 16)),
                    Text("• Detail 3", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
          onClose: () {
            // Dismiss the overlay by popping it from the Navigator.
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
