import 'package:flutter/material.dart';
import "package:flutter/gestures.dart";
import 'package:gucians/common/error_messages.dart';
import 'package:gucians/screens/authentication_screens/forgot_password.dart';
import 'package:gucians/services/authentication_service.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';
import 'package:gucians/widgets/buttons/auth_button.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({super.key, required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  String error = '';

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.login(
          controllerEmail.text.trim(), controllerPassword.text);
      if (result != null) {
        setState(() => error = result);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      showPassword = false;
    });
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 140.0),
                const Text(
                  'Gucians',
                  style: TextStyle(fontSize: 56),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email', errorMaxLines: 3),
                  validator: (val) =>
                      val!.isEmpty ? ErrorMessages.required : null,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      errorMaxLines: 3,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColors.unselected,
                          ))),
                  validator: (val) =>
                      val!.isEmpty ? ErrorMessages.required : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 24.0),
                Row(children: [
                  const Spacer(),
                  GestureDetector(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: Sizes.xsmall,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword())),
                  ),
                ]),
                const SizedBox(height: 32.0),
                AuthBtn(onPressed: login, text: 'Log in'),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style:
                      TextStyle(color: AppColors.error, fontSize: Sizes.xsmall),
                ),
                const SizedBox(height: 25.0),
                RichText(
                    text: TextSpan(
                  text: "No account? ",
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.toggleView();
                        },
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: Sizes.small),
                )),
              ],
            ),
          )),
    ));
  }
}
