import 'package:flutter/material.dart';
import 'package:gucians/common/constants.dart';
import 'package:gucians/screens/news.dart';
import 'package:gucians/theme/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: CustomTheme.lightTheme,
      home: const Scaffold(
        body: news()
        // Center(
        //   child: Text('Hello World!'),
        // ),
      ),
    );
  }
}
