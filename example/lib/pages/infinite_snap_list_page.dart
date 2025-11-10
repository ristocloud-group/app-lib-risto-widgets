import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/risto_widgets.dart';

/// Example data type for the infinite snap list demo.
/// Should implement == and hashCode for correct comparison.
class DemoItem {
  final int value;

  DemoItem(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DemoItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Item $value';
}

/// Simple InfiniteListBloc implementation for demonstration purposes.
/// Generates synthetic values based on the offset item.
class DemoSnapBloc extends InfiniteSnapListBloc<DemoItem> {
  // Initializes the BLoC with an initial state containing a selected item.
  // This will trigger the initial fetching logic in InfiniteListBloc.
  DemoSnapBloc() : super(initValue: DemoItem(0));

  /// Simulate async fetching of more items to the left and right.
  /// This method is called by the InfiniteListBloc superclass.
  @override
  Future<(List<DemoItem>, List<DemoItem>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required DemoItem offset,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // Simulate network delay
    // Example: fetches values left/right of the current offset
    List<DemoItem> left = List.generate(
      leftLimit,
      (i) => DemoItem(offset.value - leftLimit + i),
    );
    List<DemoItem> right = List.generate(
      rightLimit,
      (i) => DemoItem(offset.value + 1 + i),
    );
    debugPrint(
      'Fetched around ${offset.value}: Left ${left.length} items, Right ${right.length} items',
    );
    return (left, right);
  }
}

class InfiniteSnapDemoPage extends StatefulWidget {
  const InfiniteSnapDemoPage({super.key});

  @override
  State<InfiniteSnapDemoPage> createState() => _InfiniteSnapDemoPageState();
}

class _InfiniteSnapDemoPageState extends State<InfiniteSnapDemoPage> {
  late final DemoSnapBloc _bloc; // Initialize with `late` and in `initState`
  final _controller = InfiniteSnapListController<DemoItem>();

  Axis _direction = Axis.horizontal;
  bool _showCustomShimmer = false;
  bool _showCustomOverlay = false;

  @override
  void initState() {
    super.initState();
    _bloc = DemoSnapBloc(); // Create the BLoC here
  }

  @override
  void dispose() {
    _bloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InfiniteSnapList DEMO'),
          actions: [
            IconButton(
              icon: const Icon(Icons.rotate_90_degrees_ccw),
              tooltip: 'Switch direction',
              onPressed:
                  () => setState(() {
                    _direction =
                        _direction == Axis.horizontal
                            ? Axis.vertical
                            : Axis.horizontal;
                  }),
            ),
            IconButton(
              icon: const Icon(Icons.nightlight),
              tooltip: 'Custom shimmer',
              onPressed:
                  () =>
                      setState(() => _showCustomShimmer = !_showCustomShimmer),
              color: _showCustomShimmer ? Colors.amber : null,
            ),
            IconButton(
              icon: const Icon(Icons.rectangle),
              tooltip: 'Custom overlay',
              onPressed:
                  () =>
                      setState(() => _showCustomOverlay = !_showCustomOverlay),
              color: _showCustomOverlay ? Colors.red : null,
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Column(
            children: [
              // Horizontal scrollable control bar
              BlocBuilder<DemoSnapBloc, InfiniteSnapListState<DemoItem>>(
                // Wrap the buttons in a BlocBuilder to access the BLoC's state
                builder: (context, state) {
                  final items = state.state.items;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _demoButton(
                        'Go to Start', // Rename for clarity
                        () {
                          if (items.isNotEmpty) {
                            _controller.jumpTo(
                              0,
                            ); // Go to the start of the loaded list
                          }
                        },
                      ),
                      _demoButton(
                        'Go to 0',
                        () => _controller.selectItem(
                          DemoItem(0),
                        ), // Continue to select item 0
                      ),
                      _demoButton(
                        'Go to End', // Rename for clarity
                        () {
                          if (items.isNotEmpty) {
                            _controller.jumpTo(
                              items.length - 1,
                            ); // Go to the end of the loaded list
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              // Selected item indicator
              BlocBuilder<DemoSnapBloc, InfiniteSnapListState<DemoItem>>(
                builder: (context, state) {
                  final selected = _controller.selectedItem?.value ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Selected: $selected',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
              ),
              // Main list demo in a card
              // We use a Flexible to wrap the Card.
              // This ensures a consistent widget type in the Column,
              // preventing the recreation of the InfiniteSnapList state on orientation change.
              Flexible(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  elevation: 3,
                  color: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 12.0,
                    ),
                    child: InfiniteSnapList<DemoItem>(
                      bloc: _bloc,
                      controller: _controller,
                      scrollDirection: _direction,
                      itemWidth: 80,
                      itemHeight: 80,
                      itemSpacing: 16,
                      // listPadding here is the padding *inside* the ListView.
                      // The height/width constraints for the entire InfiniteSnapList are given by the parent (Flexible/Card).
                      listPadding: const EdgeInsets.symmetric(horizontal: 12),
                      // Make sure this is correct for both orientations if you don't want different vertical padding
                      itemAlignment: Alignment.center,
                      enableKeyboardNavigation: true,
                      semanticLabelBuilder: (item) => 'Item ${item.value}',
                      onItemSelected: (item, idx) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${item.value} at $idx'),
                          ),
                        );
                      },
                      // Item visual
                      itemBuilder:
                          (ctx, item, idx, isSelected) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            // `width` and `height` of the AnimatedContainer should be fixed like the widget's `itemWidth` and `itemHeight`
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.blue[50] : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: Colors.blue.withCustomOpacity(
                                            0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                      : [],
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.blueAccent
                                        : Colors.grey.shade300,
                                width: isSelected ? 2.4 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.value.toString(),
                              style: TextStyle(
                                fontSize: isSelected ? 32 : 22,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? Colors.blue[900]
                                        : Colors.grey[800],
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                      // Custom shimmer for loading state (optional, toggle as you wish)
                      loadingShimmerItemBuilder:
                          _showCustomShimmer
                              ? (ctx, i) => Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.purple, Colors.orange],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              )
                              : null,
                      // Custom overlay for selected item (optional, toggle as you wish)
                      selectedItemOverlayBuilder:
                          _showCustomOverlay
                              ? (ctx, w, h) => IgnorePointer(
                                child: Container(
                                  width: w,
                                  height: h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.red,
                                      size: 34,
                                    ),
                                  ),
                                ),
                              )
                              : null,
                      // Loader while fetching more items (edge)
                      loadingIndicatorBuilder:
                          (ctx) => Center(
                            child: const CircularProgressIndicator.adaptive(),
                          ),
                      // Empty state
                      emptyListBuilder:
                          (ctx) =>
                              const Center(child: Text('No items available!')),
                      // Error state
                      errorBuilder:
                          (ctx, err) => Center(
                            child: Text(
                              'Error: ${err.toString()}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for compact, rounded demo buttons
  Widget _demoButton(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: Colors.blue.shade100),
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
