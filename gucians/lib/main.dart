import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gucians/common/constants.dart';

import 'package:gucians/screens/buttom_taps_controller_screen.dart';
import 'package:gucians/screens/emergency_screens/emergencyScreen.dart';
import 'package:gucians/screens/locations_sccreens/locations_screen.dart';
import 'package:gucians/screens/lost_and_found.dart';
import 'package:gucians/screens/post_screens/add_confession.dart';
import 'package:gucians/screens/post_screens/add_post.dart';
import 'package:gucians/screens/professors_screens/search_professors.dart';
import 'package:gucians/theme/themes.dart';
import 'firebase_options.dart';

import 'package:gucians/screens/authentication_screens/authenticate.dart';
import 'package:gucians/screens/wrapper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: CustomTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/':(context) => ButtomTabsControllerScreen(),
        '/locations':(context) => const LocationsScreen(),
        '/lost_and_found':(context) => const LostAndFound(),
        '/prof_rating':(context) => const ProfessorRatingList(),
        '/add_confession':(context) => const AddConfession(),
        '/emergency':(context) => const EmergencyScreen(),
        '/add_post':(context) => const AddPost(),

      }
      
    );
  }
}
