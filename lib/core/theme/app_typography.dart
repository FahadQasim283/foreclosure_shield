import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system for Foreclosure Shield app
/// Based on professional, trustworthy design principles
class AppTypography {
  AppTypography._();

  // Font Family
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Inter';

  // Display Styles - For large headings and hero sections
  static const TextStyle display1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.neutral800,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.neutral800,
  );

  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.neutral800,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.neutral800,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.neutral800,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.neutral800,
  );

  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.neutral800,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.neutral800,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0.4,
    color: AppColors.neutral600,
  );

  // Label Styles - For buttons, tabs, and form labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.neutral800,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.neutral800,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
    color: AppColors.neutral600,
  );

  // Button Text Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  // Caption & Helper Text
  static const TextStyle caption = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.4,
    color: AppColors.neutral500,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
    color: AppColors.neutral600,
  );

  // Special Styles
  static const TextStyle error = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.4,
    color: AppColors.red,
  );

  static const TextStyle success = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.4,
    color: AppColors.greenEnd,
  );

  static const TextStyle link = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.25,
    decoration: TextDecoration.underline,
    color: AppColors.blue,
  );

  // Risk Score Styles
  static const TextStyle riskScoreLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -1,
    color: AppColors.neutral800,
  );

  static const TextStyle riskScoreMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.neutral800,
  );

  // Badge/Chip Text
  static const TextStyle badge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.white,
  );
}
