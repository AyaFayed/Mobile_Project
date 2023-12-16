import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gucians/common/constants.dart';
import 'package:gucians/screens/buttom_taps_controller_screen.dart';
import 'package:gucians/theme/themes.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: 
    DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: CustomTheme.lightTheme,
      home:  ButtomTabsControllerScreen()
        // Center(
        //   child: Text('Hello World!'),
        // ),
      
    );
  }
}
