import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:risto_widgets/extensions.dart';

// ===========================================================================
// CONFIGURATION CLASSES
// ===========================================================================

/// Configuration for map clustering.
class MapClusteringConfig {
  final double minZoom;
  final double maxZoom;
  final int maxClusterRadius;
  final Size clusterSize;
  final EdgeInsets clusterPadding;
  final AlignmentGeometry clusterAlignment;

  /// Determines if the map should auto-zoom to fit the cluster bounds on tap.
  final bool zoomToBoundsOnClick;

  /// Builder for the cluster marker.
  final Widget Function(BuildContext context, List<Marker> markers)
  clusterBuilder;

  const MapClusteringConfig({
    this.minZoom = 5,
    this.maxZoom = 15,
    this.maxClusterRadius = 45,
    this.clusterSize = const Size(40, 40),
    this.clusterPadding = const EdgeInsets.all(8),
    this.clusterAlignment = Alignment.center,
    this.zoomToBoundsOnClick = true,
    required this.clusterBuilder,
  });
}

/// Configuration for tracking and displaying the user's live location.
class MapUserLocationConfig {
  final bool showHeading;
  final bool requestPermissionAutomatically;
  final LocationAccuracy desiredAccuracy;
  final int distanceFilter;

  /// Whether the map should continuously center on the user as they move.
  final bool followUser;

  /// Builder for the user's location pin.
  final Widget Function(BuildContext context)? markerBuilder;

  const MapUserLocationConfig({
    this.showHeading = true,
    this.requestPermissionAutomatically = true,
    this.desiredAccuracy = LocationAccuracy.high,
    this.distanceFilter = 10,
    this.followUser = false,
    this.markerBuilder,
  });
}

/// Configuration for map interactivity.
class MapInteractionConfig<T> {
  /// Callback triggered when a generic marker [T] is tapped.
  final void Function(T item, int index)? onTapItem;

  /// Callback triggered when the user taps on an empty spot on the map.
  final void Function(TapPosition tapPosition, LatLng point)? onMapTap;

  /// Callback triggered when the user long-presses on the map.
  final void Function(TapPosition tapPosition, LatLng point)? onMapLongPress;

  final bool enableZoom;
  final bool enablePan;
  final bool enableRotation;
  final bool keepAlive;

  const MapInteractionConfig({
    this.onTapItem,
    this.onMapTap,
    this.onMapLongPress,
    this.enableZoom = true,
    this.enablePan = true,
    this.enableRotation = false,
    this.keepAlive = true,
  });
}

/// Configuration for the map's visual theme and tile provider.
class MapThemeConfig {
  final String tileUrl;
  final String userAgent;
  final Color backgroundColor;
  final bool retinaMode;

  const MapThemeConfig({
    this.tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.userAgent = 'com.risto.library',
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.retinaMode = true,
  });
}

// ===========================================================================
// CONTROLLER
// ===========================================================================

class InteractiveMapController<T> extends ChangeNotifier {
  MapController? _internalMapController;
  LatLng Function(T item)? _positionMapper;

  void _attach(
    MapController mapController,
    LatLng Function(T item) positionMapper,
  ) {
    _internalMapController = mapController;
    _positionMapper = positionMapper;
  }

  void _detach() {
    _internalMapController = null;
    _positionMapper = null;
  }

  void moveTo(LatLng position, {double zoom = 15.0}) {
    _internalMapController?.move(position, zoom);
  }

  void jumpToItem(T item, {double zoom = 15.0}) {
    if (_positionMapper != null) {
      final position = _positionMapper!(item);
      moveTo(position, zoom: zoom);
    }
  }

  void fitBounds(
    LatLngBounds bounds, {
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    _internalMapController?.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: padding),
    );
  }
}

// ===========================================================================
// MAIN WIDGET
// ===========================================================================

/// A highly customizable, generic map widget built on top of `flutter_map`.
class InteractiveMap<T> extends StatefulWidget {
  final List<T> items;
  final LatLng Function(T item) positionMapper;
  final Widget Function(BuildContext context, T item, int index) markerBuilder;

  final MapClusteringConfig? clustering;
  final MapUserLocationConfig? userLocation;
  final MapInteractionConfig<T>? interaction;
  final MapThemeConfig theme;
  final InteractiveMapController<T>? controller;

  final LatLng initialCenter;
  final double initialZoom;
  final double markerWidth;
  final double markerHeight;

  const InteractiveMap({
    super.key,
    required this.items,
    required this.positionMapper,
    required this.markerBuilder,
    this.clustering,
    this.userLocation,
    this.interaction,
    this.theme = const MapThemeConfig(),
    this.controller,
    this.initialCenter = const LatLng(45.4642, 9.1900),
    this.initialZoom = 13.0,
    this.markerWidth = 40.0,
    this.markerHeight = 40.0,
  });

  /// Factory tailored for Delivery Tracking.
  /// Automatically applies clustering and disables rotation for standard viewing.
  factory InteractiveMap.delivery({
    Key? key,
    required List<T> items,
    required LatLng Function(T item) positionMapper,
    required Widget Function(BuildContext context, T item, int index)
    markerBuilder,
    void Function(T item, int index)? onDeliveryTapped,
    InteractiveMapController<T>? controller,
    LatLng initialCenter = const LatLng(45.4642, 9.1900),
    Color clusterColor = Colors.orange,
  }) {
    return InteractiveMap<T>(
      key: key,
      items: items,
      positionMapper: positionMapper,
      markerBuilder: markerBuilder,
      controller: controller,
      initialCenter: initialCenter,
      initialZoom: 12.0,
      interaction: MapInteractionConfig<T>(
        onTapItem: onDeliveryTapped,
        enableRotation: false,
      ),
      clustering: MapClusteringConfig(
        maxZoom: 16,
        clusterBuilder: (context, markers) => Container(
          decoration: BoxDecoration(
            color: clusterColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              markers.length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Factory tailored for Store Locators / Exploration.
  /// Focuses heavily on the user's location and allows full map exploration.
  factory InteractiveMap.locator({
    Key? key,
    required List<T> items,
    required LatLng Function(T item) positionMapper,
    required Widget Function(BuildContext context, T item, int index)
    markerBuilder,
    void Function(T item, int index)? onStoreTapped,
    void Function(TapPosition, LatLng)? onMapTapped,
    InteractiveMapController<T>? controller,
  }) {
    return InteractiveMap<T>(
      key: key,
      items: items,
      positionMapper: positionMapper,
      markerBuilder: markerBuilder,
      controller: controller,
      interaction: MapInteractionConfig<T>(
        onTapItem: onStoreTapped,
        onMapTap: onMapTapped,
        enableRotation: true,
      ),
      userLocation: MapUserLocationConfig(
        followUser: true,
        requestPermissionAutomatically: true,
      ),
    );
  }

  @override
  State<InteractiveMap<T>> createState() => _InteractiveMapState<T>();
}

class _InteractiveMapState<T> extends State<InteractiveMap<T>> {
  late final MapController _mapController;
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentUserLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    widget.controller?._attach(_mapController, widget.positionMapper);

    if (widget.userLocation != null) {
      _initUserLocation();
    }
  }

  @override
  void didUpdateWidget(covariant InteractiveMap<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(_mapController, widget.positionMapper);
    }

    if (widget.userLocation != null && oldWidget.userLocation == null) {
      _initUserLocation();
    } else if (widget.userLocation == null && oldWidget.userLocation != null) {
      _positionStream?.cancel();
      _positionStream = null;
      _currentUserLocation = null;
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    widget.controller?._detach();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initUserLocation() async {
    final config = widget.userLocation!;

    if (config.requestPermissionAutomatically) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }
    }

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: config.desiredAccuracy,
            distanceFilter: config.distanceFilter,
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _currentUserLocation = LatLng(
                position.latitude,
                position.longitude,
              );
            });
            if (config.followUser) {
              _mapController.move(
                _currentUserLocation!,
                _mapController.camera.zoom,
              );
            }
          }
        });
  }

  Widget _defaultUserLocationMarker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withCustomOpacity(0.2),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int interactiveFlags = InteractiveFlag.all;
    if (widget.interaction?.enablePan == false) {
      interactiveFlags &= ~InteractiveFlag.drag;
    }
    if (widget.interaction?.enableZoom == false) {
      interactiveFlags &= ~InteractiveFlag.pinchZoom;
      interactiveFlags &= ~InteractiveFlag.doubleTapZoom;
      interactiveFlags &= ~InteractiveFlag.scrollWheelZoom;
    }
    if (widget.interaction?.enableRotation == false) {
      interactiveFlags &= ~InteractiveFlag.rotate;
    }

    final List<Marker> itemMarkers = widget.items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Marker(
        point: widget.positionMapper(item),
        width: widget.markerWidth,
        height: widget.markerHeight,
        alignment: Alignment.topCenter,
        // Anchors the bottom tip of a pin to the coordinate
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.interaction?.onTapItem?.call(item, index),
          child: widget.markerBuilder(context, item, index),
        ),
      );
    }).toList();

    return Container(
      color: widget.theme.backgroundColor,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.initialCenter,
          initialZoom: widget.initialZoom,
          keepAlive: widget.interaction?.keepAlive ?? true,
          interactionOptions: InteractionOptions(flags: interactiveFlags),
          onTap: widget.interaction?.onMapTap,
          onLongPress: widget.interaction?.onMapLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: widget.theme.tileUrl,
            userAgentPackageName: widget.theme.userAgent,
            retinaMode: widget.theme.retinaMode,
          ),

          if (widget.clustering != null)
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: widget.clustering!.maxClusterRadius,
                size: widget.clustering!.clusterSize,
                alignment: widget.clustering!.clusterAlignment as Alignment,
                padding: widget.clustering!.clusterPadding,
                maxZoom: widget.clustering!.maxZoom,
                zoomToBoundsOnClick: widget.clustering!.zoomToBoundsOnClick,
                markers: itemMarkers,
                builder: widget.clustering!.clusterBuilder,
              ),
            )
          else
            MarkerLayer(markers: itemMarkers),

          if (widget.userLocation != null && _currentUserLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentUserLocation!,
                  width: 40,
                  height: 40,
                  child:
                      widget.userLocation!.markerBuilder?.call(context) ??
                      _defaultUserLocationMarker(context),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
