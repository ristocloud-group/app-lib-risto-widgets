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
  final bool zoomToBoundsOnClick;
  final EdgeInsets fitBoundsPadding;
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
    this.fitBoundsPadding = const EdgeInsets.all(80.0),
    required this.clusterBuilder,
  });
}

/// Configuration for map control buttons.
class MapControlConfig {
  final AlignmentGeometry alignment;
  final EdgeInsets padding;
  final Widget? icon;
  final Color backgroundColor;
  final Color iconColor;

  const MapControlConfig({
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(16),
    this.icon,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black87,
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

  /// Whether to display a standard floating button to recenter on the user.
  final bool showUserLocationButton;

  /// Visual configuration for the recenter button.
  final MapControlConfig buttonConfig;

  /// Builder for the user's location pin.
  final Widget Function(BuildContext context)? markerBuilder;

  const MapUserLocationConfig({
    this.showHeading = true,
    this.requestPermissionAutomatically = true,
    this.desiredAccuracy = LocationAccuracy.high,
    this.distanceFilter = 10,
    this.followUser = false,
    this.showUserLocationButton = true,
    this.buttonConfig = const MapControlConfig(
      alignment: Alignment.bottomRight,
    ),
    this.markerBuilder,
  });
}

/// Configuration for map interactivity.
class MapInteractionConfig<T> {
  final void Function(T item, int index)? onTapItem;
  final void Function(TapPosition tapPosition, LatLng point)? onMapTap;
  final void Function(TapPosition tapPosition, LatLng point)? onMapLongPress;
  final double? focusedZoom;
  final bool enableZoom;
  final bool enablePan;
  final bool enableRotation;
  final bool showCompass;
  final bool keepAlive;

  const MapInteractionConfig({
    this.onTapItem,
    this.onMapTap,
    this.onMapLongPress,
    this.focusedZoom = 15.0,
    this.enableZoom = true,
    this.enablePan = true,
    this.enableRotation = false,
    this.showCompass = true,
    this.keepAlive = true,
  });
}

/// Configuration for the map's visual theme and tile provider.
class MapThemeConfig {
  final String tileUrl;
  final String userAgent;
  final Color backgroundColor;
  final bool retinaMode;
  final Map<String, String>? additionalHeaders;

  const MapThemeConfig({
    // Standard OSM (Development only - triggers warning)
    this.tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.userAgent = 'com.risto.library',
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.retinaMode = true,
    this.additionalHeaders,
  });

  // ===========================================================================
  // 🌟 PRODUCTION-READY FREE TIER PRESETS 🌟
  // ===========================================================================

  /// Mapbox (Generous Free Tier: 50,000 loads/month)
  /// Get a key at: https://www.mapbox.com/
  factory MapThemeConfig.mapbox({
    required String accessToken,
    String styleId = 'streets-v12', // Try: light-v11, dark-v11, outdoors-v12
    String userAgent = 'com.risto.library',
  }) {
    return MapThemeConfig(
      tileUrl:
          'https://api.mapbox.com/styles/v1/mapbox/$styleId/tiles/256/{z}/{x}/{y}@2x?access_token=$accessToken',
      userAgent: userAgent,
    );
  }

  /// Jawg Maps (Generous Free Tier: 50,000 mapviews/month)
  /// Extremely fast and designed specifically for Leaflet/flutter_map.
  /// Get a key at: https://www.jawg.io/
  factory MapThemeConfig.jawg({
    required String accessToken,
    String style = 'jawg-sunny', // Try: jawg-streets, jawg-dark, jawg-light
    String userAgent = 'com.risto.library',
  }) {
    return MapThemeConfig(
      tileUrl:
          'https://tile.jawg.io/$style/{z}/{x}/{y}{r}.png?access-token=$accessToken',
      userAgent: userAgent,
    );
  }

  /// Stadia Maps (Free Tier: 2,500 mapviews/day for non-commercial use)
  /// Great minimalist styles.
  /// Get a key at: https://stadiamaps.com/
  factory MapThemeConfig.stadia({
    String? apiKey,
    String style = 'alidade_smooth', // Try: osm_bright, outdoors
    String userAgent = 'com.risto.library',
  }) {
    final url = apiKey != null
        ? 'https://tiles.stadiamaps.com/tiles/$style/{z}/{x}/{y}{r}.png?api_key=$apiKey'
        : 'https://tiles.stadiamaps.com/tiles/$style/{z}/{x}/{y}{r}.png';
    return MapThemeConfig(tileUrl: url, userAgent: userAgent);
  }
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

  final MapControlConfig? compassConfig;
  final MapControlConfig? zoomConfig;

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
    this.compassConfig = const MapControlConfig(alignment: Alignment.topRight),
    this.zoomConfig = const MapControlConfig(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(bottom: 90, right: 16),
    ),
    this.initialCenter = const LatLng(45.4642, 9.1900),
    this.initialZoom = 13.0,
    this.markerWidth = 80.0,
    this.markerHeight = 80.0,
  });

  /// Factory tailored for Delivery Tracking.
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
    double markerWidth = 80.0,
    double markerHeight = 80.0,
    double? focusedZoom = 15.0,
    MapInteractionConfig<T>? interaction,
    MapThemeConfig? theme,
    MapUserLocationConfig? userLocation,
    MapControlConfig? zoomConfig,
  }) {
    return InteractiveMap<T>(
      key: key,
      items: items,
      positionMapper: positionMapper,
      markerBuilder: markerBuilder,
      controller: controller,
      initialCenter: initialCenter,
      initialZoom: 12.0,
      markerWidth: markerWidth,
      markerHeight: markerHeight,
      theme: theme ?? const MapThemeConfig(),
      compassConfig: null,
      userLocation: userLocation,
      zoomConfig: zoomConfig,
      interaction:
          interaction ??
          MapInteractionConfig<T>(
            onTapItem: onDeliveryTapped,
            enableRotation: false,
            showCompass: false,
            focusedZoom: focusedZoom,
          ),
      clustering: MapClusteringConfig(
        maxZoom: 16,
        fitBoundsPadding: const EdgeInsets.all(80.0),
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
  factory InteractiveMap.locator({
    Key? key,
    required List<T> items,
    required LatLng Function(T item) positionMapper,
    required Widget Function(BuildContext context, T item, int index)
    markerBuilder,
    void Function(T item, int index)? onStoreTapped,
    void Function(TapPosition, LatLng)? onMapTapped,
    InteractiveMapController<T>? controller,
    double markerWidth = 80.0,
    double markerHeight = 80.0,
    double? focusedZoom = 15.0,
    MapInteractionConfig<T>? interaction,
    MapThemeConfig? theme,
    MapControlConfig? compassConfig = const MapControlConfig(
      alignment: Alignment.topRight,
    ),
    MapUserLocationConfig? userLocation = const MapUserLocationConfig(
      followUser: false,
      requestPermissionAutomatically: false,
      showUserLocationButton: false,
      buttonConfig: MapControlConfig(alignment: Alignment.bottomRight),
    ),
    MapControlConfig? zoomConfig,
  }) {
    return InteractiveMap<T>(
      key: key,
      items: items,
      positionMapper: positionMapper,
      markerBuilder: markerBuilder,
      controller: controller,
      markerWidth: markerWidth,
      markerHeight: markerHeight,
      theme: theme ?? const MapThemeConfig(),
      compassConfig: compassConfig,
      userLocation: userLocation,
      zoomConfig: zoomConfig,
      interaction:
          interaction ??
          MapInteractionConfig<T>(
            onTapItem: onStoreTapped,
            onMapTap: onMapTapped,
            enableRotation: true,
            showCompass: true,
            focusedZoom: focusedZoom,
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
    if (widget.userLocation != null) _initUserLocation();
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
        if (permission == LocationPermission.deniedForever) return;
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
            setState(
              () => _currentUserLocation = LatLng(
                position.latitude,
                position.longitude,
              ),
            );
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
      interactiveFlags &=
          ~(InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom);
    }
    if (widget.interaction?.enableRotation == false) {
      interactiveFlags &= ~InteractiveFlag.rotate;
    }

    final List<Marker> itemMarkers = widget.items.asMap().entries.map((entry) {
      return Marker(
        point: widget.positionMapper(entry.value),
        width: widget.markerWidth,
        height: widget.markerHeight,
        alignment: Alignment.center,
        rotate: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final targetZoom =
                widget.interaction?.focusedZoom ?? _mapController.camera.zoom;
            _mapController.move(widget.positionMapper(entry.value), targetZoom);
            widget.interaction?.onTapItem?.call(entry.value, entry.key);
          },
          child: widget.markerBuilder(context, entry.value, entry.key),
        ),
      );
    }).toList();

    return Stack(
      children: [
        Container(
          color: widget.theme.backgroundColor,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: widget.initialZoom,
              interactionOptions: InteractionOptions(flags: interactiveFlags),
              onTap: widget.interaction?.onMapTap,
              onLongPress: widget.interaction?.onMapLongPress,
            ),
            children: [
              TileLayer(
                urlTemplate: widget.theme.tileUrl,
                userAgentPackageName: widget.theme.userAgent,
                retinaMode: widget.theme.retinaMode,
                additionalOptions: widget.theme.additionalHeaders ?? {},
              ),
              if (widget.clustering != null)
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: widget.clustering!.maxClusterRadius,
                    size: widget.clustering!.clusterSize,
                    alignment: widget.clustering!.clusterAlignment as Alignment,
                    padding: widget.clustering!.clusterPadding,
                    maxZoom: widget.clustering!.maxZoom,
                    zoomToBoundsOnClick: false,
                    onClusterTap: (clusterNode) {
                      if (widget.clustering!.zoomToBoundsOnClick) {
                        _mapController.fitCamera(
                          CameraFit.bounds(
                            bounds: clusterNode.bounds,
                            padding: widget.clustering!.fitBoundsPadding,
                          ),
                        );
                      }
                    },
                    polygonOptions: const PolygonOptions(
                      borderColor: Colors.transparent,
                      color: Colors.transparent,
                      borderStrokeWidth: 0,
                    ),
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
                      alignment: Alignment.center,
                      rotate: true,
                      child:
                          widget.userLocation!.markerBuilder?.call(context) ??
                          _defaultUserLocationMarker(context),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // =====================================================================
        // ALIGNED MAP CONTROLS (Grouped into a single column)
        // =====================================================================
        Align(
          // We anchor the whole column using the zoomConfig alignment if present,
          // otherwise fallback to bottom right.
          alignment: widget.zoomConfig?.alignment ?? Alignment.bottomRight,
          child: Padding(
            padding:
                widget.zoomConfig?.padding ??
                const EdgeInsets.only(bottom: 90, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 1. COMPASS (Only visible if rotated & enabled)
                if (widget.interaction?.enableRotation == true &&
                    widget.interaction?.showCompass == true &&
                    widget.compassConfig != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: StreamBuilder<MapEvent>(
                      stream: _mapController.mapEventStream,
                      builder: (context, _) {
                        final rotation = _mapController.camera.rotation;
                        if (rotation == 0.0) return const SizedBox.shrink();
                        return FloatingActionButton.small(
                          heroTag: 'compass',
                          backgroundColor:
                              widget.compassConfig!.backgroundColor,
                          onPressed: () => _mapController.rotate(0.0),
                          child:
                              widget.compassConfig!.icon ??
                              Transform.rotate(
                                angle: -_mapController.camera.rotationRad,
                                child: Icon(
                                  Icons.navigation,
                                  color: widget.compassConfig!.iconColor,
                                ),
                              ),
                        );
                      },
                    ),
                  ),

                // 2. RECENTER BUTTON (Always rendered if enabled, forces fetch if null)
                if (widget.userLocation?.showUserLocationButton == true)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton.small(
                      heroTag: 'recenter',
                      backgroundColor:
                          widget.userLocation!.buttonConfig.backgroundColor,
                      onPressed: () async {
                        if (_currentUserLocation != null) {
                          _mapController.move(
                            _currentUserLocation!,
                            _mapController.camera.zoom,
                          );
                        } else {
                          // Fetch manually if location hasn't locked yet
                          try {
                            final pos = await Geolocator.getCurrentPosition(
                              locationSettings: LocationSettings(
                                accuracy: widget.userLocation!.desiredAccuracy,
                              ),
                            );
                            if (mounted) {
                              setState(() {
                                _currentUserLocation = LatLng(
                                  pos.latitude,
                                  pos.longitude,
                                );
                              });
                              _mapController.move(
                                _currentUserLocation!,
                                _mapController.camera.zoom,
                              );
                            }
                          } catch (e) {
                            // Ignored or handle permission exception
                          }
                        }
                      },
                      child:
                          widget.userLocation!.buttonConfig.icon ??
                          Icon(
                            Icons.my_location,
                            color: widget.userLocation!.buttonConfig.iconColor,
                          ),
                    ),
                  ),

                // 3. ZOOM CONTROLS
                if (widget.interaction?.enableZoom == true &&
                    widget.zoomConfig != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        backgroundColor: widget.zoomConfig!.backgroundColor,
                        onPressed: () => _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom + 1,
                        ),
                        child: Icon(
                          Icons.add,
                          color: widget.zoomConfig!.iconColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        backgroundColor: widget.zoomConfig!.backgroundColor,
                        onPressed: () => _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom - 1,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: widget.zoomConfig!.iconColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
