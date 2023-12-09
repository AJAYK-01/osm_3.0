import 'dart:convert';
import 'dart:developer';

import 'package:app/models/models.dart';
import 'package:app/services/graphql_service.dart';
import 'package:app/services/ipfs_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PlacesService {
  List<PlaceMetadata> places = [
    PlaceMetadata(
      latitude: 545217357767546,
      longitude: 76.20325944032045,
      name: 'Place 1',
      description: 'Description for Place 1',
      images: [
        'https://image.cnbcfm.com/api/v1/image/107108131-1661279269174-gettyimages-831412090-20170731-tana9023.jpeg?v=1661279373'
            'https://imageio.forbes.com/specials-images/dam/imageserve/1171238184/960x0.jpg?height=473&width=711&fit=bounds',
      ],
    ),
    PlaceMetadata(
      latitude: 10.535217357767546,
      longitude: 76.20825944032045,
      name: 'Place 2',
      description: 'Description for Place 2',
      images: [
        'https://www.clubmahindra.com/blog/media/section_images/internatio-3c7708bf333b9cd.jpg',
        'https://i.dawn.com/primary/2019/06/5d02a993e2dfa.png'
      ],
    ),
    PlaceMetadata(
      latitude: 10.540217357767546,
      longitude: 76.19825944032045,
      name: 'Place 3',
      description: 'Description for Place 3',
      images: [
        'https://media.odynovotours.com/article/33000/taj-mahal_31251.jpg',
        'https://static.toiimg.com/thumb/msid-88272390,width-748,height-499,resizemode=4,imgsize-60134/.jpg',
        'https://hippie-inheels.com/wp-content/uploads/2018/03/taj-mahal-places-to-visit-in-india-1024x678.jpg'
      ],
    ),
    PlaceMetadata(
      latitude: 10.535217357767546,
      longitude: 76.20325944032045,
      name: 'Place 4',
      description: 'Description for Place 4',
      images: [
        'https://images.thrillophilia.com/image/upload/s--DHQ0RWc8--/c_fill,f_auto,fl_strip_profile,h_775,q_auto,w_1600/v1/images/photos/000/004/262/original/lakshadweep.jpg.jpg?1458192591',
        'https://www.kapilindiatours.com/Citytour/delhi.jpg',
      ],
    ),
    PlaceMetadata(
      latitude: 10.545217357767546,
      longitude: 76.19825944032045,
      name: 'Place 5',
      description: 'Description for Place 5',
      images: [
        'https://thumbor.bigedition.com/bali-one-of-the-best-travel-destinations/52R-IxcOUu8ZKkWFLE0U_HK-pPY=/69x0:1184x836/800x0/filters:quality(80)/granite-web-prod/c5/b4/c5b44ca4133d48f1bdf14e0f47f3cfc4.jpeg'
      ],
    ),
  ];

  static Future<List<Place>> loadPlaces(
      double latitude, double longitude) async {
    final gql = GraphqlService();
    final QueryResult placs = await gql.getPlacesNear(latitude, longitude);
    log("Placss: ${placs.toString()} ");

    if (placs.hasException) {
      log("Error: ${placs.exception.toString()}");
      return [];
    }

    final List<Place> places = (placs.data!['placeApproveds'] as List)
        .map(
          (place) => Place(
            id: place['id'],
            latitude: double.parse(place['latitude']) / 1e6,
            longitude: double.parse(place['longitude']) / 1e6,
            placeName: place['place_name'],
            placeCid: place['placeCid'],
          ),
        )
        .toList();

    return places;
  }

  static Future<List<Place>> searchPlace(String query) async {
    final gql = GraphqlService();
    final QueryResult placs = await gql.getPlaceSearch(query);
    log("Placss: ${placs.toString()} ");

    if (placs.hasException) {
      log("Error: ${placs.exception.toString()}");
      return [];
    }

    final List<Place> places = (placs.data!['placeApproveds'] as List)
        .map(
          (place) => Place(
            id: place['id'],
            latitude: double.parse(place['latitude']) / 1e6,
            longitude: double.parse(place['longitude']) / 1e6,
            placeName: place['place_name'],
            placeCid: place['placeCid'],
          ),
        )
        .toList();

    return places;
  }

  static Future<bool> uploadPlaceToIPFS(PlaceMetadata place) async {
    // Create a map from the Place object
    final Map<String, dynamic> placeMap = {
      'latitude': place.latitude,
      'longitude': place.longitude,
      'name': place.name,
      'description': place.description,
      'images': place.images,
    };

    // Convert the map to a JSON string
    final String placeJson = jsonEncode(placeMap);

    // Convert the JSON string to bytes
    final List<int> placeBytes = utf8.encode(placeJson);

    // Upload the JSON bytes to IPFS
    final result = await IpfsService.uploadBytesToIPFS(placeBytes);
    log("Status Code: ${result.$1}");
    log("CID: ${result.$2}");

    if (result.$1 == 200) {
      return true;
    }
    return false;
  }
}
