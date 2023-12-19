import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gucians/screens/buttom_taps_controller_screen.dart';
import 'package:gucians/screens/home.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:gucians/widgets/buttons/large_icon_btn.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final AuthService _auth = AuthService();

  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    await _auth.sendVerificationEmail();

    setState(() {
      canResendEmail = false;
    });

    await Future.delayed(const Duration(seconds: 30));

    setState(() {
      canResendEmail = true;
    });
  }

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ?  ButtomTabsControllerScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              'Verify Email',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.light),
            ),
            backgroundColor: AppColors.primary,
          ),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A verification email has been sent to your email.',
                    style: TextStyle(
                      fontSize: Sizes.medium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  LargeIconBtn(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      text: 'Resend email',
                      icon: Icon(Icons.email, size: Sizes.medium)),
                  TextButton.icon(
                      icon: Icon(
                        Icons.arrow_back,
                        size: Sizes.medium,
                      ),
                      onPressed: () => _auth.logout(),
                      label: Text(
                        'Back',
                        style: TextStyle(fontSize: Sizes.medium),
                      ))
                ],
              )),
        );
}
