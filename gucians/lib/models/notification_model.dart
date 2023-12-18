import 'package:gucians/common/enums/notification_type_enum.dart';

class NotificationModel {
  String id;
  String title;
  String body;
  DateTime createdAt;
  String postId;
  NotificationType notificationType;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.postId,
    required this.notificationType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'postId': postId,
        'notificationType': notificationType.name
      };

  static NotificationModel fromJson(
          Map<String, dynamic> json) =>
      NotificationModel(
          id: json['id'],
          title: json['title'],
          body: json['body'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
          postId: json['postId'],
          notificationType:
              getNotificationTypeFromString(json['notificationType']));
}

class NotificationDisplay {
  NotificationModel notification;
  bool seen;

  NotificationDisplay({
    required this.notification,
    required this.seen,
  });
}
