import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/models/lat_long.dart';
import 'package:flutter_common_widgets/components/map_variant/map_marker_cluster.dart';
import 'package:flutter_common_widgets/components/map_variant/map_view_factory.dart';
import 'package:flutter_common_widgets/models/polyline_type.dart';

abstract class IMapViewController {
  /// If the list of lat long is greater than 1, the zoom level will be ignored.
  void moveMapCenter(
    List<LatLong> latLongs, {
    ZoomLevel zoomLevel = ZoomLevel.neighborhood,
  });

  void moveMapToDeviceLocation();

  void showLocationIndicator({
    Duration updateFrequency = const Duration(seconds: 5),
    Function(LatLong? latLong, IMapViewController mapViewController)?
        onFirstFix,
  });

  drawCircle(
    LatLong center,
    double radius, {
    Color? fillColor,
    Color? strokeColor,
    int strokeWidth = 1,
    String? id,
  });

  void clearMap();

  void clearMarkers();

  void clearLocationIndicator();

  bool isReady();

  void onTapMarker();

  Future<void> addRouteLine(
    LatLong origin,
    LatLong destination,
    Color polylineColor, {
    PolylinePatternType? polylinePatternType,
    String? id,
    TransportMethod transportMethod = TransportMethod.driving,
  });

  void clearPolylines();

  void setMapPadding(EdgeInsets padding);

  EdgeInsets getMapPadding();

  void setPreventMapClustering(bool preventMapClustering);

  /// This will build the marker's action and looks
  void addMarkers(List<MapMarkerCluster> clusterList);

  Future<LatLong?> getCurrentCenter();
}

enum TransportMethod { driving, walking, bicycling, transit }
