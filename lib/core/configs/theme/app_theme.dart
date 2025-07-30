import 'package:clisence/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Helper method to avoid code duplication
  static ButtonStyle _baseButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    double borderRadius = 12,
    TextStyle? textStyle,
    Size? minimumSize,
    BorderSide? borderSide,
    double elevation = 2,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide ?? BorderSide.none,
      ),
      textStyle: textStyle ??
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
      minimumSize: minimumSize ?? const Size.fromHeight(50),
      elevation: elevation,
    );
  }

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.primaryColorDark,
    primaryColorLight: AppColors.primaryColorLight,
    scaffoldBackgroundColor: AppColors.backgroundColorLight,
    // Define multiple button themes
    extensions: [
      // Custom ThemeData extension for button variants
      CustomButtonTheme(
        primaryButton: _baseButtonStyle(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          borderRadius: 12,
        ),
        secondaryButton: _baseButtonStyle(
          backgroundColor: AppColors.secondaryColor, // Assume a secondary color defined in AppColors
          foregroundColor: Colors.black,
          borderRadius: 12,
        ),
        outlinedButton: _baseButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryColor,
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          elevation: 0,
        ),
      ),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _baseButtonStyle(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        borderRadius: 12,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.primaryColorDark,
    primaryColorLight: AppColors.primaryColorLight,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    extensions: [
      CustomButtonTheme(
        primaryButton: _baseButtonStyle(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          borderRadius: 30,
        ),
        secondaryButton: _baseButtonStyle(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: Colors.white,
          borderRadius: 30,
        ),
        outlinedButton: _baseButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryColorLight,
          borderSide: BorderSide(color: AppColors.primaryColorLight, width: 2),
          elevation: 0,
        ),
      ),
    ],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _baseButtonStyle(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        borderRadius: 30,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

// Custom Theme Extension for Button Variants
class CustomButtonTheme extends ThemeExtension<CustomButtonTheme> {
  final ButtonStyle primaryButton;
  final ButtonStyle secondaryButton;
  final ButtonStyle outlinedButton;

  CustomButtonTheme({
    required this.primaryButton,
    required this.secondaryButton,
    required this.outlinedButton,
  });

  @override
  ThemeExtension<CustomButtonTheme> copyWith({
    ButtonStyle? primaryButton,
    ButtonStyle? secondaryButton,
    ButtonStyle? outlinedButton,
  }) {
    return CustomButtonTheme(
      primaryButton: primaryButton ?? this.primaryButton,
      secondaryButton: secondaryButton ?? this.secondaryButton,
      outlinedButton: outlinedButton ?? this.outlinedButton,
    );
  }

  @override
  ThemeExtension<CustomButtonTheme> lerp(
      ThemeExtension<CustomButtonTheme>? other, double t) {
    if (other is! CustomButtonTheme) return this;
    return CustomButtonTheme(
      primaryButton: ButtonStyle.lerp(primaryButton, other.primaryButton, t)!,
      secondaryButton:
      ButtonStyle.lerp(secondaryButton, other.secondaryButton, t)!,
      outlinedButton: ButtonStyle.lerp(outlinedButton, other.outlinedButton, t)!,
    );
  }
}