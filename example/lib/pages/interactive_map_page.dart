import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:risto_widgets/risto_widgets.dart';

// ===========================================================================
// MOCK DATA MODEL
// ===========================================================================
class MapLocationModel {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;

  MapLocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

// ===========================================================================
// DEMO PAGE
// ===========================================================================
class InteractiveMapPage extends StatefulWidget {
  const InteractiveMapPage({super.key});

  @override
  State<InteractiveMapPage> createState() => _InteractiveMapPageState();
}

class _InteractiveMapPageState extends State<InteractiveMapPage> {
  // Generiamo un po' di dati finti sparsi per Milano
  final List<MapLocationModel> _mockLocations = [
    MapLocationModel(id: '1', name: 'Duomo', address: 'Piazza del Duomo', lat: 45.4642, lng: 9.1900),
    MapLocationModel(id: '2', name: 'Castello', address: 'Piazza Castello', lat: 45.4705, lng: 9.1793),
    MapLocationModel(id: '3', name: 'Navigli', address: 'Ripa di Porta Ticinese', lat: 45.4523, lng: 9.1729),
    MapLocationModel(id: '4', name: 'Brera', address: 'Via Brera', lat: 45.4720, lng: 9.1878),
    MapLocationModel(id: '5', name: 'CityLife', address: 'Piazza Tre Torri', lat: 45.4782, lng: 9.1561),
    MapLocationModel(id: '6', name: 'Centrale', address: 'Piazza Duca d\'Aosta', lat: 45.4848, lng: 9.2038),
    MapLocationModel(id: '7', name: 'Porta Nuova', address: 'Piazza Gae Aulenti', lat: 45.4835, lng: 9.1899),
  ];

  late final InteractiveMapController<MapLocationModel> _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = InteractiveMapController<MapLocationModel>();
  }

  void _showLocationDetails(BuildContext context, MapLocationModel item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.address,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Vai al Dettaglio", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interactive Map Demo'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.local_shipping), text: 'Delivery (Clustered)'),
              Tab(icon: Icon(Icons.storefront), text: 'Store Locator'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // Evita conflitti con il pan della mappa
          children: [
            _buildDeliveryTab(),
            _buildLocatorTab(),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: DELIVERY (CLUSTERING)
  // ===========================================================================
  Widget _buildDeliveryTab() {
    return Stack(
      children: [
        InteractiveMap<MapLocationModel>.delivery(
          controller: _mapController,
          items: _mockLocations,
          positionMapper: (item) => LatLng(item.lat, item.lng),
          clusterColor: Colors.orange,
          onDeliveryTapped: (item, index) {
            _showLocationDetails(context, item);
          },
          markerBuilder: (context, item, index) {
            // Un custom pin a goccia arancione con il numero
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.orange, size: 24),
              ],
            );
          },
        ),

        // Tasti Floating per testare il controller
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'btn1',
                onPressed: () {
                  // Salta al primo elemento
                  if (_mockLocations.isNotEmpty) {
                    _mapController.jumpToItem(_mockLocations.first, zoom: 16);
                  }
                },
                child: const Icon(Icons.filter_center_focus),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: STORE LOCATOR (USER TRACKING)
  // ===========================================================================
  Widget _buildLocatorTab() {
    return InteractiveMap<MapLocationModel>.locator(
      items: _mockLocations,
      positionMapper: (item) => LatLng(item.lat, item.lng),
      onStoreTapped: (item, index) {
        _showLocationDetails(context, item);
      },
      onMapTapped: (tapPosition, point) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mappa cliccata a: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}")),
        );
      },
      markerBuilder: (context, item, index) {
        // Pin classico blu per gli store
        return const Icon(
          Icons.location_pin,
          color: Colors.blue,
          size: 40,
        );
      },
    );
  }
}