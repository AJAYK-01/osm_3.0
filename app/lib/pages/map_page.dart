import 'package:app/models/constants.dart';
import 'package:app/models/models.dart';
import 'package:app/services/places_service.dart';
import 'package:app/widgets/add_place.dart';
import 'package:app/widgets/markers.dart';
import 'package:app/widgets/view_place.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../services/location_service.dart';

class MapPage extends StatefulWidget {
  final MapMode mapMode;
  final LocationService _locationService = LocationService();

  MapPage({super.key, required this.mapMode});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Position currLocation;
  late MapTileLayerController _mapController;
  late MapZoomPanBehavior _mapZoomPanController;

  // Add a list of MapMarker objects for Custom Places
  List<Place> places = [];

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
        loadPlaceMarkers();
        _mapController.updateMarkers([0]);
        // widget._mapZoomPanController.focalLatLng =
        //     MapLatLng(currLocation.latitude, currLocation.longitude);
      }
    });

    super.initState();
  }

  void loadPlaceMarkers() async {
    // Add a list of Place objects
    places = await PlacesService.loadPlaces(
        currLocation.latitude, currLocation.longitude);

    // places = await PlacesService.loadPlaces(12.202001, 12.220080);

    // Add the markers to the map
    for (int i = 0; i < places.length; i++) {
      _mapController.insertMarker(i + 1);
    }
  }

  void movePoint(point) {
    setState(() {
      _mapZoomPanController.focalLatLng = point;
    });
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

                  if (widget.mapMode == MapMode.contribute) {
                    // movePoint(currlatLng);
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AddPlace(
                          latitude: currlatLng.latitude,
                          longitude: currlatLng.longitude,
                        );
                      },
                    );
                  }
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
                        if (index == 0) {
                          // The first marker is the current location marker
                          return CurrentLocationMarker(
                            latitude: currLocation.latitude,
                            longitude: currLocation.longitude,
                          );
                        } else if (places.length > index - 1) {
                          // The other markers are the custom places markers
                          return PlacesMarker(
                            place: places[index - 1],
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return ViewPlace(place: places[index - 1]);
                                },
                              );
                            },
                          );
                        } else {
                          return const EmptyMarker();
                        }
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
