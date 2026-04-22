import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
// Adjust this import path to match your project structure
import 'package:risto_widgets/widgets/map/interactive_map.dart';

// ===========================================================================
// MOCK DATA MODEL
// ===========================================================================
class MockLocation {
  final String id;
  final double lat;
  final double lng;

  MockLocation(this.id, this.lat, this.lng);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MockLocation && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  group('InteractiveMap<T> Tests', () {
    final mockItems = [
      MockLocation('1', 45.4642, 9.1900), // Milan Duomo
      MockLocation('2', 45.4705, 9.1793), // Milan Castello
    ];

    testWidgets('renders successfully and displays markers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InteractiveMap<MockLocation>(
              items: mockItems,
              initialCenter: const LatLng(45.46, 9.18),
              positionMapper: (item) => LatLng(item.lat, item.lng),
              markerBuilder: (context, item, index) {
                return Container(
                  key: ValueKey('marker_${item.id}'),
                  child: Text('Pin ${item.id}'),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the core FlutterMap is in the tree
      expect(find.byType(FlutterMap), findsOneWidget);

      // Verify the markers are rendered
      expect(find.byKey(const ValueKey('marker_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('marker_2')), findsOneWidget);
      expect(find.text('Pin 1'), findsOneWidget);
    });

    testWidgets('triggers onTapItem and focuses map when a marker is tapped', (
      tester,
    ) async {
      MockLocation? tappedItem;
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InteractiveMap<MockLocation>(
              items: mockItems,
              positionMapper: (item) => LatLng(item.lat, item.lng),
              markerBuilder: (context, item, index) => Container(
                key: ValueKey('touchable_${item.id}'),
                width: 40,
                height: 40,
                color: Colors.red,
              ),
              interaction: MapInteractionConfig<MockLocation>(
                onTapItem: (item, index) {
                  tappedItem = item;
                  tappedIndex = index;
                },
                focusedZoom: 16.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the first marker and tap it
      final markerFinder = find.byKey(const ValueKey('touchable_1'));
      expect(markerFinder, findsOneWidget);

      await tester.tap(markerFinder);
      await tester.pumpAndSettle();

      // Verify the callback was triggered with correct item and index
      expect(tappedItem, isNotNull);
      expect(tappedItem?.id, '1');
      expect(tappedIndex, 0);
    });

    testWidgets(
      'InteractiveMap.delivery factory renders MarkerClusterLayerWidget',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InteractiveMap<MockLocation>.delivery(
                items: mockItems,
                positionMapper: (item) => LatLng(item.lat, item.lng),
                markerBuilder: (context, item, index) =>
                    const Icon(Icons.pin_drop),
                // We pass null for userLocation to prevent Geolocator permission checks during the test
                userLocation: null,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the clustering plugin's layer is injected
        expect(find.byType(MarkerClusterLayerWidget), findsOneWidget);
      },
    );

    testWidgets('InteractiveMap.locator factory renders Zoom Controls', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InteractiveMap<MockLocation>.locator(
              items: mockItems,
              positionMapper: (item) => LatLng(item.lat, item.lng),
              markerBuilder: (context, item, index) =>
                  const Icon(Icons.pin_drop),
              // Passing null to bypass Geolocator in tests
              userLocation: null,
              zoomConfig: const MapControlConfig(), // Force enable zoom buttons
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The zoom config should render the '+' and '-' FloatingActionButtons
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets(
      'InteractiveMapController correctly attaches and executes jumpToItem & fitBounds',
      (tester) async {
        final controller = InteractiveMapController<MockLocation>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: InteractiveMap<MockLocation>(
                items: mockItems,
                controller: controller,
                positionMapper: (item) => LatLng(item.lat, item.lng),
                markerBuilder: (context, item, index) =>
                    const Icon(Icons.pin_drop),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // The controller should not throw when executing map commands,
        // confirming it successfully attached to the internal MapController.
        expect(
          () => controller.jumpToItem(mockItems.first, zoom: 17.0),
          returnsNormally,
        );

        expect(
          () => controller.fitBounds(
            LatLngBounds(const LatLng(45.0, 9.0), const LatLng(46.0, 10.0)),
          ),
          returnsNormally,
        );
      },
    );
  });
}
