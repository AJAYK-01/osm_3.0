import 'package:app/models/models.dart';
import 'package:app/services/ipfs_service.dart';
import 'package:flutter/material.dart';

class ViewPlace extends StatelessWidget {
  final Place place;

  const ViewPlace({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IpfsService.fetchPlaceMetadata(place.placeCid),
      builder: (_, placeSnapshot) {
        if (placeSnapshot.hasData) {
          var placeData = placeSnapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latitude: ${placeData.latitude}, Longitude: ${placeData.longitude}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Name: ${placeData.name}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description: ${placeData.description}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: placeData.images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                              'https://gateway.lighthouse.storage/ipfs/${placeData.images[index]}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
