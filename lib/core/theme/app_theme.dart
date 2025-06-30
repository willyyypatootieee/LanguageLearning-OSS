import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.orange,
      fontFamily: 'Nunito', // Set Nunito as the default body font
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.gray700,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.gray700,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.gray700,
        ),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.gray800,
        onError: Colors.white,
      ),
    );
  }
}
