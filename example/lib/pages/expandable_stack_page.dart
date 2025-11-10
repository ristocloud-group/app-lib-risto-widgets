import 'package:flutter/material.dart';
import 'package:risto_widgets/widgets/popup/open_custom_sheet.dart';

class ExpandableStackPage extends StatelessWidget {
  const ExpandableStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(title: const Text('Expandable Stack Example')),
      floatingActionButton: OpenCustomSheet.expandable(
        context,
        presentAsRoute: false,
        initialChildSize: 0.25,
        minChildSize: 0.25,
        maxChildSize: 0.8,
        backgroundColor: const Color(0xFF0A4F70),
        header: const Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Text(
            'Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body:
            ({scrollController}) => ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: 10,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly transport fee',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '€30.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0x33FFFFFF), height: 1),
                      ],
                    ),
                  ),
            ),
        footer: _buildPersistentFooter(context),
      ).buildExpandable(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildPersistentFooter(BuildContext context, {VoidCallback? onClose}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total amount:', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 4),
              Text(
                '€30.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: onClose,
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A4F70),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
