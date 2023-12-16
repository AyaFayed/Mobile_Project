import 'package:flutter/material.dart';
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
    PostsByCategory(category: 'news'),
    PostsByCategory(category: 'question'),
    PostsByCategory(category: 'confession'),
    Notifications()
  ];
  final myTitles=['News','Academic Questions','Confessions','Notifications'];
  var selectedTabIdx = 1;
  void SwitchTab(int idx) {
    setState(() {
      selectedTabIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title:  Text(myTitles[selectedTabIdx]),
      ),
      body: myPages[selectedTabIdx],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_rounded), label: "News"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: "Questions"),
              BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: "Confessions"),
              BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: "Notifications"),
        ],
        currentIndex: selectedTabIdx,
        onTap: SwitchTab,
      ),
    );
  }
}
