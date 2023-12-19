import 'package:firebase_auth/firebase_auth.dart';
import 'package:gucians/common/enums/notification_type_enum.dart';
import 'package:gucians/controllers/user_controller.dart';
import 'package:gucians/database/database_references.dart';
import 'package:gucians/database/reads/notification_reads.dart';
import 'package:gucians/database/reads/user_reads.dart';
import 'package:gucians/database/writes/user_writes.dart';
import 'package:gucians/models/notification_model.dart';
import 'package:gucians/models/user_model.dart';

class NotificationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();
  final UserReads _userReads = UserReads();
  final UserWrites _userWrites = UserWrites();
  final NotificationReads _notificationReads = NotificationReads();

  Future createNotification(List<String> userIds, String title, String body,
      String postId, NotificationType notificationType) async {
    final docNotification = DatabaseReferences.notifications.doc();

    final notification = NotificationModel(
        id: docNotification.id,
        title: title,
        body: body,
        createdAt: DateTime.now(),
        postId: postId,
        notificationType: notificationType);

    final json = notification.toJson();

    await docNotification.set(json);

    UserNotification userNotification =
        UserNotification(id: docNotification.id, seen: false);

    List<Future> updates = [];

    for (String userId in userIds) {
      if (userId != _auth.currentUser?.uid) {
        UserModel? user = await _userReads.getUser(userId);
        if (user != null) {
          updates
              .add(_userWrites.addNotificationToUser(userId, userNotification));
        }
      }
    }

    await _user.notifyUsers(userIds, title, body);
    await Future.wait(updates);
  }

  Future createNotificationForAsingleUser(String userId, String title,
      String body, String postId, NotificationType notificationType) async {
    await createNotification([userId], title, body, postId, notificationType);
  }


 Future createNotificationForListOfUsers(List<String> userIds, String title,
      String body, String postId, NotificationType notificationType) async {
        for (var id in userIds) {
          await createNotification([id], title, body, postId, notificationType);
        }
  }


  Future createLostAndFoundNotification(String title, String body,
      String postId, NotificationType notificationType) async {
    List<UserModel> users =
        await _userReads.getAllUsersWithAllowedLostAndFoundNotification();
    await createNotification(users.map((user) => user.id).toList(), title, body,
        postId, notificationType);
  }

  Future createNewsNotification(String title, String body, String postId,
      NotificationType notificationType) async {
    List<UserModel> users =
        await _userReads.getAllUsersWithAllowedNewsNotification();
    await createNotification(users.map((user) => user.id).toList(), title, body,
        postId, notificationType);
  }

  Future markNotificationAsSeen(String notificationId) async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      currentUser.userNotifications
          .removeWhere((notification) => notification.id == notificationId);
      currentUser.userNotifications
          .add(UserNotification(id: notificationId, seen: true));

      await _userWrites.markNotificationAsSeen(
          currentUser.id, currentUser.userNotifications);
    }
  }

  Future<List<NotificationDisplay>> getMyNotifications() async {
    UserModel? currentUser = await _user.getCurrentUser();
    if (currentUser != null) {
      List<NotificationDisplay> notifications =
          await _notificationReads.getNotificationListFromUserNotifications(
              currentUser.userNotifications);

      notifications.sort(((NotificationDisplay a, NotificationDisplay b) =>
          b.notification.createdAt.compareTo(a.notification.createdAt)));

      return notifications;
    }
    return [];
  }
}
