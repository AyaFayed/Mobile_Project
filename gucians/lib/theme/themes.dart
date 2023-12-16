import 'package:flutter/material.dart';
import 'package:gucians/theme/colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.primary,
            onPrimary: Colors.white,
            secondary: AppColors.secondary,
            onSecondary: Colors.white,
            error: AppColors.error,
            onError: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: AppColors.darkGrey,
            onSurface: Colors.black));
  }
}
