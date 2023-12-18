import 'package:flutter/material.dart';
import 'package:gucians/common/constants.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Container(
            color: AppColors.primary,
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: const Text(''
                // style: TextStyle(color: Colors.white, fontSize: 30),
                )),
        const SizedBox(
          height: 20,
        ),
        Text(appName,style: TextStyle(fontSize: Sizes.xlarge,fontFamily: 'Poppins',letterSpacing: 4),),
        ListTile(
          leading: Image.asset(
            'lib/icons/home.jpg',
            height: 30,
          ),
          title: const Text("Home"),
          onTap: () {
            Navigator.of(context).pushNamed("/");
          },
        ),
        ListTile(
          leading: Image.asset(
            'lib/icons/location.png',
            height: 30,
          ),
          title: const Text("Offices & Outlets"),
          onTap: () {
            Navigator.of(context).pushNamed("/locations");
          },
        ),
        ListTile(
          leading: Image.asset(
            'lib/icons/lost_found.png',
            height: 40,
          ),
          title: const Text("Lost & Found"),
          onTap: () {
            Navigator.of(context).pushNamed("/lost_and_found");
          },
        ),
        ListTile(
          leading: Image.asset(
            'lib/icons/rating.png',
            height: 40,
          ),
          title: const Text("Professor Rating"),
          onTap: () {
            Navigator.of(context).pushNamed("/prof_rating");
          },
        ),
        ListTile(
          leading: Image.asset(
            'lib/icons/emergancy.png',
            height: 40,
          ),
          title: const Text("Emergency Contacts"),
          onTap: () {
            Navigator.of(context).pushNamed("/emergency");
          },
        ),
      ]),
    );
  }
}
