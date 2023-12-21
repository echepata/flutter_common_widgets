import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/models/lat_long.dart';
import 'package:flutter_common_widgets/components/map_variant/blank_map_view.dart';
import 'package:flutter_common_widgets/components/map_variant/blank_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/google_map_view.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/google_map_view_controller.dart';
import 'package:flutter_common_widgets/components/map_variant/google_map_view/view_models/google_map_view_model.dart';
import 'package:flutter_common_widgets/components/map_variant/i_map_view_controller.dart';
import 'package:flutter_common_widgets/models/map_provider.dart';
import 'package:provider/provider.dart';

class MapViewFactory {
  final MapProvider selectedMapType;
  Widget? _mapInstance;
  final String googleMapsApiKey;

  static const Map<ZoomLevel, double> googleZoomLevelMap = {
    ZoomLevel.city: 10,
    ZoomLevel.suburb: 13,
    ZoomLevel.neighborhood: 15,
    ZoomLevel.street: 17,
  };

  /// This is a file path to your assets folder, pointing to a JSON file that
  /// contains the styles for this map
  final String? googleDarkModeStyleFile;

  /// This is a file path to your assets folder, pointing to a JSON file that
  /// contains the styles for this map
  final String? googleLightModeStyleFile;

  MapViewFactory({
    required this.selectedMapType,
    required this.googleMapsApiKey,
    required this.googleDarkModeStyleFile,
    required this.googleLightModeStyleFile,
  });

  MapViewFactoryResult make({
    Function(LatLong)? onCameraMove,
    Function()? onCameraMoveStart,
    Function(LatLong)? onCameraIdle,
    required bool showDeviceLocation,
    required Function(IMapViewController mapViewController) onMapCreated,
    Function(LatLong? latLong, IMapViewController mapViewController)?
        onFirstFix,
    required LatLong initialCenter,
    ZoomLevel? initialZoom = ZoomLevel.neighborhood,
    bool preventPanning = false,
  }) {
    IMapViewController mapViewController;

    switch (selectedMapType) {
      case MapProvider.googleMaps:
        mapViewController = GoogleMapsController();
        _mapInstance = MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleMapViewModel>(
              create: (_) => GoogleMapViewModel(
                googleMapsApiKey: googleMapsApiKey,
              ),
            ),
          ],
          child: GoogleMapView(
            mapViewController: mapViewController as GoogleMapsController,
            onMapCreated: () {
              _googleOnMapCreatedHandler(
                onMapCreated,
                showDeviceLocation,
                onFirstFix,
                mapViewController as GoogleMapsController,
              );
            },
            onCameraMove: onCameraMove ?? (_) {},
            onCameraMoveStart: onCameraMoveStart ?? () {},
            onCameraIdle: onCameraIdle ?? (_) {},
            initialCenter: initialCenter,
            initialZoom: googleZoomLevelMap[initialZoom]!,
            preventPanning: preventPanning,
            darkModeStylesAssetFile: googleDarkModeStyleFile,
            lightModeStylesAssetFile: googleLightModeStyleFile,
          ),
        );

        break;
      case MapProvider.hereMaps:
        _mapInstance = const BlankMapView();
        mapViewController = BlankMapViewController();
        break;
      case MapProvider.noMaps:
        _mapInstance = const BlankMapView();
        mapViewController = BlankMapViewController();
        break;
    }

    if (_mapInstance == null) {
      return MapViewFactoryResult(
        widget: const BlankMapView(),
        controller: BlankMapViewController(),
      );
    } else {
      return MapViewFactoryResult(
        widget: _mapInstance!,
        controller: mapViewController,
      );
    }
  }

  void _googleOnMapCreatedHandler(
    Function(IMapViewController mapViewController) onMapCreated,
    bool showDeviceLocation,
    Function(LatLong? latLong, IMapViewController mapViewController)?
        onFirstFix,
    GoogleMapsController mapViewController,
  ) {
    onMapCreated(mapViewController);
    if (showDeviceLocation) {
      mapViewController.showLocationIndicator(onFirstFix: onFirstFix);
    }
  }
}

class MapViewFactoryResult {
  final Widget widget;
  final IMapViewController controller;

  MapViewFactoryResult({required this.widget, required this.controller});
}

enum ZoomLevel { city, suburb, neighborhood, street }
