import 'package:flutter/material.dart';
import 'package:gucians/common/error_messages.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:gucians/widgets/buttons/large_icon_btn.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controllerEmail = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.resetPassword(controllerEmail.text.trim());
      if (context.mounted) {
        if (result == null) {
          controllerEmail.clear();
          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.success,
          //   confirmBtnColor: AppColors.confirm,
          //   text: Confirmations.resetPasswordEmail,
          // );
        } else {
          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.error,
          //   confirmBtnColor: AppColors.confirm,
          //   text: result,
          // );
        }
      }
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Reset password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 150.0),
                    Text(
                      'Receive an email to reset your password',
                      style: TextStyle(fontSize: Sizes.medium),
                    ),
                    const SizedBox(height: 28.0),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          errorMaxLines: 3),
                      validator: (val) =>
                          val!.isEmpty ? ErrorMessages.required : null,
                      controller: controllerEmail,
                    ),
                    const SizedBox(height: 40.0),
                    LargeIconBtn(
                        onPressed: () => resetPassword(),
                        text: 'Reset password',
                        icon: Icon(Icons.email, size: Sizes.medium)),
                  ],
                ),
              )),
        ));
  }
}
