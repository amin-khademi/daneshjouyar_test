import 'package:daneshjouyar_test/src/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme configuration constants following KISS principle
class AppThemeConfig {
  // Private constructor to prevent instantiation (YAGNI)
  AppThemeConfig._();

  // Font family constant (DRY)
  static String fontFamily = AppAssets.fontFamilyKalameh;

  /// Light theme configuration (Single Responsibility)
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seedLight,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: fontFamily,
        appBarTheme: _lightAppBarTheme,
        cardTheme: _lightCardTheme,
        listTileTheme: _lightListTileTheme,
        textTheme: _lightTextTheme,
      );

  /// Dark theme configuration (Single Responsibility)
  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seedDark,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: _darkAppBarTheme,
        cardTheme: _darkCardTheme,
        listTileTheme: _darkListTileTheme,
        textTheme: _darkTextTheme,
      );

  // Private theme components (DRY principle)
  static  final AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: 2,
    shadowColor: Colors.black26,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
      fontFamily: fontFamily,
    ),
    backgroundColor: Colors.black87,
    foregroundColor: AppColors.white,
    iconTheme: IconThemeData(color: AppColors.white),
    actionsIconTheme: IconThemeData(color: AppColors.white),
  );

  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: 2,
    shadowColor: Colors.black54,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
      fontFamily: fontFamily,
    ),
    backgroundColor: AppColors.appBarDark,
    foregroundColor: AppColors.white,
  );

  static CardTheme get _lightCardTheme => CardTheme(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: AppColors.white,
      );

  static CardTheme get _darkCardTheme => CardTheme(
        elevation: 6,
        shadowColor: Colors.black54,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  static const ListTileThemeData _lightListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  static const ListTileThemeData _darkListTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    textColor: AppColors.white,
  );

  static  final TextTheme _lightTextTheme = TextTheme(
    bodyLarge:
        TextStyle(color: AppColors.textPrimaryLight, fontFamily: fontFamily),
    bodyMedium:
        TextStyle(color: AppColors.textPrimaryLight, fontFamily: fontFamily),
    titleMedium: TextStyle(
      color: AppColors.textPrimaryLight,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    titleSmall:
        TextStyle(color: AppColors.textSecondaryLight, fontFamily: fontFamily),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    bodyLarge:
        TextStyle(color: AppColors.textPrimaryDark, fontFamily: fontFamily),
    bodyMedium:
        TextStyle(color: AppColors.textPrimaryDark, fontFamily: fontFamily),
    titleMedium: TextStyle(
      color: AppColors.textPrimaryDark,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    titleSmall:
        TextStyle(color: AppColors.textSecondaryDark, fontFamily: fontFamily),
  );
}
