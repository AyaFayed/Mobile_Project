import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/user_model.dart';

class UserWrites {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> _users =
      DatabaseReferences.users;

  Future addNotificationToUser(
      String userId, UserNotification userNotification) async {
    await _users.doc(userId).update({
      'userNotifications': FieldValue.arrayUnion([userNotification.toJson()])
    });
  }

  Future markNotificationAsSeen(
      String userId, List<UserNotification> userNotifications) async {
    await _users.doc(userId).update({
      'userNotifications':
          userNotifications.map((notification) => notification.toJson())
    });
  }

  Future updateAllowNewsNotifications(String userId, bool value) async {
    await _users.doc(userId).update({'allowNewsNotifications': value});
  }

  Future updateAllowLostAndFoundNotifications(String userId, bool value) async {
    await _users.doc(userId).update({'allowLostAndFoundNotifications': value});
  }

  Future updatePhoto(String userId, String value) async {
    await _users.doc(userId).update({'photoUrl': value});
  }

  Future addToken(String token) async {
    if (_auth.currentUser == null) return;
    try {
      await _users.doc(_auth.currentUser?.uid ?? '').update({
        'tokens': FieldValue.arrayUnion([token])
      });
    } catch (e) {
      // print(e);
    }
  }

  Future removeToken(String token) async {
    if (_auth.currentUser == null) return;
    try {
      await _users.doc(_auth.currentUser?.uid ?? '').update({
        'tokens': FieldValue.arrayRemove([token])
      });
    } catch (e) {
      // print(e);
    }
  }
}
