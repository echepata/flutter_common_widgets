import 'package:flutter_common_widgets/models/lat_long.dart';
import 'package:flutter_common_widgets/components/map_variant/map_marker.dart';

class MapMarkerCluster {
  final List<MapMarker> markers;

  Function(
    LatLong markerLocation,
    bool isCluster,
    List<LatLong> allLocationsInCluster,
  )? onTap;

  MapMarkerCluster({required this.markers, this.onTap});
}
