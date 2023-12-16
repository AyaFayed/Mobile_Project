import 'package:flutter/material.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/widgets/buttons/auth_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: AuthBtn(
            onPressed: () async => await _auth.logout(), text: 'log out'));
  }
}
