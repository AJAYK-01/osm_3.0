import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  final LocationService _locationService = LocationService();

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Position currLocation;
  late MapTileLayerController _mapController;
  late MapZoomPanBehavior _mapZoomPanController;

  @override
  void initState() {
    _mapController = MapTileLayerController();
    _mapZoomPanController = MapZoomPanBehavior(
      maxZoomLevel: 20,
      enableDoubleTapZooming: true,
      showToolbar: false,
    );

    // just keep track of the location always when available
    var currLocationStream = LocationService();
    currLocationStream.livePosition().listen((Position newPosition) {
      if (currLocation != newPosition) {
        currLocation = newPosition;
        _mapController.updateMarkers([0]);
        // widget._mapZoomPanController.focalLatLng =
        //     MapLatLng(currLocation.latitude, currLocation.longitude);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currLocation = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0);
    return FutureBuilder(
      future: widget._locationService.determinePosition(),
      builder: (_, initLocationSnapshot) {
        if (initLocationSnapshot.hasData) {
          currLocation = initLocationSnapshot.data!;
          return Stack(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final Offset localPosition =
                      box.globalToLocal(details.globalPosition);
                  final MapLatLng currlatLng =
                      _mapController.pixelToLatLng(localPosition);

                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Text(
                        'latitude: ${currlatLng.latitude} longitude: ${currlatLng.longitude}',
                      );
                    },
                  );
                },
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      zoomPanBehavior: _mapZoomPanController,
                      initialMarkersCount: 10,
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      initialZoomLevel: 15,
                      initialFocalLatLng: MapLatLng(
                          initLocationSnapshot.data!.latitude,
                          initLocationSnapshot.data!.longitude),
                      controller: _mapController,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                            latitude: initLocationSnapshot.data!.latitude,
                            longitude: initLocationSnapshot.data!.longitude);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Row(
                  children: [
                    FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        if (_mapZoomPanController.zoomLevel <
                            _mapZoomPanController.maxZoomLevel) {
                          _mapZoomPanController.zoomLevel += 1;
                        }
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.remove),
                      onPressed: () {
                        if (_mapZoomPanController.zoomLevel >
                            _mapZoomPanController.minZoomLevel) {
                          _mapZoomPanController.zoomLevel -= 1;
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return const SizedBox(
            height: 500,
            width: 500,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
