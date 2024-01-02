import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucians/screens/main_drawer.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/services/messaging_service.dart';
import 'package:gucians/services/notification_service.dart';
import 'package:gucians/services/user_info_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/widgets/posts_by_category.dart';
import 'package:gucians/screens/notifications.dart';

class ButtomTabsControllerScreen extends StatefulWidget {
  @override
  State<ButtomTabsControllerScreen> createState() =>
      _ButtomTabsControllerScreenState();
}

class _ButtomTabsControllerScreenState
    extends State<ButtomTabsControllerScreen> {
  final AuthService _auth = AuthService();
  final MessagingService _messaging = MessagingService();
  final NotificationService _notificationService = NotificationService();
  bool isClub = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messaging.requestPermission();
    _messaging.setToken();
    _notificationService.initInfo();
    getUserAttribute('type').then((value) {
      print(value);
      isClub = (value == 'club');
    }).catchError((err) {
      print("//////////////////////////////////////////////////" +
          err.toString());
    });
  }

  final myPages = [
    const PostsByCategory(category: 'news'),
    const PostsByCategory(category: 'question'),
    const PostsByCategory(category: 'confession'),
    const Notifications()
  ];
  final myTitles = [
    'News',
    'Academic Questions',
    'Confessions',
    'Notifications'
  ];
  var selectedTabIdx = 1;
  bool done = false;
  void SwitchTab(int idx) {
    setState(() {
      selectedTabIdx = idx;
    });
  }

  bool showAddBtn() {
    switch (selectedTabIdx) {
      case 0:
        if (isClub) {
          return true;
        }
        break;
      case 1:
        return true;
      case 2:
        return true;
      case 3:
        return false;
      default:
        return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null && !done) {
      final x =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      done = true;
      if (x['selectedIdx'] != null) {
        selectedTabIdx = x['selectedIdx']!;
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.light,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          myTitles[selectedTabIdx],
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.light),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          if (showAddBtn())
            IconButton(
                onPressed: () {
                  switch (selectedTabIdx) {
                    case 2:
                      Navigator.of(context).pushNamed('/add_confession');
                      break;
                    case 0:
                      Navigator.of(context).pushNamed('/add_post',
                          arguments: {'category': 'news'});
                      break;
                    case 1:
                      Navigator.of(context).pushNamed('/add_post',
                          arguments: {'category': 'question'});
                      break;

                    default:
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: AppColors.light,
                ))
        ],
      ),
      floatingActionButton: showAddBtn()
          ? FloatingActionButton(
              onPressed: () {
                switch (selectedTabIdx) {
                  case 2:
                    Navigator.of(context).pushNamed('/add_confession');
                    break;
                  case 0:
                    Navigator.of(context).pushNamed('/add_post',
                        arguments: {'category': 'news'});
                    break;
                  case 1:
                    Navigator.of(context).pushNamed('/add_post',
                        arguments: {'category': 'question'});
                    break;

                  default:
                }
              },
              tooltip: 'Add Rating',
              child: const Icon(Icons.add),
            )
          : null,
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: true,
      body: myPages[selectedTabIdx],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        // selectedLabelStyle: TextStyle(color: Colors.black),
        // unselectedLabelStyle: TextStyle(color: Colors.black),
        // unselectedLabelStyle: ,
        // backgroundColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'lib/icons/news_rounded.png',
                height: 40,
              ),
              label: "News"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'lib/icons/asking.png',
                height: 40,
              ),
              label: "Questions"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'lib/icons/whisper.png',
                height: 60,
              ),
              label: "Confessions"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'lib/icons/bell.png',
                height: 70,
              ),
              label: "Notifications"),
        ],
        currentIndex: selectedTabIdx,
        onTap: SwitchTab,
      ),
    );
  }
}
