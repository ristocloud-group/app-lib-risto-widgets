import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

// ===========================================================================
// DEMO BLOC & DATA
// ===========================================================================
class DemoItem {
  final int value;

  DemoItem(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DemoItem && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class DemoSnapBloc extends InfiniteSnapListBloc<DemoItem> {
  DemoSnapBloc(int initialValue) : super(initValue: DemoItem(initialValue));

  @override
  Future<(List<DemoItem>, List<DemoItem>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required DemoItem offset,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // Fake network delay
    List<DemoItem> left = List.generate(
      leftLimit,
      (i) => DemoItem(offset.value - leftLimit + i),
    );
    List<DemoItem> right = List.generate(
      rightLimit,
      (i) => DemoItem(offset.value + 1 + i),
    );
    return (left, right);
  }
}

// ===========================================================================
// DEMO PAGE
// ===========================================================================
class InfiniteSnapDemoPage extends StatefulWidget {
  const InfiniteSnapDemoPage({super.key});

  @override
  State<InfiniteSnapDemoPage> createState() => _InfiniteSnapDemoPageState();
}

class _InfiniteSnapDemoPageState extends State<InfiniteSnapDemoPage> {
  // We initialize 3 distinct blocs for 3 completely different UI paradigms
  late final DemoSnapBloc _timelineBloc;
  late final DemoSnapBloc _carouselBloc;
  late final DemoSnapBloc _pickerBloc;

  final _timelineController = InfiniteSnapListController<DemoItem>();
  final _carouselController = InfiniteSnapListController<DemoItem>();
  final _pickerController = InfiniteSnapListController<DemoItem>();

  @override
  void initState() {
    super.initState();
    _timelineBloc = DemoSnapBloc(14); // Start on the 14th (like a date)
    _carouselBloc = DemoSnapBloc(1);
    _pickerBloc = DemoSnapBloc(25);
  }

  @override
  void dispose() {
    _timelineBloc.close();
    _carouselBloc.close();
    _pickerBloc.close();
    _timelineController.dispose();
    _carouselController.dispose();
    _pickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Infinite Snap Lists')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          // =========================================================
          // EXAMPLE 1: HORIZONTAL TIMELINE / DATE PICKER
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '1. The Date Picker',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Uses a soft pill overlay and visibleItemCount: 5 to perfectly center a week timeline.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black12),
              ),
            ),
            child: InfiniteSnapList<DemoItem>(
              bloc: _timelineBloc,
              controller: _timelineController,
              scrollDirection: Axis.horizontal,
              visibleItemCount: 5.0,
              // Exactly 5 days visible at once!
              itemSpacing: 8,

              // Custom Circular Overlay
              selectedItemOverlayBuilder:
                  (context, w, h) => Container(
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withCustomOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

              itemBuilder: (ctx, item, idx, isSelected) {
                // Map the integer to a day of the month (1-31)
                int day = ((item.value % 31) + 31) % 31 + 1;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SEP',
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white70 : Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // =========================================================
          // EXAMPLE 2: CARD CAROUSEL (NETFLIX STYLE)
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '2. The Card Carousel',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Uses visibleItemCount: 1.2 to "peek" the next cards, combined with gradient Edge Fades.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          SizedBox(
            height: 220,
            child: InfiniteSnapList<DemoItem>(
              bloc: _carouselBloc,
              controller: _carouselController,
              scrollDirection: Axis.horizontal,
              visibleItemCount: 1.2,
              // Show 1 full card, peek 10% of left/right cards!
              itemSpacing: 16,

              // Edge Shadows so items fade beautifully off-screen
              edgeDecorationSize: 30,
              startEdgeDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade100.withCustomOpacity(0.0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              endEdgeDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade100.withCustomOpacity(0.0),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),

              itemBuilder: (ctx, item, idx, isSelected) {
                // Using our new RistoDecorator for the cards!
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.9, end: isSelected ? 1.0 : 0.9),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: RistoDecorator(
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        elevation: isSelected ? 6.0 : 1.0,
                        shadowColor: Colors.blueGrey,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Course ${item.value}',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Advanced UI Patterns',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Explore interactive elements.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // =========================================================
          // EXAMPLE 3: VERTICAL WHEEL PICKER (iOS STYLE)
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '3. The Vertical Wheel Picker',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Vertical scrolling with a border-only overlay and visibleItemCount: 3.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          Center(
            child: Container(
              height: 180,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: InfiniteSnapList<DemoItem>(
                bloc: _pickerBloc,
                controller: _pickerController,
                scrollDirection: Axis.vertical,
                visibleItemCount: 3.0,
                // Exactly 3 items high
                itemSpacing: 0,

                // Border Overlay
                selectedItemOverlayBuilder:
                    (context, w, h) => Container(
                      width: w,
                      height: h,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),

                itemBuilder: (ctx, item, idx, isSelected) {
                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 24,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Colors.blue.shade900
                                : Colors.grey.shade400,
                      ),
                      child: Text('${item.value} kg'),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
