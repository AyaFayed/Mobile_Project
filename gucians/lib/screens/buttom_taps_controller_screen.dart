import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucians/screens/main_drawer.dart';
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
  void SwitchTab(int idx) {
    setState(() {
      selectedTabIdx = idx;
    });
  }

  bool showAddBtn() {
    switch (selectedTabIdx) {
      case 0:
        if (UserInfoService.getUserAttribute('type') == 'club') {
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
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final x =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (x['selectedIdx'] != null) {
        selectedTabIdx = x['selectedIdx']!;
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(myTitles[selectedTabIdx]),
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
                icon: Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: true,
      body: myPages[selectedTabIdx],
      bottomNavigationBar: BottomNavigationBar(
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
