import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risto_widgets/risto_widgets.dart';
import 'package:shimmer/shimmer.dart';

/// A sample data class to demonstrate the widget's genericity.
/// It can be any type of data that your BLoC handles.
class SampleData {
  final String id;
  final String name;
  final Color color;

  SampleData({required this.id, required this.name, required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SampleData{id: $id, name: $name}';
  }
}

/// Example implementation of your InfiniteListBloc for testing InfiniteSnapList.
/// This BLoC simulates fetching data from a source and handles bidirectional loading.
class SampleInfiniteSnapBloc extends InfiniteListBloc<SampleData> {
  final List<SampleData> _allPossibleItems = List.generate(
    100,
    (index) => SampleData(
      id: index.toString(),
      name: 'Item ${index + 1}',
      color: Colors.primaries[index % Colors.primaries.length],
    ),
  );

  SampleInfiniteSnapBloc({required super.initValue});

  /// Implements the abstract [fetchItems] method from [InfiniteListBloc].
  ///
  /// This method simulates fetching items from a data source.
  /// It retrieves items to the left and right of a given [offset] (pivot element),
  /// limiting the number of retrieved items via [leftLimit] and [rightLimit].
  @override
  Future<(List<SampleData>, List<SampleData>)> fetchItems({
    required int leftLimit,
    required int rightLimit,
    required SampleData offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final offsetIndex = _allPossibleItems.indexOf(offset);

    if (offsetIndex == -1) {
      debugPrint(
        "Offset not found in the list of available items: ${offset.name}",
      );
      return (<SampleData>[], <SampleData>[]);
    }

    List<SampleData> left = [];
    List<SampleData> right = [];

    if (leftLimit > 0) {
      final startIndex = (offsetIndex - leftLimit).clamp(
        0,
        _allPossibleItems.length,
      );
      left = _allPossibleItems.sublist(startIndex, offsetIndex);
    }

    if (rightLimit > 0) {
      final endIndex = (offsetIndex + 1 + rightLimit).clamp(
        0,
        _allPossibleItems.length,
      );
      right = _allPossibleItems.sublist(offsetIndex + 1, endIndex);
    }

    debugPrint(
      'Fetched around ${offset.name}: Left ${left.length} items, Right ${right.length} items',
    );
    return (left, right);
  }
}

/// Test page for the InfiniteSnapList widget.
/// This page integrates the BLoC and the widget to demonstrate its functionality.
class InfiniteSnapListPage extends StatefulWidget {
  const InfiniteSnapListPage({super.key});

  @override
  State<InfiniteSnapListPage> createState() => _InfiniteSnapListPageState();
}

class _InfiniteSnapListPageState extends State<InfiniteSnapListPage> {
  late final SampleInfiniteSnapBloc _bloc;

  @override
  void initState() {
    super.initState();
    final initialSelectedItem = SampleData(
      id: '50',
      name: 'Item 51',
      color: Colors.blue,
    );
    _bloc = SampleInfiniteSnapBloc(initValue: initialSelectedItem);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaddedChildrenList(
      children: [
        Text(
          'Infinite Snap List Example',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        BlocProvider<SampleInfiniteSnapBloc>.value(
          value: _bloc,
          child: SizedBox(
            height: 120,
            child: InfiniteSnapList<SampleData>(
              bloc: _bloc,
              itemWidth: 100,
              itemHeight: 100,
              itemSpacing: 10,
              itemBuilder: (context, item, index, isSelected) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: isSelected ? 18 : 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isSelected)
                        Text(
                          'ID: ${item.id}',
                          style: TextStyle(
                            color: Colors.white.withCustomOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              },
              loadingShimmerItemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                );
              },
              selectedItemOverlayBuilder: (
                context,
                totalItemSlotWidth,
                itemHeight,
              ) {
                return Container(
                  width: totalItemSlotWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                );
              },
              emptyListBuilder: (context) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No items found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
              errorBuilder:
                  (context, error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'An error occurred: ${error.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              loadingIndicatorBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 4,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
