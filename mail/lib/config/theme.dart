import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2D5BFF);
  static const Color secondary = Color(0xFF8A94A6);
  static const Color background = Color(0xFFF8FAFD);
  static const Color card = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFF6B35);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2C94C);
  static const Color error = Color(0xFFEB5757);
}

final appTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
      ),
  useMaterial3: true,
  fontFamily: 'Inter',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
