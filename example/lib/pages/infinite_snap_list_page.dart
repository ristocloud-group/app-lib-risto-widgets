import 'dart:ui';

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
      const Duration(seconds: 1),
    ); // Show off the centered loading
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
  late final DemoSnapBloc _timelineBloc;

  final List<DemoItem> _finiteCarouselItems = List.generate(
    5,
    (i) => DemoItem(i + 1),
  );
  final List<DemoItem> _finitePickerItems = List.generate(
    20,
    (i) => DemoItem(i * 5),
  );
  DemoItem? _selectedCarouselItem;
  DemoItem? _selectedPickerItem;

  @override
  void initState() {
    super.initState();
    _timelineBloc = DemoSnapBloc(14);
    _selectedCarouselItem = _finiteCarouselItems[0];
    _selectedPickerItem = _finitePickerItems[0];
  }

  @override
  void dispose() {
    _timelineBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Snap Lists')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          // =========================================================
          // EXAMPLE 1: HORIZONTAL TIMELINE / DATE PICKER (INFINITE)
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '1. Infinite Date Picker',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'With maxFlingVelocity: 1500 to keep the scrolling smooth and precise!',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          Container(
            height: 90,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black12),
              ),
            ),
            child: InfiniteSnapList<DemoItem>(
              bloc: _timelineBloc,
              scrollDirection: Axis.horizontal,
              visibleItemCount: 7.0,
              itemSpacing: 8,
              maxFlingVelocity: 1500.0,
              focusRange: 2.0,
              focusedItemScale: 1.15,
              unfocusedItemScale: 0.85,
              unfocusedItemOpacity: 0.3,

              selectedItemOverlayBuilder: (context, w, h) {
                return Container(
                  width: w * 1.4,
                  height: h * 1.3,
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
                );
              },

              loadingItemBuilder:
                  (context, width, height) => RistoShimmer.block(
                    width: width,
                    height: height,
                    baseColor: Colors.grey.shade300,
                  ),

              itemBuilder: (ctx, item, idx, isSelected, progress) {
                int day = ((item.value % 31) + 31) % 31 + 1;
                final topColor = Color.lerp(
                  Colors.grey.shade500,
                  Colors.white70,
                  progress,
                );
                final bottomColor = Color.lerp(
                  Colors.black87,
                  Colors.white,
                  progress,
                );

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SEP',
                      style: TextStyle(
                        color: topColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      day.toString(),
                      style: TextStyle(
                        color: bottomColor,
                        fontSize: 22,
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
          // EXAMPLE 2: CARD CAROUSEL (FINITE) WITH DOT INDICATOR
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '2. Finite Card Carousel',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Uses SnapScrollPhysics to swipe exactly one card at a time.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          SizedBox(
            height: 250,
            child: SnapList<DemoItem>.carousel(
              items: _finiteCarouselItems,
              selectedItem: _selectedCarouselItem,
              onItemSelected:
                  (item, idx) => setState(() => _selectedCarouselItem = item),

              footerBuilder: (context, currentIndex, totalCount) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SnapListDotIndicator(
                    itemCount: totalCount,
                    currentIndex: currentIndex,
                    activeColor: theme.primaryColor,
                    inactiveColor: Colors.grey.withCustomOpacity(0.3),
                  ),
                );
              },

              itemBuilder: (ctx, item, idx, isSelected, progress) {
                final elevation = lerpDouble(1.0, 6.0, progress)!;

                return RistoDecorator(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  elevation: elevation,
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
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // =========================================================
          // EXAMPLE 3: VERTICAL WHEEL PICKER (FINITE)
          // =========================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '3. Vertical Wheel Picker',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Uses SnapList.picker to create a classic 3-item wheel selector.',
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
              child: SnapList<DemoItem>.picker(
                items: _finitePickerItems,
                selectedItem: _selectedPickerItem,
                onItemSelected:
                    (item, idx) => setState(() => _selectedPickerItem = item),

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

                itemBuilder: (ctx, item, idx, isSelected, progress) {
                  final color = Color.lerp(
                    Colors.grey.shade400,
                    Colors.blue.shade900,
                    progress,
                  );
                  final fontWeight =
                      progress > 0.5 ? FontWeight.bold : FontWeight.normal;

                  return Center(
                    child: Text(
                      '${item.value} kg',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: fontWeight,
                        color: color,
                      ),
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
