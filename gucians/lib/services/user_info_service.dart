import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucians/models/user_model.dart';

class UserInfoService {
  static String getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid; // This is the ID of the currently logged-in user
    }
    //for testing...
    return 'AJndJPDfP0bp86BVR3Nr';
  }

  static Future<String> getUserType() async {
    String id = getCurrentUserId();
    final firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(id).get();
    if (snapshot.exists) {
      return snapshot.data()!['type'];
    } else {
      return 'type';
    }
  }
}
