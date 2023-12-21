import 'dart:ui';

import 'package:flutter_misc_helpers/Enums/device_screen_type.dart';
import 'package:flutter_misc_helpers/platform_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_common_widgets/models/lat_long.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/models/map_cluster_item.dart';
import 'package:flutter_common_widgets/components/map_variant/i_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/map_marker_cluster.dart';
import 'package:flutter_common_widgets/components/map_variant/map_view_factory.dart';
import 'package:flutter_common_widgets/models/polyline_type.dart';

class GoogleMapViewModel extends ChangeNotifier {
  Set<Circle> circles = {};

  final Map<String, Circle> _internalCircles = {};

  Set<Marker> markers = {};
  final Map<String, Marker> _internalMarkers = {};

  Set<Polyline> polylines = {};

  final Map<String, Polyline> _internalPolylines = {};

  EdgeInsets mapsPadding = EdgeInsets.zero;

  late ClusterManager clusterManager;

  late bool preventMapClustering = false;
  final String _googleMapsApiKey;

  GoogleMapViewModel({required String googleMapsApiKey})
      : _googleMapsApiKey = googleMapsApiKey {
    initClusterManager();
  }

  static Map<PolylinePatternType, List<PatternItem>> patternType = {
    PolylinePatternType.line: <PatternItem>[],
    PolylinePatternType.dashed: <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
    ],
    PolylinePatternType.dotted: <PatternItem>[
      PatternItem.dot,
      PatternItem.gap(10.0),
    ],
    PolylinePatternType.dashdot: <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(10.0),
      PatternItem.dot,
      PatternItem.gap(10.0),
    ],
  };

  void initClusterManager() {
    clusterManager = ClusterManager<MapClusterItem>(
      [],
      setMapMarkers,
      markerBuilder: markerBuilder,
      stopClusteringZoom: 14,
    );
  }

  void addCircle(
    String id,
    LatLong center,
    double radius, {
    Color? fillColor,
    Color? strokeColor,
    int strokeWidth = 1,
  }) {
    if (_internalCircles.containsKey(id)) {
      _internalCircles.removeWhere((key, _) => key == id);
    }

    _internalCircles[id] = Circle(
      circleId: CircleId(id),
      center: LatLng(center.latitude, center.longitude),
      radius: radius,
      fillColor: fillColor ?? Colors.blue.withOpacity(0.2),
      strokeColor: strokeColor ?? Colors.blue,
      strokeWidth: strokeWidth,
    );

    circles = Set.from(_internalCircles.values);

    notifyListeners();
  }

  void removeCircle(String id) {
    if (_internalCircles.containsKey(id)) {
      _internalCircles.removeWhere((key, value) => key == id);
    }
    circles = Set.from(_internalCircles.values);

    notifyListeners();
  }

  void clearMarkers() {
    markers.clear();
    _internalMarkers.clear();
    List<MapClusterItem> emptyList = [];
    clusterManager.setItems(emptyList);
    notifyListeners();
  }

  void clearPolylines() {
    polylines.clear();
    _internalPolylines.clear();

    notifyListeners();
  }

  void reloadMapView() {
    notifyListeners();
  }

  Future<void> addPolyline(
    String id,
    LatLong origin,
    LatLong destination,
    Color polylineColor,
    PolylinePatternType? polylinePatternType, {
    TransportMethod transportMethod = TransportMethod.driving,
  }) async {
    GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(
      apiKey: _googleMapsApiKey,
    );

    try {
      List<LatLng>? coordinates = await googleMapPolyline
          .getCoordinatesWithLocation(
            origin: LatLng(
              origin.latitude,
              origin.longitude,
            ),
            destination: LatLng(
              destination.latitude,
              destination.longitude,
            ),
            mode: transportMethod.toRouteMode(),
          )
          .timeout(const Duration(seconds: 3));

      PolylineId polyId = PolylineId(id);

      if (_internalPolylines.containsKey(id)) {
        _internalPolylines.removeWhere((key, _) => key == id);
      }

      if (coordinates != null) {
        _internalPolylines[id] = Polyline(
          polylineId: polyId,
          patterns: patternType[polylinePatternType]!,
          color: polylineColor,
          points: coordinates,
          width: 5,
          onTap: () {},
        );
      }

      polylines = Set.from(_internalPolylines.values);
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }

  void setMapPadding(EdgeInsets padding) {
    mapsPadding = padding;
    notifyListeners();
  }

  void setMapMarkers(Set<Marker> markers) {
    this.markers = markers;
    notifyListeners();
  }

  void setPreventMapClustering(bool preventMapClustering) {
    this.preventMapClustering = preventMapClustering;
    notifyListeners();
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

  void addClusters(List<MapMarkerCluster> clusterList) async {
    for (var element in clusterList) {
      for (var marker in element.markers) {
        Uint8List? pngUint8List;

        if (marker.filename != null) {
          ByteData byteData = await rootBundle.load(marker.filename!);
          pngUint8List = byteData.buffer.asUint8List();
        }

        clusterManager.addItem(
          MapClusterItem(
            latLong: marker.latLong,
            heading: marker.heading,
            markerIconData: pngUint8List,
            fillColor: marker.fillColor,
            borderColor: marker.borderColor,
            offset: marker.offset,
            onTap: element.onTap,
            size: marker.size,
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<Marker> Function(Cluster<MapClusterItem>) get markerBuilder {
    return (cluster) async {
      var clusterItem = cluster.items.first;
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        onTap: clusterItem.onTap != null
            ? () {
                clusterItem.onTap!(
                  LatLong(
                    latitude: cluster.location.latitude,
                    longitude: cluster.location.longitude,
                  ),
                  cluster.items.length > 1,
                  cluster.items.map((e) => e.latLong).toList(),
                );
              }
            : null,
        icon: await _buildMarkerIcon(
          size: clusterItem.size ?? _getMarkerSize(cluster),
          markerIconData: clusterItem.markerIconData,
          fillColor: clusterItem.fillColor,
          borderColor: clusterItem.borderColor,
          text: cluster.isMultiple ? cluster.count.toString() : null,
        ),
        rotation:
            cluster.items.length == 1 ? (cluster.items.first.heading ?? 0) : 0,
        anchor: clusterItem.offset ?? const Offset(0.5, 1.0),
      );
    };
  }

  Future<BitmapDescriptor> _buildMarkerIcon({
    int size = 30,
    Uint8List? markerIconData,
    String? text,
    Color? fillColor,
    Color? borderColor,
  }) async {
    double aspectRatio = 1;
    if (markerIconData != null) {
      aspectRatio = await getAspectRatio(markerIconData);
    }
    return markerIconData != null
        ? BitmapDescriptor.fromBytes(
            markerIconData,
            size: Size(size.toDouble(), size / aspectRatio),
          )
        : await getMarkerBitmap(
            size,
            fillColor: fillColor,
            borderColor: borderColor,
            text: text,
          );
  }

  Future<double> getAspectRatio(Uint8List imageData) async {
    // Decode the image
    Codec codec = await instantiateImageCodec(imageData);
    FrameInfo frameInfo = await codec.getNextFrame();

    // Extract the image dimensions
    int width = frameInfo.image.width;
    int height = frameInfo.image.height;

    // Calculate and return the aspect ratio
    return width / height;
  }

  int _getMarkerSize(Cluster<MapClusterItem> cluster) {
    var mediaQuery = MediaQueryData.fromView(
      PlatformDispatcher.instance.implicitView!,
    );
    var deviceType = getDeviceType(mediaQuery);
    switch (deviceType) {
      case DeviceScreenType.smallMobile:
        return cluster.isMultiple ? 100 : 60;
      case DeviceScreenType.tablet:
        return cluster.isMultiple ? 80 : 40;
      case DeviceScreenType.desktop:
        return cluster.isMultiple ? 60 : 40;
      case DeviceScreenType.mobile:
      default:
        return cluster.isMultiple ? 120 : 70;
    }
  }

  Future<BitmapDescriptor> getMarkerBitmap(
    int size, {
    String? text,
    Color? fillColor,
    Color? borderColor,
  }) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    var path = Path();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = fillColor!; // circle fill
    final Paint paint2 = Paint()..color = borderColor!; // circle border

    var center = Offset(size / 2, size / 2);
    path.addOval(Rect.fromCircle(center: center, radius: size / 2.2));

    canvas.drawShadow(path, Colors.black, 3, true); // circle shadow
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}

extension TransportMethodToRouteMode on TransportMethod {
  RouteMode toRouteMode() {
    var map = {
      TransportMethod.driving: RouteMode.driving,
      TransportMethod.transit: RouteMode.transit,
      TransportMethod.walking: RouteMode.walking,
      TransportMethod.bicycling: RouteMode.bicycling,
    };

    return map[this] ?? RouteMode.driving;
  }
}
