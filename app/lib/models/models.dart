class Place {
  final String name, description;
  final double latitude, longitude;
  final List<String> images;

  Place({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
    // for places that don't have images, keep empty
    List<String>? images,
  }) : images = images ?? [];
}
