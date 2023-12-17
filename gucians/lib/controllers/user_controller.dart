import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/common/helper.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/database/reads/user_reads.dart';
import 'package:gucians/models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserReads _userReads = UserReads();

  Future createUser(
      String? uid, String name, String email, String handle) async {
    final docUser = DatabaseReferences.users.doc(uid);

    UserModel user = UserModel(
        id: docUser.id,
        name: name,
        email: email,
        handle: handle,
        photoUrl: null,
        isStaff: isStaff(email),
        roomLocationId: null,
        ratingIds: [],
        tokens: [],
        allowNewsNotifications: true,
        allowLostAndFoundNotifications: true,
        userNotifications: []);

    final json = user.toJson();
    await docUser.set(json);
  }

  Future<UserModel?> getCurrentUser() async {
    if (_auth.currentUser == null) return null;
    UserModel? user = await _userReads.getUser(_auth.currentUser?.uid ?? '');
    return user;
  }
}
