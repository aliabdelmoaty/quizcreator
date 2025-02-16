import 'package:flutter/material.dart';
import 'package:quizcreator/theme/theme.dart';
import 'package:quizcreator/utils/constant/colors.dart';

class ButtonApp extends StatelessWidget {
  const ButtonApp({
    super.key,
    this.onPressed,
    required this.text,
  });
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.buttonColor,
        foregroundColor: ColorsApp.primaryText,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
