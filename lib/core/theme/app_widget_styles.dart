import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Widget styles and presets for common UI components
class AppWidgetStyles {
  AppWidgetStyles._();

  // Risk Score Badge Styles
  static BoxDecoration riskBadgeDecoration(String category) {
    final color = AppColors.getRiskCategoryColor(category);
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [color, color.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
      ],
    );
  }

  // Card Styles
  static BoxDecoration elevatedCard = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
    ],
  );

  static BoxDecoration accentCard = BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.goldGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration primaryCard = BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button Decorations
  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.buttonGradient,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration secondaryButtonDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.goldGradient,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondary.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Input Field Decorations
  static InputDecoration standardInputDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.neutral50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.neutralBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.neutralBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red),
      ),
    );
  }

  // Divider Styles
  static Widget sectionDivider = Container(
    height: 1,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(vertical: 16),
  );

  static Widget thickDivider = Container(height: 8, color: AppColors.backgroundDark);

  // Status Indicators
  static Widget statusDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // Progress Bar Style
  static BoxDecoration progressBarTrack = BoxDecoration(
    color: AppColors.neutral200,
    borderRadius: BorderRadius.circular(4),
  );

  static BoxDecoration progressBarFill(Color color) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [color, color.withOpacity(0.7)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  // Shield Logo Style Container
  static BoxDecoration shieldBadge = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.secondary, width: 2),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // Bottom Sheet Decoration
  static BoxDecoration bottomSheetDecoration = const BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
  );

  // Countdown Timer Style
  static BoxDecoration countdownDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.red, AppColors.redDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: AppColors.red.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
    ],
  );

  // Avatar/Profile Picture Border
  static BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: AppColors.secondary, width: 3),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
    ],
  );

  // Icon Container Styles
  static BoxDecoration iconContainer(Color color) {
    return BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8));
  }

  static BoxDecoration circularIconContainer(Color color) {
    return BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle);
  }

  // Toast/Snackbar Decorations
  static BoxDecoration successToast = BoxDecoration(
    color: AppColors.green,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration errorToast = BoxDecoration(
    color: AppColors.red,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration warningToast = BoxDecoration(
    color: AppColors.orange,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration infoToast = BoxDecoration(
    color: AppColors.blue,
    borderRadius: BorderRadius.circular(8),
  );
}
