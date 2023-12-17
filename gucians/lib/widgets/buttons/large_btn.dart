import 'package:flutter/material.dart';
import 'package:gucians/theme/colors.dart';
import 'package:gucians/theme/sizes.dart';

class LargeBtn extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String text;
  final Color? color;
  const LargeBtn(
      {super.key, required this.onPressed, required this.text, this.color});

  @override
  State<LargeBtn> createState() => _LargeBtnState();
}

class _LargeBtnState extends State<LargeBtn> {
  bool _isButtonDisabled = false;

  void onPressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    await widget.onPressed!();

    if (context.mounted) {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50.0),
            textStyle: TextStyle(fontSize: Sizes.medium),
            backgroundColor: widget.color ?? AppColors.confirm),
        onPressed:
            _isButtonDisabled || (widget.onPressed == null) ? null : onPressed,
        child: Text(
          _isButtonDisabled ? 'Loading...' : widget.text,
        ));
  }
}
