import 'package:gucians/database/database_references.dart';
import 'package:gucians/models/notification_model.dart';
import 'package:gucians/models/user_model.dart';

class NotificationReads {
  Future<NotificationModel?> getNotification(String notificationId) async {
    try {
      final notificationData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.notifications, notificationId);
      if (notificationData != null) {
        NotificationModel notification =
            NotificationModel.fromJson(notificationData);
        return notification;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<NotificationDisplay?> getDisplayNotification(
      UserNotification userNotification) async {
    try {
      final notificationData = await DatabaseReferences.getDocumentData(
          DatabaseReferences.notifications, userNotification.id);

      if (notificationData != null) {
        NotificationModel notification =
            NotificationModel.fromJson(notificationData);
        NotificationDisplay notificationDisplay = NotificationDisplay(
            notification: notification, seen: userNotification.seen);
        return notificationDisplay;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<NotificationDisplay>> getNotificationListFromUserNotifications(
      List<UserNotification> userNotifications) async {
    try {
      List<NotificationDisplay?> notificationsNull = await Future.wait(
          userNotifications.map((UserNotification userNotification) {
        return getDisplayNotification(userNotification);
      }));

      List<NotificationDisplay> notifications = [];
      for (NotificationDisplay? notification in notificationsNull) {
        if (notification != null) {
          notifications.add(notification);
        }
      }
      return notifications;
    } catch (e) {
      return [];
    }
  }
}
