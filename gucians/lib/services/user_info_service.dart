import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

   String getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid; // This is the ID of the currently logged-in user
    }
    //for testing...
    return 'OZ0B6Owm05aVaYjEBynWHqJRYkf1';
  }

   Future<String> getUserAttribute(String att) async {
    String id = getCurrentUserId();
    final firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(id).get();
    if (snapshot.exists) {
      String x = snapshot.data()![att] ?? '';
      return x;
    } else {
      return att;
    }
  }

