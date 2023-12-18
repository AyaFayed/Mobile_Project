import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/user_model.dart';

Future<List<UserModel>> getStaffUsers() async {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('user');
  QuerySnapshot users =
      await usersCollection.where('type', isEqualTo: "staff").get();
  List<UserModel> allUsers = [];
  if (users.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in users.docs) {
      Map<String, dynamic> user = document.data() as Map<String, dynamic>;
      // user['id'] = document.id;
      UserModel userData = UserModel.fromJson(user,document.id);
      allUsers.add(userData);
    }
  }
  return allUsers;
}

// Future<UserModel?> getStaffProfile(String id) async {
//   DocumentReference userDocRef = FirebaseFirestore.instance.collection('user').doc(id);
//   DocumentSnapshot userDoc = await userDocRef.get();
//   if (userDoc.exists) {
//     Map<String, dynamic> user = userDoc.data() as Map<String, dynamic>;
//     user['id'] = id;
//     return UserModel.fromJson(user);
//   } else {
//     return null;
//   }
// }


