import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_common_widgets/business_layer/models/mapping/lat_long.dart';

class MapClusterItem extends ClusterItem {
  final LatLong latLong;
  final double? heading;
  final Offset? offset;
  final int? size;
  final Uint8List? markerIconData;
  final Color fillColor;
  final Color borderColor;
  final Function(LatLong, bool, List<LatLong>)? onTap;

  MapClusterItem({
    required this.latLong,
    this.heading,
    this.offset,
    this.size,
    this.markerIconData,
    this.fillColor = Colors.blue,
    this.borderColor = Colors.white,
    this.onTap,
  });

  @override
  LatLng get location => LatLng(latLong.latitude, latLong.longitude);
}
