import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  final GraphQLClient _client;

  GraphqlService()
      : _client = GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink(
              'https://api.studio.thegraph.com/query/60409/places-manager/version/latest'),
        );

  Future<QueryResult> getPlaces() {
    const String getPlacesQuery = r'''
      query {
        placeApproveds {
          id
          place_name
          latitude
          longitude
          placeCid
        }
      }
    ''';

    return _client.query(
      QueryOptions(
        document: gql(getPlacesQuery),
      ),
    );
  }

  Future<QueryResult> getPlacesNear(double latitude, double longitude) {
    int microLatitude = (latitude * 1e6).round();
    int microLongitude = (longitude * 1e6).round();

    String getPlacesNearQuery = '''
      query {
        placeApproveds(
          where: {
            latitude_gte: ${microLatitude - 2000},
            latitude_lte: ${microLatitude + 2000},
            longitude_gte: ${microLongitude - 20000},
            longitude_lte: ${microLongitude + 20000}
          }
        ) {
          id
          place_name
          latitude
          longitude
          placeCid
        }
      }
    ''';

    return _client.query(
      QueryOptions(
        document: gql(getPlacesNearQuery),
      ),
    );
  }

  Future<QueryResult> getPlaceSearch(String name) {
    String getPlaceSearchQuery = '''
      query {
          placeApproveds(where: {place_name_contains_nocase: "$name"}) {
            id
            place_name
            latitude
            longitude
            placeCid
        }
      }
    ''';

    return _client.query(
      QueryOptions(
        document: gql(getPlaceSearchQuery),
      ),
    );
  }
}
