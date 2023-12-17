import 'package:flutter/material.dart';
import 'package:gucians/controllers/notification_controller.dart';
import 'package:gucians/models/notification_model.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/widgets/cards/notification_card.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController _notificationController =
      NotificationController();

  List<NotificationDisplay>? _notifications;

  Future<void> _getData() async {
    List<NotificationDisplay> notifications =
        await _notificationController.getMyNotifications();

    setState(() {
      _notifications = notifications;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: _notifications == null
                ? const CircularProgressIndicator()
                : _notifications!.isEmpty
                    ? const Image(
                        image: AssetImage('assets/images/no_data.png'))
                    : RefreshIndicator(
                        onRefresh: _getData,
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) =>
                              NotificationCard(
                                  displayNotification: _notifications![index]),
                          itemCount: _notifications!.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: AppColors.unselected,
                          ),
                        ),
                      )));
  }
}
