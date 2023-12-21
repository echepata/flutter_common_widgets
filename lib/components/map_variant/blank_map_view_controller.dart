import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/models/lat_long.dart';
import 'package:flutter_common_widgets/components/map_variant/i_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/map_marker_cluster.dart';
import 'package:flutter_common_widgets/components/map_variant/map_view_factory.dart';
import 'package:flutter_common_widgets/models/polyline_type.dart';

class BlankMapViewController extends IMapViewController {
  @override
  void showLocationIndicator({
    Duration updateFrequency = const Duration(seconds: 5),
    Function(
      LatLong? latLong,
      IMapViewController mapViewController,
    )? onFirstFix,
  }) {
    // do nothing
  }

  @override
  void clearMap() {
    // do nothing
  }

  @override
  Future<void> addRouteLine(
    LatLong origin,
    LatLong destination,
    Color polylineColor, {
    String? id,
    PolylinePatternType? polylinePatternType,
    TransportMethod transportMethod = TransportMethod.driving,
  }) async {
    // TODO: implement addPolyline
  }

  @override
  void clearPolylines() {
    // TODO: implement clearPolylines
  }

  @override
  void moveMapToDeviceLocation() {
    // do nothing
  }

  @override
  bool isReady() => true;

  @override
  drawCircle(
    LatLong center,
    double radius, {
    Color? fillColor,
    Color? strokeColor,
    int strokeWidth = 1,
    String? id,
  }) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  void clearLocationIndicator() {}

  @override
  void clearMarkers() {}

  @override
  void onTapMarker() {
    // TODO: implement onTapPin
  }

  @override
  void moveMapCenter(
    List<LatLong> latLongs, {
    ZoomLevel zoomLevel = ZoomLevel.neighborhood,
  }) {
    // TODO: implement moveMapCenter
  }

  @override
  void setMapPadding(EdgeInsets padding) {
    // TODO: implement setMapPadding
  }

  @override
  void addMarkers(List<MapMarkerCluster> clusterList) {
    // TODO: implement buildMarker
  }

  @override
  EdgeInsets getMapPadding() {
    // TODO: implement getMapPadding
    throw UnimplementedError();
  }

  @override
  void setPreventMapClustering(bool preventMapClustering) {
    // TODO: implement setPreventMapClustering
  }

  @override
  Future<LatLong?> getCurrentCenter() {
    // TODO: implement getCurrentCenter
    throw UnimplementedError();
  }
}
