import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: AppTypography.bodyFont,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: AppTypography.headerFont,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppTypography.headerFont,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppTypography.headerFont,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.gray800,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.gray700,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.gray700,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: AppTypography.bodyFont,
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
