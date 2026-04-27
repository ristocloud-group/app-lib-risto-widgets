import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

import 'expandable_stack_page.dart';

class CustomSheetPage extends StatefulWidget {
  const CustomSheetPage({super.key});

  @override
  State<CustomSheetPage> createState() => _CustomSheetPageState();
}

class _CustomSheetPageState extends State<CustomSheetPage> {
  bool _isOverlayVisible = false;
  final ExpandableController _expandCtrl = ExpandableController(
    initialExpanded: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Sheet Examples')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Confirm sheet
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet.openConfirmSheet(
                    context,
                    body: const Text('Are you sure you want to proceed?'),
                  ).show(context);
                },
                child: const Text('Open Confirm Sheet'),
              ),

              // 2. Scrollable sheet
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet.scrollableSheet(
                    context,
                    body:
                        ({scrollController}) => ListView.builder(
                          controller: scrollController,
                          itemCount: 30,
                          itemBuilder:
                              (context, i) => ListTile(title: Text('Item $i')),
                        ),
                  ).show(context);
                },
                child: const Text('Open Scrollable Sheet'),
              ),

              // 3. Standard custom form sheet
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet(
                    expand: false,
                    body:
                        ({scrollController}) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Details',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                  ).show(context);
                },
                child: const Text('Open Custom Form Sheet'),
              ),

              // 4. Draggable Planner Sheet
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet(
                    enableDrag: true,
                    expand: false,
                    initialChildSize: 0.85,
                    minChildSize: 0.8,
                    maxChildSize: 0.95,
                    sheetPadding: EdgeInsets.zero,
                    body: ({scrollController}) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Aprile 2026',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),

                          // Simulated mock content replacing the calendar
                          ...List.generate(7, (index) {
                            final date = DateTime.now().add(
                              Duration(days: index),
                            );
                            return CheckboxListTile(
                              value: index == 3,
                              onChanged: (val) {},
                              title: Text('Giorno ${date.day}/${date.month}'),
                              subtitle: const Text('Disponibile per assenza'),
                              secondary: const Icon(
                                Icons.calendar_month,
                                color: Colors.blueGrey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                            );
                          }),

                          // Footer Message
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "Seleziona il giorno finale oppure\nconferma l'assenza singola",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                          // Action Buttons
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24.0,
                              right: 24.0,
                              bottom: 24.0,
                            ),
                            child: DoubleListTileButtons(
                              expanded: true,
                              space: 12,
                              firstButton: CustomActionButton.flat(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                borderColor: const Color(0xFF003859),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Annulla',
                                  style: TextStyle(
                                    color: Color(0xFF003859),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              secondButton: CustomActionButton.elevated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: const Color(0xFF003859),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Conferma',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).show(context);
                },
                child: const Text('Open Absence Planner (Fixed Shrink-Wrap)'),
              ),

              // 5. Expandable overlay trigger
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  setState(() => _isOverlayVisible = true);
                },
                child: const Text('Show Expandable Stack'),
              ),
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet.expandable(
                    context,
                    header: const Center(child: Text("Test Header")),
                    body:
                        ({scrollController}) =>
                            Container(height: 200, color: Colors.red),
                    footer: const Center(child: Text("Test Footer")),
                  ).show(context);
                },
                child: const Text('Show Expandable Overlay'),
              ),
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpandableStackPage(),
                    ),
                  );
                },
                child: const Text('Show Expandable Stack in page'),
              ),
            ],
          ),

          // Expandable overlay rendered in the same route using the new factory
          if (_isOverlayVisible)
            Align(
              alignment: Alignment.bottomCenter,
              child: OpenCustomSheet.expandable(
                context,
                controller: _expandCtrl,
                presentAsRoute: false,
                initialChildSize: 0.25,
                minChildSize: 0.25,
                maxChildSize: 0.8,
                backgroundColor: const Color(0xFF0A4F70),
                header: const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Text(
                    'Recap',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Monthly subscription',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '30,00€',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(
                                  color: Color(0x33FFFFFF),
                                  height: 1,
                                ),
                              ],
                            ),
                          ),
                    ),
                footer: _buildPersistentFooter(
                  context,
                  onClose: () {
                    setState(() => _isOverlayVisible = false);
                  },
                ),
              ).buildExpandable(context),
            ),
        ],
      ),
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
                '30,00€',
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
