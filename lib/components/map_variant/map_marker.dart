import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/models/lat_long.dart';

class MapMarker {
  final String name;
  final LatLong latLong;
  final double heading;
  final String? filename;
  final int? size;
  final Offset? offset;
  final Color fillColor;
  final Color borderColor;

  MapMarker({
    required this.name,
    required this.latLong,
    this.heading = 0,
    this.offset,
    this.size,
    this.filename,
    this.fillColor = Colors.blue,
    this.borderColor = Colors.white,
  });

  LatLong get location => latLong;
}
