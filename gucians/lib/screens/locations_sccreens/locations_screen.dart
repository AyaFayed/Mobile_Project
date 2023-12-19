import 'package:flutter/material.dart';
import 'package:gucians/models/location_model.dart';
import 'package:gucians/screens/locations_sccreens/locationCard_screen.dart';
import 'package:gucians/services/locations_service.dart';
import 'package:gucians/theme/colors.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  List<Location> loc = [];
  List<Location> filteredLocations = [];
  String searchValue = "";
  final TextEditingController _searchBar = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    List<Location> tempLoc = await getNums();
    setState(() {
      loc = tempLoc;
      filteredLocations = loc;
      loading = false;
    });
  }

  Future<List<Location>> getNums() async {
    return await getLocations();
  }

  void filterLocationsList(String query) {
    setState(() {
      if (query == "") _searchBar.text = query;
      searchValue = query;
      filteredLocations = loc
          .where((location) =>
              location.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offices & Outlets"),
      ),
      body: Column(
        // children: [
        //   Container(
        //     height: 300,
        //     child: ListView.builder(
        //       itemCount: loc.length,
        //       itemBuilder: (ctx, index) {
        //         return locationCard(location: loc[index]);
        //       },
        //     ),
        //   ),
        // ],
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child: SearchBar(
              controller: _searchBar,
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(Icons.search),
              ),
              hintText: 'Search locations',
              overlayColor: MaterialStateProperty.all(AppColors.lightGrey),
              trailing: [
                if (_searchBar.text.isNotEmpty)
                  TextButton(
                      onPressed: () => filterLocationsList(""),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))
              ],
              onChanged: (String value) {
                filterLocationsList(value);
              },
            ),
          ),
          if (filteredLocations.isNotEmpty)
            Expanded(
                child: ListView.builder(
                    itemCount: filteredLocations.length,
                    itemBuilder: (ctx, index) =>
                        LocationCard(location: filteredLocations[index])))
          else if (filteredLocations.isEmpty && !loading)
            Container(
              margin: const EdgeInsets.only(top: 150),
              child:
                  Center(child: Text("There is no results for $searchValue")),
            )
          else
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
