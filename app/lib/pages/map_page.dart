import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                initialMarkersCount: 1,
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                initialZoomLevel: 15,
                initialFocalLatLng: const MapLatLng(12.203000, 12.220080),
                controller: _mapController,
                markerBuilder: (BuildContext context, int index) {
                  return const MapMarker(
                      latitude: 12.220080, longitude: 12203000);
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
  }
}
