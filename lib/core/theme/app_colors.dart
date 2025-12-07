import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF673AB7); // Deep Purple
  static const Color secondary = Color(0xFF1E90FF); // Darker Sky Blue

  // Gradients & Shadows
  static const Color gradientStart = primary;
  static const Color gradientEnd = secondary;
  static const Color greenStart = Color(0xFF512DA8);
  static const Color greenEnd = Color(0xFF9575CD);
  static const Color shadowGreen = Color(0xFF4527A0);
  static const Color shadowLightGreen = Color(0xFF7E57C2);

  // Red
  static const Color red = Color(0xFFEF4E4E);
  static const Color redLight = Color(0xFFFFD7D7);
  static const Color redShadow = Color.fromRGBO(239, 78, 78, 0.2);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color greyText = Color(0xFFA3A3A3); // consider removing or mapping to neutral400
  static const Color greyHint = Color(0xFF949495); // consider using as neutralHint

  static const Color neutral100 = Color(0xFFF5F6F7);
  static const Color neutral300 = Color(0xFFDCDFE3);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF9BA1A8);
  static const Color neutral600 = Color(0xFF6B7580);
  static const Color neutral800 = Color(0xFF242D35);
  static const Color neutralBorder = Color(0xFFB0B8BF);

  // Additional Colors
  static const Color orange = Color(0xFFFF9800);
  static const Color amber = Color(0xFFFFC107);

  // Reusable Gradients
  static const List<Color> buttonGradient = [primary, secondary];

  //blue
  static const Color blue = Color(0xFF37ABFF);
  static const Color blueShadow = Color.fromRGBO(24, 144, 255, 0.2);
}
