import 'package:flutter/material.dart';
import 'package:gucians/controllers/notification_controller.dart';
import 'package:gucians/models/notification_model.dart';
import 'package:gucians/theme/sizes.dart';

class NotificationCard extends StatefulWidget {
  final NotificationDisplay displayNotification;

  const NotificationCard({super.key, required this.displayNotification});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final NotificationController _notificationController =
      NotificationController();

  @override
  Future<void> deactivate() async {
    await _notificationController
        .markNotificationAsSeen(widget.displayNotification.notification.id);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.displayNotification.notification.title,
        style: TextStyle(
          fontSize: Sizes.small,
          fontWeight: widget.displayNotification.seen
              ? FontWeight.normal
              : FontWeight.bold,
        ),
      ),
      subtitle: Text(widget.displayNotification.notification.body),
    );
  }
}
