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
  final List<MapLocationModel> _mockLocations = [
    MapLocationModel(
      id: '1',
      name: 'Duomo',
      address: 'Piazza del Duomo',
      lat: 45.4642,
      lng: 9.1900,
    ),
    MapLocationModel(
      id: '2',
      name: 'Castello',
      address: 'Piazza Castello',
      lat: 45.4705,
      lng: 9.1793,
    ),
    MapLocationModel(
      id: '3',
      name: 'Navigli',
      address: 'Ripa di Porta Ticinese',
      lat: 45.4523,
      lng: 9.1729,
    ),
    MapLocationModel(
      id: '4',
      name: 'Brera',
      address: 'Via Brera',
      lat: 45.4720,
      lng: 9.1878,
    ),
    MapLocationModel(
      id: '5',
      name: 'CityLife',
      address: 'Piazza Tre Torri',
      lat: 45.4782,
      lng: 9.1561,
    ),
    MapLocationModel(
      id: '6',
      name: 'Centrale',
      address: 'Piazza Duca d\'Aosta',
      lat: 45.4848,
      lng: 9.2038,
    ),
    MapLocationModel(
      id: '7',
      name: 'Porta Nuova',
      address: 'Piazza Gae Aulenti',
      lat: 45.4835,
      lng: 9.1899,
    ),
  ];

  late final InteractiveMapController<MapLocationModel> _mapController;
  MapLocationModel? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = InteractiveMapController<MapLocationModel>();
  }

  void _handleLocationTap(MapLocationModel item) {
    setState(() {
      _selectedLocation = item;
    });
  }

  void _closeDetails() {
    setState(() {
      _selectedLocation = null;
    });
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
              Tab(icon: Icon(Icons.local_shipping), text: 'Delivery'),
              Tab(icon: Icon(Icons.storefront), text: 'Locator'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [_buildDeliveryTab(), _buildLocatorTab()],
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: DELIVERY (CLUSTERING + FOCUSED ZOOM)
  // ===========================================================================
  Widget _buildDeliveryTab() {
    return Stack(
      children: [
        InteractiveMap<MapLocationModel>.delivery(
          controller: _mapController,
          items: _mockLocations,
          positionMapper: (item) => LatLng(item.lat, item.lng),
          clusterColor: Colors.orange,
          focusedZoom: 17.0,
          zoomConfig: const MapControlConfig(
            backgroundColor: Colors.black87,
            iconColor: Colors.white,
          ),
          // CORRECTED: Grouped the button config inside UserLocationConfig
          userLocation: const MapUserLocationConfig(
            showUserLocationButton: true,
            buttonConfig: MapControlConfig(
              backgroundColor: Colors.white,
              iconColor: Colors.blue,
            ),
          ),
          onDeliveryTapped: (item, index) => _handleLocationTap(item),
          markerBuilder: (context, item, index) {
            final isSelected = _selectedLocation?.id == item.id;
            return SizedBox(
              width: 80,
              height: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isSelected ? Colors.red : Colors.orange,
                  ),
                ],
              ),
            );
          },
        ),

        if (_selectedLocation != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildDetailsCard(),
          ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: STORE LOCATOR (ROTATION + COMPASS)
  // ===========================================================================
  Widget _buildLocatorTab() {
    return Stack(
      children: [
        InteractiveMap<MapLocationModel>.locator(
          items: _mockLocations,
          positionMapper: (item) => LatLng(item.lat, item.lng),
          focusedZoom: 18.0,
          onStoreTapped: (item, index) => _handleLocationTap(item),
          onMapTapped: (tapPosition, point) => _closeDetails(),
          compassConfig: const MapControlConfig(
            backgroundColor: Colors.white,
            iconColor: Colors.redAccent,
          ),
          zoomConfig: const MapControlConfig(
            backgroundColor: Colors.white,
            iconColor: Colors.black87,
          ),
          markerBuilder: (context, item, index) {
            return const Icon(Icons.location_pin, color: Colors.blue, size: 45);
          },
        ),

        const Positioned(
          top: 10,
          left: 10,
          child: IgnorePointer(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rotate with two fingers\nto see the Compass",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),

        if (_selectedLocation != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: _buildDetailsCard(),
          ),
      ],
    );
  }

  // ===========================================================================
  // UI DETAILS CARD
  // ===========================================================================
  Widget _buildDetailsCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * 50),
          child: Opacity(opacity: 1.0 - value, child: child),
        );
      },
      child: Card(
        elevation: 12,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedLocation!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _selectedLocation!.address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closeDetails,
                  ),
                ],
              ),
              const Divider(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions),
                  label: const Text("Ottieni Indicazioni"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
}
