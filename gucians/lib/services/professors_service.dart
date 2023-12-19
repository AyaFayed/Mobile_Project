import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/user_model.dart';

Future<List<UserModel>> getStaffUsers() async {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  QuerySnapshot users =
      await usersCollection.where('type', isEqualTo: "staff").get();
  List<UserModel> allUsers = [];
  if (users.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in users.docs) {
      Map<String, dynamic> user = document.data() as Map<String, dynamic>;
      // user['id'] = document.id;
      UserModel userData = UserModel.fromJson(user);
      allUsers.add(userData);
    }
  }
  return allUsers;
}

Future<List<UserModel>> getAllUsers() async {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  QuerySnapshot users =
      await usersCollection.get();
  List<UserModel> allUsers = [];
  if (users.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in users.docs) {
      Map<String, dynamic> user = document.data() as Map<String, dynamic>;
      UserModel userData = UserModel.fromJson(user);
      allUsers.add(userData);
    }
  }
  return allUsers;
}



