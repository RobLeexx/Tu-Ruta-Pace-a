import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: AppColors.ink,
    error: AppColors.error,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.ink,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    titleLarge: TextStyle(
      color: AppColors.ink,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.ink,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: AppColors.body, fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(color: AppColors.body, fontSize: 14, height: 1.43),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.hairline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.hairline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.ink, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.error),
    ),
  ),
);
