import 'package:app/models/models.dart';
import 'package:flutter/material.dart';

class ViewPlace extends StatelessWidget {
  final Place place;

  const ViewPlace({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latitude: ${place.latitude}, Longitude: ${place.longitude}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${place.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Description: ${place.description}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: place.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(place.images[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
