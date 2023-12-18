import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/user_model.dart';

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

  Future<UserModel?> getUser(String userId) async {
    try {
      final userIdData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.users, userId);
      if (userIdData != null) {
        UserModel user = UserModel.fromJson(userIdData);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
