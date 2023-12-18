import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/common/helper.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/database/reads/user_reads.dart';
import 'package:gucians/database/writes/user_writes.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/messaging_service.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserReads _userReads = UserReads();
  final UserWrites _userWrites = UserWrites();
  final MessagingService _messaging = MessagingService();

  Future createUser(
      String? uid, String name, String email, String handle) async {
    final docUser = DatabaseReferences.users.doc(uid);

    String? token = await _messaging.getToken();

    UserModel user = UserModel(
        id: docUser.id,
        name: name,
        email: email,
        handle: handle,
        photoUrl: null,
        type: isStaff(email) ? 'staff' : 'student',
        roomLocationId: null,
        ratings: {},
        tokens: token != null ? [token] : [],
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

  Future notifyUser(String uid, String title, String body) async {
    if (uid == _auth.currentUser?.uid) return;

    UserModel? user = await _userReads.getUser(uid);

    if (user != null) {
      List<Future> notifying = [];
      for (String token in user.tokens) {
        notifying.add(_messaging.sendPushNotification(token, body, title));
      }
      await Future.wait(notifying);
    }
  }

  Future notifyUsers(List<String> uids, String title, String body) async {
    List<Future> notifying = [];
    for (String uid in uids) {
      if (uid != _auth.currentUser?.uid) {
        notifying.add(notifyUser(uid, title, body));
      }
    }
    await Future.wait(notifying);
  }

  Future updateAllowNewsNotifications(bool value) async {
    if (_auth.currentUser == null) return;
    await _userWrites.updateAllowNewsNotifications(
        _auth.currentUser?.uid ?? '', value);
  }

  Future updateAllowLostAndFoundNotifications(bool value) async {
    if (_auth.currentUser == null) return;
    await _userWrites.updateAllowLostAndFoundNotifications(
        _auth.currentUser?.uid ?? '', value);
  }

  Future<int> getNotificationsCount() async {
    UserModel? currentUser = await getCurrentUser();
    int count = 0;
    if (currentUser != null) {
      for (UserNotification userNotification in currentUser.userNotifications) {
        if (!userNotification.seen) {
          count++;
        }
      }
    }
    return count;
  }
}
