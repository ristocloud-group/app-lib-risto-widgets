import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

              // 4. Draggable Planner Sheet with Footer Pinned
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet.scrollableSheet(
                    context,
                    enableDrag: true,
                    expand: true,
                    initialChildSize: 0.85,
                    minChildSize: 0.8,
                    maxChildSize: 0.95,
                    sheetPadding: EdgeInsets.zero,
                    body: ({scrollController}) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
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

                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              children: [
                                ...List.generate(7, (index) {
                                  final date = DateTime.now().add(
                                    Duration(days: index),
                                  );
                                  return CheckboxListTile(
                                    value: index == 3,
                                    onChanged: (val) {},
                                    title: Text(
                                      'Giorno ${date.day}/${date.month}',
                                    ),
                                    subtitle: const Text(
                                      'Disponibile per assenza',
                                    ),
                                    secondary: const Icon(
                                      Icons.calendar_month,
                                      color: Colors.blueGrey,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "Seleziona il giorno finale oppure\nconferma l'assenza singola",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

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
                child: const Text('Open Absence Planner (Pinned Footer)'),
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

              // 6. ANIMATED WALLET RECHARGE
              CustomActionButton(
                margin: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  OpenCustomSheet(
                    showDragHandle: false,
                    enableDrag: false,
                    expand: true,
                    initialChildSize: 0.75,
                    backgroundColor: Colors.transparent,
                    sheetPadding: EdgeInsets.zero,
                    onClose: (value) {
                      if (value != null) {
                        RistoToast.success(context, message: 'Added $value €');
                      }
                    },
                    body:
                        ({scrollController}) =>
                            const _CustomAmountSheetBody(initialAmount: 0),
                  ).show(context);
                },
                child: const Text('Open Animated Wallet Recharge'),
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

// ============================================================================
// CUSTOM ANIMATED AMOUNT SHEET COMPONENTS
// ============================================================================

class _CustomAmountSheetBody extends StatefulWidget {
  final double initialAmount;

  const _CustomAmountSheetBody({required this.initialAmount});

  @override
  State<_CustomAmountSheetBody> createState() => _CustomAmountSheetBodyState();
}

class _CustomAmountSheetBodyState extends State<_CustomAmountSheetBody> {
  late final ValueNotifier<String> _digitsNotifier;

  @override
  void initState() {
    super.initState();
    _digitsNotifier = ValueNotifier(
      (widget.initialAmount * 100).round().clamp(0, 999999999).toString(),
    );
  }

  @override
  void dispose() {
    _digitsNotifier.dispose();
    super.dispose();
  }

  void _addDigit(int d) {
    HapticFeedback.selectionClick();
    final currentDigits = _digitsNotifier.value;
    if (currentDigits == '0') {
      _digitsNotifier.value = '$d';
    } else if (currentDigits.length < 9) {
      _digitsNotifier.value = '$currentDigits$d';
    }
  }

  void _backspace() {
    HapticFeedback.selectionClick();
    final currentDigits = _digitsNotifier.value;
    _digitsNotifier.value =
        (currentDigits.length <= 1)
            ? '0'
            : currentDigits.substring(0, currentDigits.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final textStyle = theme.textTheme.displayMedium?.copyWith(
      fontWeight: FontWeight.w300,
    );

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _digitsNotifier,
            builder: (context, digits, _) {
              final currentCents = int.tryParse(digits) ?? 0;
              final euros = currentCents ~/ 100;
              final cents = currentCents % 100;

              // Basic Euro formatter
              final eurosStr = euros.toString().replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                (m) => '.',
              );
              final formattedNumber =
                  '$eurosStr,${cents.toString().padLeft(2, '0')}';

              return Container(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ricarica credito',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          splashRadius: 22,
                          onPressed: () => Navigator.of(context).maybePop(null),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 56.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              child: Text(
                                formattedNumber,
                                key: ValueKey(formattedNumber),
                                style: textStyle,
                              ),
                            ),
                            const _BlinkingCursor(),
                            Text(' €', style: textStyle),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Container(
              color: theme.cardColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _AnimatedNumpad(
                      onDigitTap: _addDigit,
                      onBackspaceTap: _backspace,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ValueListenableBuilder<String>(
                    valueListenable: _digitsNotifier,
                    builder: (context, digits, _) {
                      final currentCents = int.tryParse(digits) ?? 0;
                      return CustomActionButton.rounded(
                        minHeight: 48.0,
                        width: double.infinity,
                        foregroundColor: Colors.white,
                        backgroundColor: primary,
                        elevation: 0,
                        onPressed:
                            (currentCents > 0)
                                ? () => Navigator.of(
                                  context,
                                ).maybePop(currentCents / 100.0)
                                : null,
                        child: const Text('Invia'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _controller,
      child: Text(
        '|',
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}

class _AnimatedNumpad extends StatefulWidget {
  final void Function(int) onDigitTap;
  final void Function() onBackspaceTap;

  const _AnimatedNumpad({
    required this.onDigitTap,
    required this.onBackspaceTap,
  });

  @override
  State<_AnimatedNumpad> createState() => _AnimatedNumpadState();
}

class _AnimatedNumpadState extends State<_AnimatedNumpad>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      for (var i = 1; i <= 9; i++)
        _NumKey(i, onTap: () => widget.onDigitTap(i)),
      _BackKey(onTap: widget.onBackspaceTap),
      _NumKey(0, onTap: () => widget.onDigitTap(0)),
      const SizedBox.shrink(),
    ];
    return GridView.count(
      primary: false,
      crossAxisCount: 3,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: List.generate(keys.length, (index) {
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * (index / 3),
            0.5 + 0.1 * (index / 3),
            curve: Curves.easeInOutCubic,
          ),
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: keys[index]),
        );
      }),
    );
  }
}

class _NumKey extends StatelessWidget {
  final int n;
  final VoidCallback onTap;

  const _NumKey(this.n, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    return CustomActionButton.flat(
      onPressed: onTap,
      backgroundColor: Colors.transparent,
      child: Text('$n', style: textStyle),
    );
  }
}

class _BackKey extends StatelessWidget {
  final VoidCallback onTap;

  const _BackKey({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomActionButton.flat(
      onPressed: onTap,
      backgroundColor: Colors.transparent,
      child: const Icon(Icons.backspace_outlined, size: 28),
    );
  }
}
