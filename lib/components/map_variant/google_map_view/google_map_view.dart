import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_common_widgets/business_layer/config/config.dart';
import 'package:flutter_common_widgets/business_layer/models/mapping/lat_long.dart';
import 'package:flutter_common_widgets/composition_root/dependency_provider.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/google_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/view_models/google_map_view_model.dart';
import 'package:provider/provider.dart';

class GoogleMapView extends StatefulWidget {
  final void Function() onMapCreated;
  final void Function(LatLong) onCameraMove;
  final void Function() onCameraMoveStart;
  final void Function(LatLong) onCameraIdle;

  final GoogleMapsController mapViewController;

  late final LatLong _defaultMapCenter;

  final LatLong? initialCenter;

  final double initialZoom;

  final bool preventPanning;

  GoogleMapView({
    super.key,
    required this.onCameraMoveStart,
    required this.onCameraIdle,
    required this.onCameraMove,
    required this.onMapCreated,
    required this.mapViewController,
    this.initialCenter,
    this.initialZoom = 15,
    this.preventPanning = false,
  }) {
    Config config = DependencyProvider.get<Config>();
    _defaultMapCenter = config.getDefaultMapCenter();
  }

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late LatLong _lastMapPosition;

  @override
  void initState() {
    super.initState();

    _lastMapPosition = LatLong(
      latitude: widget._defaultMapCenter.latitude,
      longitude: widget._defaultMapCenter.longitude,
    );

    if (widget.initialCenter != null) {
      _lastMapPosition = LatLong(
        latitude: widget.initialCenter!.latitude,
        longitude: widget.initialCenter!.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng center = LatLng(
      widget._defaultMapCenter.latitude,
      widget._defaultMapCenter.longitude,
    );

    if (widget.initialCenter != null) {
      center = LatLng(
        widget.initialCenter!.latitude,
        widget.initialCenter!.longitude,
      );
    }

    var vm = context.watch<GoogleMapViewModel>();
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: widget.initialZoom,
      ),
      padding: vm.mapsPadding,
      onCameraIdle: _onCameraIdle,
      onCameraMoveStarted: widget.onCameraMoveStart,
      onCameraMove: _onCameraMove,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: _handleOnMapCreated,
      circles: vm.circles,
      markers: vm.markers,
      polylines: vm.polylines,
      scrollGesturesEnabled: !widget.preventPanning,
      zoomGesturesEnabled: !widget.preventPanning,
      rotateGesturesEnabled: !widget.preventPanning,
      buildingsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  _onCameraMove(CameraPosition position) {
    var vm = context.read<GoogleMapViewModel>();

    LatLong currentPosition = LatLong(
      latitude: position.target.latitude,
      longitude: position.target.longitude,
    );

    _lastMapPosition = currentPosition;

    widget.onCameraMove(currentPosition);

    if (!vm.preventMapClustering) {
      vm.clusterManager.onCameraMove(position);
    }
  }

  _onCameraIdle() {
    var vm = context.read<GoogleMapViewModel>();
    widget.onCameraIdle(_lastMapPosition);
    if (!vm.preventMapClustering) {
      vm.clusterManager.updateMap();
    }
  }

  void _handleOnMapCreated(GoogleMapController googleMapController) {
    var vm = context.read<GoogleMapViewModel>();
    updateMapBrightness(googleMapController);
    widget.mapViewController.setGoogleMapController(googleMapController);
    widget.mapViewController.setGoogleMapViewModel(vm);
    vm.clusterManager.setMapId(googleMapController.mapId);
    widget.onMapCreated();
  }

  @override
  void dispose() {
    widget.mapViewController.clearMap();
    super.dispose();
  }

  void updateMapBrightness(GoogleMapController controller) {
    if (getPlatformBrightness() == Brightness.dark) {
      _setMapStyle('assets/map_styles/gmaps_night_mode.json', controller);
    } else {
      _setMapStyle('assets/map_styles/gmaps_day_mode.json', controller);
    }
  }

  Brightness? getPlatformBrightness() {
    return View.of(context).platformDispatcher.platformBrightness;
  }

  /// [mapStylePath] is a string that points to the JSON file that contains the
  /// style data.
  void _setMapStyle(String mapStylePath, GoogleMapController controller) async {
    String fileContent = await _getFileData(mapStylePath);
    controller.setMapStyle(fileContent);
  }

  Future<String> _getFileData(String path) async {
    return rootBundle.loadString(path);
  }
}
