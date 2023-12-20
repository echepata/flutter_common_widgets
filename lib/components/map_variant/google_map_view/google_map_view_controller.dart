import 'dart:async';

import 'package:fleetcutter_helpers/location_helpers.dart';
import 'package:fleetcutter_helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_common_widgets/business_layer/models/mapping/lat_long.dart';
import 'package:flutter_common_widgets/business_layer/services/i_logger_service.dart';
import 'package:flutter_common_widgets/composition_root/dependency_registrant.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/view_models/google_map_view_model.dart';
import 'package:flutter_common_widgets/components/map_variant/i_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/map_marker_cluster.dart';
import 'package:flutter_common_widgets/components/map_variant/map_view_factory.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';
import 'package:flutter_common_widgets/presentation_layer/infrastructure/enums/polyline_type.dart';

class GoogleMapsController extends IMapViewController {
  GoogleMapController? _googleMapController;
  GoogleMapViewModel? _googleMapViewModel;
  LatLong? _lastKnownLocation;
  Timer? _timer;
  late final ILoggerService _loggerService;

  GoogleMapsController() {
    _loggerService = DP.get<ILoggerService>();
  }

  void setGoogleMapController(GoogleMapController mapController) {
    _googleMapController = mapController;
  }

  void setGoogleMapViewModel(GoogleMapViewModel mapViewModel) {
    _googleMapViewModel = mapViewModel;
  }

  @override
  void clearMap() {
    _googleMapController?.dispose();
    _timer?.cancel();
  }

  @override
  bool isReady() {
    return _googleMapController is GoogleMapController;
  }

  @override
  Future<void> moveMapCenter(
    List<LatLong> latLongs, {
    ZoomLevel zoomLevel = ZoomLevel.neighborhood,
  }) async {
    if (latLongs.length > 1) {
      final bounds = CameraUpdate.newLatLngBounds(
        _getLatLngBounds(latLongs),
        stdPadding * 4,
      );
      _googleMapController?.animateCamera(bounds);
    } else {
      _googleMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            latLongs.first.latitude,
            latLongs.first.longitude,
          ),
          getZoomLevelValue(zoomLevel),
        ),
      );
    }
  }

  /// This will return the southwest and northeast bounds from a list of
  /// coordinates
  LatLngBounds _getLatLngBounds(List<LatLong> coordinates) {
    final allLatitudes = coordinates.map((e) => e.latitude).toList();
    final allLongitudes = coordinates.map((e) => e.longitude).toList();

    allLatitudes.sort();
    allLongitudes.sort();

    final southWest = LatLng(allLatitudes.first, allLongitudes.first);
    final northEast = LatLng(allLatitudes.last, allLongitudes.last);

    return LatLngBounds(
      southwest: southWest,
      northeast: northEast,
    );
  }

  @override
  void moveMapToDeviceLocation() {
    if (_lastKnownLocation is LatLong) {
      moveMapCenter([_lastKnownLocation!]);
    } else {
      _loggerService.debug('Unknown');
    }
  }

  @override
  void showLocationIndicator({
    Duration updateFrequency = const Duration(seconds: 5),
    Function(LatLong? latLong, IMapViewController mapViewController)?
        onFirstFix,
  }) async {
    if (_timer is! Timer || !_timer!.isActive) {
      await _updateLocationWithDeviceLocation(
        onFix: onFirstFix,
        updateFromRoute: false,
      );
      _timer = Timer.periodic(updateFrequency, (timer) {
        _updateLocationWithDeviceLocation(updateFromRoute: false);
      });
    }
  }

  Future<void> _updateLocationWithDeviceLocation({
    Function(LatLong? latLong, IMapViewController mapViewController)? onFix,
    required bool updateFromRoute,
  }) async {
    try {
      final location = await LocationHelpers.getLocation();
      _lastKnownLocation = LatLong(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (onFix != null) {
        onFix(_lastKnownLocation, this);
      }

      _googleMapViewModel!.reloadMapView();
    } catch (e) {
      if (onFix != null) {
        _lastKnownLocation = null;
        onFix(_lastKnownLocation, this);
      }
    }
  }

  @override
  drawCircle(
    LatLong center,
    double radius, {
    Color? fillColor,
    Color? strokeColor,
    int strokeWidth = 1,
    String? id,
  }) {
    if (_googleMapViewModel is GoogleMapViewModel) {
      var id0 = id ?? StringHelper.generateNonce();

      _googleMapViewModel!.addCircle(
        id0,
        center,
        radius,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      );
    }
  }

  @override
  void clearLocationIndicator() {}

  @override
  void clearMarkers() {
    _googleMapViewModel!.clearMarkers();
  }

  @override
  void onTapMarker() {
    // TODO: implement onTapPin
  }

  @override
  Future<void> addRouteLine(
    LatLong origin,
    LatLong destination,
    Color polylineColor, {
    PolylinePatternType? polylinePatternType,
    String? id,
    TransportMethod transportMethod = TransportMethod.driving,
  }) async {
    var id0 = id ?? StringHelper.generateNonce();
    await _googleMapViewModel!.addPolyline(
      id0,
      origin,
      destination,
      polylineColor,
      polylinePatternType ?? PolylinePatternType.line,
      transportMethod: transportMethod,
    );
  }

  @override
  void clearPolylines() {
    _googleMapViewModel!.clearPolylines();
  }

  @override
  void setMapPadding(EdgeInsets padding) {
    _googleMapViewModel!.setMapPadding(padding);
  }

  @override
  EdgeInsets getMapPadding() {
    return _googleMapViewModel!.mapsPadding;
  }

  @override
  void addMarkers(List<MapMarkerCluster> clusterList) {
    _googleMapViewModel!.addClusters(clusterList);
  }

  @override
  void setPreventMapClustering(bool preventMapClustering) {
    _googleMapViewModel!.setPreventMapClustering(preventMapClustering);
  }

  @override
  Future<LatLong?> getCurrentCenter() async {
    if (_googleMapController != null) {
      final bounds = await _googleMapController?.getVisibleRegion();
      if (bounds != null) {
        final centerLat =
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
        final centerLong =
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
        return LatLong(latitude: centerLat, longitude: centerLong);
      }
    }
    return null;
  }

  double getZoomLevelValue(ZoomLevel zoomLevel) {
    switch (zoomLevel) {
      case ZoomLevel.street:
        return 17;
      case ZoomLevel.neighborhood:
        return 16;
      case ZoomLevel.suburb:
        return 13;
      case ZoomLevel.city:
        return 10;
    }
  }
}
