import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors - Based on Shield Logo
  static const Color primary = Color(0xFF1A3A52); // Navy Blue from shield
  static const Color primaryDark = Color(0xFF0F2536); // Darker navy
  static const Color primaryLight = Color(0xFF2D5270); // Lighter navy

  static const Color secondary = Color(0xFFD4A14F); // Gold/Amber from shield
  static const Color secondaryDark = Color(0xFFB8873D); // Darker gold
  static const Color secondaryLight = Color(0xFFE8C17D); // Lighter gold

  static const Color accent = Color(0xFFD4A14F); // Gold accent
  static const Color accentLight = Color(0xFFF5E6C8); // Light gold background

  // Gradients & Shadows
  static const Color gradientStart = primary;
  static const Color gradientEnd = primaryLight;
  static const Color goldGradientStart = secondaryDark;
  static const Color goldGradientEnd = secondary;

  // Legacy gradient names (can be removed if not used)
  static const Color greenStart = Color(0xFF1A3A52);
  static const Color greenEnd = Color(0xFF2D5270);
  static const Color shadowGreen = Color(0xFF0F2536);
  static const Color shadowLightGreen = Color(0xFF2D5270);

  // Status Colors - Red (Critical/Danger)
  static const Color red = Color(0xFFDC3545);
  static const Color redLight = Color(0xFFFFE5E8);
  static const Color redDark = Color(0xFFC82333);
  static const Color redShadow = Color.fromRGBO(220, 53, 69, 0.2);

  // Status Colors - Orange (Warning/Urgent)
  static const Color orange = Color(0xFFFF9800);
  static const Color orangeLight = Color(0xFFFFE8CC);
  static const Color orangeDark = Color(0xFFE68900);
  static const Color orangeShadow = Color.fromRGBO(255, 152, 0, 0.2);

  // Status Colors - Amber (Caution/At-Risk)
  static const Color amber = Color(0xFFFFC107);
  static const Color amberLight = Color(0xFFFFF4D4);
  static const Color amberDark = Color(0xFFFFB300);

  // Status Colors - Green (Success/Safe)
  static const Color green = Color(0xFF28A745);
  static const Color greenLight = Color(0xFFD4EDDA);
  static const Color greenDark = Color(0xFF218838);
  static const Color greenShadow = Color.fromRGBO(40, 167, 69, 0.2);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Neutral Scale
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // Semantic Neutral Colors
  static const Color greyText = neutral600;
  static const Color greyHint = neutral500;
  static const Color neutralBorder = neutral300;
  static const Color backgroundLight = neutral50;
  static const Color backgroundDark = neutral100;
  static const Color divider = neutral200;

  // Blue (Info/Links)
  static const Color blue = Color(0xFF007BFF);
  static const Color blueLight = Color(0xFFE7F3FF);
  static const Color blueDark = Color(0xFF0056B3);
  static const Color blueShadow = Color.fromRGBO(0, 123, 255, 0.2);

  // Reusable Gradients
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> buttonGradient = [primaryDark, primary];
  static const List<Color> goldGradient = [goldGradientStart, goldGradientEnd];
  static const List<Color> successGradient = [greenDark, green];
  static const List<Color> dangerGradient = [redDark, red];

  // Surface Colors
  static const Color surface = white;
  static const Color surfaceTint = neutral50;
  static const Color surfaceVariant = neutral100;

  // Overlay Colors
  static Color overlay = black.withOpacity(0.5);
  static Color overlayLight = black.withOpacity(0.3);
  static Color overlayDark = black.withOpacity(0.7);

  // Risk Score Color Mapping
  static const Color riskCritical = red;
  static const Color riskUrgent = orange;
  static const Color riskAtRisk = amber;
  static const Color riskLow = green;

  /// Returns color based on risk score (0-100)
  static Color getRiskColor(int score) {
    if (score >= 80) return riskCritical;
    if (score >= 60) return riskUrgent;
    if (score >= 40) return riskAtRisk;
    return riskLow;
  }

  /// Returns color based on risk category
  static Color getRiskCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'CRITICAL':
        return riskCritical;
      case 'URGENT':
        return riskUrgent;
      case 'AT-RISK':
      case 'AT_RISK':
        return riskAtRisk;
      case 'LOW':
      case 'SAFE':
        return riskLow;
      default:
        return neutral500;
    }
  }
}
