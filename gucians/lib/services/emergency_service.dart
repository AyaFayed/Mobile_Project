import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/models/emergency_num.dart';
// import 'package:gucians/database/database_references.dart';

Future<List<EmergencyNum>> getemergencyNums() async {
  CollectionReference emegencyNumbersCollection =
      FirebaseFirestore.instance.collection('emegencyNumbers');
  QuerySnapshot emergencyNums = await emegencyNumbersCollection.get();
  List<EmergencyNum> allemergencyNums = [];
  if (emergencyNums.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in emergencyNums.docs) {
      EmergencyNum emergencyNum =
          EmergencyNum.fromJson(document.data() as Map<String, dynamic>,document.id);
      allemergencyNums.add(emergencyNum);
    }
  }
  return allemergencyNums;
}
