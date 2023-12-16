import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/common/helper.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        ratingIds: []);

    final json = user.toJson();
    await docUser.set(json);
  }
}
