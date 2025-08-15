import 'package:flutter/material.dart';

/// Centralized color palette to avoid hardcoded colors in the app.
/// Follow KISS/DRY by reusing named colors from a single place.
class AppColors {
  AppColors._();

  // Brand / Seed
  static const Color seedLight = Color(0xFF2196F3);
  static const Color seedDark = Color(0xFF8E44AD);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black26 = Colors.black26;
  static const Color black12 = Colors.black12;
  static const Color white70 = Colors.white70;

  // Dark surfaces
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color appBarDark = Color(0xFF16213E);
  static const Color cardDark = Color(0xFF0F3460);

  // Light surfaces
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Colors.white;
  static const Color neutralLight = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color lilacSurface = Color(0xFFE8DCED);

  // Accents
  static const Color purple = Color(0xFF8E44AD);
  static const Color purple700 = Color(0xFF9C27B0);
  static const Color blue700 = Color(0xFF1976D2);
  static const Color blue400 = Color(0xFF42A5F5);
  static const Color blue800 = Color(0xFF1565C0);

  // Status / Feedback
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorContainerLight = Color(0xFFFFEBEE);
  static const Color dangerPink = Color(0xFFE91E63);

  // Extra text accents
  static const Color lavender = Color(0xFFB39DDB);
  static const Color grey700 = Color(0xFF616161);

  // Shimmer helpers
  static const Color shimmerBaseDark = Color(0xFF0F3460);
  static const Color shimmerHighlightDark = Color(0xFF16213E);
  static const Color shimmerBaseLight = Color(0xFFF3E5F5);
  static const Color shimmerHighlightLight = Color(0xFFE1BEE7);

  // Text
  static const Color textPrimaryDark = white;
  static const Color textSecondaryDark = white70;
  static const Color textPrimaryLight = black87;
  static const Color textSecondaryLight = black54;

  // Gradients (centralized to avoid duplication)
  static const LinearGradient splashBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      AppColors.backgroundDark,
      AppColors.appBarDark,
      AppColors.cardDark,
      AppColors.purple,
    ],
  );

  static const LinearGradient splashLogoGradient = LinearGradient(
    colors: <Color>[
      AppColors.blue400,
      AppColors.blue700,
    ],
  );
}
