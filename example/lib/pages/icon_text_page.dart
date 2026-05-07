import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class IconTextPage extends StatelessWidget {
  const IconTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomIconText Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Standard Layout'),
            const CustomIconText(
              icon: Icons.info_outline,
              text: 'This is a standard informational text.',
            ),
            const SizedBox(height: 24),

            _sectionTitle('Custom Colors'),
            CustomIconText(
              icon: Icons.check_circle,
              text: 'Operation completed successfully!',
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 12),
            const CustomIconText(
              icon: Icons.error_outline,
              text: 'Something went wrong. Please try again.',
              color: Colors.red,
            ),
            const SizedBox(height: 24),

            _sectionTitle('Alignment & Spacing'),
            const RistoDecorator(
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
              elevation: 1,
              child: CustomIconText(
                icon: Icons.star,
                text: 'Aligned to the start',
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 16,
              ),
            ),
            const SizedBox(height: 12),
            const RistoDecorator(
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
              elevation: 1,
              child: CustomIconText(
                icon: Icons.thumb_up_alt_outlined,
                text: 'Aligned to the center',
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Multiline Support'),
            const SizedBox(
              width: 250,
              child: CustomIconText(
                icon: Icons.description_outlined,
                text: 'This is a longer text that will definitely span multiple lines to demonstrate the vertical alignment and wrapping capabilities.',
                maxLines: 4,
                spacing: 12,
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Large Scale'),
            const CustomIconText(
              icon: Icons.rocket_launch,
              text: 'LAUNCH READY',
              iconSize: 48,
              spacing: 16,
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
