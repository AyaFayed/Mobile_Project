import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/database/database_references.dart';

class UserReads {
  final CollectionReference<Map<String, dynamic>> _users =
      DatabaseReferences.users;

  Future<bool> handleAlreadyExist(String handle) async {
    try {
      QuerySnapshot querySnapshot =
          await _users.where('handle', isEqualTo: handle).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
