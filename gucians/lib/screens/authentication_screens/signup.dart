import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:gucians/common/constants.dart";
import "package:gucians/common/error_messages.dart";
import "package:gucians/services/authentication_service.dart";
import "package:gucians/theme/colors.dart";
import "package:gucians/theme/sizes.dart";
import "package:gucians/widgets/buttons/auth_button.dart";

class Signup extends StatefulWidget {
  final Function toggleView;
  const Signup({super.key, required this.toggleView});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService _auth = AuthService();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final controllerName = TextEditingController();
  final controllerHandle = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String error = '';

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.signup(controllerEmail.text.trim(),
          controllerPassword.text, controllerName.text, controllerHandle.text);
      if (result != null) {
        setState(() => error = result);
      }
    }
  }

  bool isValidMail(String email) {
    try {
      String emailSecondHalf = email.split('@')[1];
      return emailSecondHalf == studentEmailSecondHalf ||
          emailSecondHalf == staffEmailSecondHalf;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerName.dispose();
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
                const SizedBox(height: 70.0),
                const Text(
                  'Gucians',
                  style: TextStyle(fontSize: 56),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email', errorMaxLines: 3),
                  validator: (val) =>
                      !isValidMail(val!) ? ErrorMessages.email : null,
                  controller: controllerEmail,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Handle', errorMaxLines: 3),
                  validator: (val) =>
                      val!.isEmpty ? ErrorMessages.required : null,
                  controller: controllerHandle,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Name', errorMaxLines: 3),
                  validator: (val) =>
                      val!.isEmpty ? ErrorMessages.required : null,
                  controller: controllerName,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', errorMaxLines: 3),
                  validator: (val) =>
                      val!.length < 6 ? ErrorMessages.password : null,
                  controller: controllerPassword,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirm password', errorMaxLines: 3),
                  validator: (val) => val != controllerPassword.text
                      ? ErrorMessages.confirmPassword
                      : null,
                  controller: controllerConfirmPassword,
                ),
                const SizedBox(height: 40.0),
                AuthBtn(onPressed: signup, text: 'Sign up'),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style:
                      TextStyle(color: AppColors.error, fontSize: Sizes.xsmall),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                RichText(
                    text: TextSpan(
                  text: "Have an account? ",
                  children: [
                    TextSpan(
                      text: 'Log in',
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
