import 'package:flutter/material.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';

class AuthBtn extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;
  const AuthBtn({super.key, required this.onPressed, required this.text});

  @override
  State<AuthBtn> createState() => _AuthBtnState();
}

class _AuthBtnState extends State<AuthBtn> {
  bool _isButtonDisabled = false;

  void onPressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await widget.onPressed();

    if (context.mounted) {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50.0),
            textStyle: TextStyle(fontSize: Sizes.large),
            foregroundColor: AppColors.light,
            backgroundColor: AppColors.primary),
        onPressed: _isButtonDisabled ? null : onPressed,
        child: Text(
          _isButtonDisabled ? 'Loading...' : widget.text,
        ));
  }
}
