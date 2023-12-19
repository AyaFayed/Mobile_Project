import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/models/location_model.dart';
// import 'package:gucians/database/database_references.dart';

Future<List<Location>> getLocations() async {
  CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');
  QuerySnapshot locations = await locationsCollection.get();
  List<Location> allLocations = [];
  if (locations.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in locations.docs) {
      Location location =
          Location.fromJson(document.data() as Map<String, dynamic>,document.id);
      allLocations.add(location);
    }
  }
  return allLocations;
}
