import 'package:flutter/material.dart';
import 'package:gucians/controllers/user_controller.dart';
import 'package:gucians/models/user_model.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:gucians/widgets/buttons/large_btn.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  final UserController _userController = UserController();
  UserModel? _currentUser;

  Future<void> setNewsNotifications(bool val) async {
    await _userController.updateAllowNewsNotifications(val);
    await _getData();
  }

  Future<void> setLostAndFoundNotifications(bool val) async {
    await _userController.updateAllowLostAndFoundNotifications(val);
    await _getData();
  }

  Future<void> _getData() async {
    UserModel? currentUser = await _userController.getCurrentUser();
    setState(() {
      _currentUser = currentUser;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            'Settings',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppColors.light),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: _currentUser == null
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            title: Text(
                              'Receive club posts notifications',
                              style: TextStyle(fontSize: Sizes.small),
                            ),
                            subtitle: const Text(
                              'When you turn this off, you will not get push notifications when new club posts are added to courses you are enrolled in.',
                            ),
                            value: _currentUser?.allowNewsNotifications ?? true,
                            onChanged: setNewsNotifications),
                        const SizedBox(
                          height: 10,
                        ),
                        SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            title: Text(
                              'Receive lost and found posts notifications',
                              style: TextStyle(fontSize: Sizes.small),
                            ),
                            subtitle: const Text(
                              'When you turn this off, you will not get push notifications when new lost and found posts are added to courses you are enrolled in.',
                            ),
                            value:
                                _currentUser?.allowLostAndFoundNotifications ??
                                    true,
                            onChanged: setLostAndFoundNotifications),
                        const SizedBox(
                          height: 60,
                        ),
                        LargeBtn(
                            color: AppColors.primary,
                            onPressed: () async {
                              await _auth.logout();
                            },
                            text: 'Log out')
                      ],
                    ),
            ),
          ),
        ));
  }
}
