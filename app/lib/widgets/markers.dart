import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CurrentLocationMarker extends MapMarker {
  const CurrentLocationMarker(
      {super.key, required super.latitude, required super.longitude})
      : super(
          size: const Size(12, 12),
          iconColor: Colors.blue,
          iconStrokeColor: Colors.deepPurple,
          iconStrokeWidth: 4.0,
        );
}

class PlacesMarker extends MapMarker {
  final Place place;
  final void Function() onTap;

  PlacesMarker({
    super.key,
    required this.place,
    required this.onTap,
  }) : super(
          latitude: place.latitude,
          longitude: place.longitude,
          child: GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.location_on,
              size: 28,
              color: Colors.deepOrange,
            ),
          ),
        );
}

class EmptyMarker extends MapMarker {
  const EmptyMarker({super.key})
      : super(
            size: const Size(0, 0),
            iconColor: Colors.transparent,
            iconStrokeColor: Colors.transparent,
            iconStrokeWidth: 0.0,
            latitude: 0.0,
            longitude: 0.0);
}
