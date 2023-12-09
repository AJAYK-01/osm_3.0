import 'package:app/models/models.dart';
import 'package:app/services/graphql_service.dart';
import 'package:app/services/places_service.dart';
import 'package:flutter/material.dart';

class SearchPlaces extends StatefulWidget {
  final Function(Place) onItemSelected;

  const SearchPlaces({super.key, required this.onItemSelected});

  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  final TextEditingController _controller = TextEditingController();
  List<Place> _filteredItems = [];
  final GraphqlService gql = GraphqlService();
  bool searching = false;

  void _search(String query) async {
    var place = await PlacesService.searchPlace(query);
    setState(() {
      _filteredItems = place;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _search(value);
            },
          ),
        ),
        Expanded(
          child: _controller.text.isNotEmpty && _filteredItems.isNotEmpty
              ? ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(_filteredItems[index].placeName),
                        onTap: () {
                          // Call the onItemSelected callback with the selected item
                          widget.onItemSelected(_filteredItems[index]);
                          // Clear the search results and close the keyboard
                          setState(() {
                            _filteredItems = [];
                            _controller.clear();
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    );
                  },
                )
              : Container(), // Empty container when no search is going on
        ),
      ],
    );
  }
}
