import 'package:flutter/material.dart';

class AppColors {
  // основной голубой (UI)
  static const medBlue = Color(0xFF3AB7F6);
  // премиальный бордовый (бренд / риски)
  static const medBurgundy = Color(0xFF7A1F2B);
  static const background = Colors.white;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.medBlue,
      primary: AppColors.medBlue,
      secondary: AppColors.medBurgundy,
      background: AppColors.background,
      error: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
  );
}
