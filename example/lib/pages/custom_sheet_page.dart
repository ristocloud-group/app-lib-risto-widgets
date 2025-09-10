import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

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
              // Confirm sheet
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

              // Scrollable sheet
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

              // Standard (direct constructor) custom form sheet
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet(
                    body:
                        ({scrollController}) => Column(
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

              // Expandable overlay trigger
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
                    header: Center(child: Text("Test Header")),
                    body:
                        ({scrollController}) =>
                            Container(height: 200, color: Colors.red),
                    footer: Center(child: Text("Test Footer")),
                  ).show(context);
                },
                child: const Text('Show Expandable Overlay'),
              ),

              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet(
                    enableDrag: false,
                    showDragHandle: false,
                    initialChildSize: 0.65,
                    sheetPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    body: ({scrollController}) {
                      // Local amount (in cents)
                      final value = ValueNotifier<int>(5500);

                      String formatEuro(int cents) {
                        final euros = cents ~/ 100;
                        final dec = (cents % 100).toString().padLeft(2, '0');
                        final eurosStr = euros.toString().replaceAllMapped(
                          RegExp(r'\B(?=(\d{3})+(?!\d))'),
                          (m) => '.',
                        );
                        return '$eurosStr,$dec €';
                      }

                      void onDigit(int d) {
                        final old = value.value;
                        if (old > 999999999) return; // soft cap
                        value.value = old * 10 + d;
                      }

                      void onBackspace() => value.value = value.value ~/ 10;

                      Widget keyButton(String label, VoidCallback onTap) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onTap,
                          child: Center(
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            // IMPORTANT: bounded column
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Ricarica saldo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Amount
                              ValueListenableBuilder<int>(
                                valueListenable: value,
                                builder: (context, cents, _) {
                                  return Text(
                                    formatEuro(cents),
                                    style: const TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 8),

                              // === PANEL THAT EXPANDS TO FILL THE SHEET ===
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      // Grid grows within the panel
                                      Expanded(
                                        child: GridView.count(
                                          // We are inside a bounded area: no need for shrinkWrap.
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          childAspectRatio: 1.85,
                                          children: [
                                            for (var d = 1; d <= 9; d++)
                                              keyButton(
                                                '$d',
                                                () =>
                                                    setState(() => onDigit(d)),
                                              ),
                                            keyButton(
                                              '⌫',
                                              () => setState(onBackspace),
                                            ),
                                            keyButton(
                                              '0',
                                              () => setState(() => onDigit(0)),
                                            ),
                                            const SizedBox.shrink(),
                                            // placeholder
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // CTA pinned at bottom of the panel (with SafeArea)
                                      SafeArea(
                                        top: false,
                                        left: false,
                                        right: false,
                                        minimum: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 52,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                            ),
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  value.value,
                                                ),
                                            child: const Text(
                                              'Invia',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ).show(context);
                },
                child: const Text('Open Custom Sheet'),
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
                    'Riepilogo',
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
                                      'Retta mensile trasporto',
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
              Text('Totale importo:', style: TextStyle(color: Colors.white70)),
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
                  'Chiudi',
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
                  'Avanti',
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
