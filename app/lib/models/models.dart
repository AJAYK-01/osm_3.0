class PlaceMetadata {
  final String name, description;
  final double latitude, longitude;
  final List<String> images;

  PlaceMetadata({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    // for places that don't have images, keep empty
    List<String>? images,
  }) : images = images ?? [];
}

class Place {
  final String id, placeName, placeCid;
  final double latitude, longitude;

  Place({
    required this.id,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.placeCid,
  });
}
