
import 'package:flutter/material.dart';

class AppColors {
  // Primary color scheme - using a rich maroon palette
  static const Color primary = Color(0xFF800020);        // Deep maroon
  static const Color primaryLight = Color(0xFF9F2B32);   // Lighter maroon
  static const Color primaryDark = Color(0xFF5D0015);    // Darker maroon

  // Secondary colors - warm complementary tones
  static const Color secondary = Color(0xFF8B4513);      // Saddle brown
  static const Color secondaryLight = Color(0xFFA0522D); // Sienna

  // Neutral colors - warm grays that complement maroon
  static const Color neutral900 = Color(0xFF1A1A1A);
  static const Color neutral800 = Color(0xFF2D2D2D);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral50 = Color(0xFFF9FAFB);

  // Status colors - carefully chosen to work with maroon
  static const Color success = Color(0xFF16A34A);        // Forest green
  static const Color warning = Color(0xFFEA580C);        // Warm orange
  static const Color danger = Color(0xFFDC2626);         // Red that complements maroon
  static const Color info = Color(0xFF0EA5E9);           // Sky blue for informational content

  // Accent colors for variety
  static const Color accent1 = Color(0xFF92400E);        // Amber-brown
  static const Color accent2 = Color(0xFF7C2D12);        // Rust
  static const Color accent3 = Color(0xFF991B1B);        // Deep red

  // NEW: Dark mode specific colors
  static const Color darkBackground = Color(0xFF000000);    // Pure black
  static const Color darkSurface = Color(0xFF1C1C1E);      // iOS dark surface
  static const Color darkCard = Color(0xFF2C2C2E);         // iOS dark card
  static const Color darkBorder = Color(0xFF3A3A3C);       // iOS dark border

  // NEW: Dark mode text colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);    // White
  static const Color darkTextSecondary = Color(0xFFEBEBF5);  // Light gray
  static const Color darkTextTertiary = Color(0xFF8E8E93);   // Medium gray

  // Timer-specific colors
  static Color getTimerStateColor(String state) {
    switch (state) {
      case 'TimerState.running':
        return success;
      case 'TimerState.paused':
        return warning;
      case 'TimerState.stopped':
        return neutral500;
      default:
        return neutral500;
    }
  }

  static Color getProgressColor(double progress) {
    if (progress < 0.5) {
      return success;
    } else if (progress < 0.8) {
      return warning;
    } else if (progress < 1.0) {
      return accent1; // Amber-brown for high progress
    } else {
      return danger; // Red for overtime
    }
  }

  static Color getRemainingTimeColor(Duration elapsed, Duration target) {
    if (elapsed > target) {
      return danger;
    }

    final progress = elapsed.inSeconds / target.inSeconds;
    return getProgressColor(progress);
  }

  // Theme-aware helper methods
  static Color getCardBackground(bool isDark) => isDark ? darkCard : neutral50;
  static Color getCardBorder(bool isDark) => isDark ? darkBorder : neutral200;
  static Color getTextPrimary(bool isDark) => isDark ? darkTextPrimary : neutral900;
  static Color getTextSecondary(bool isDark) => isDark ? darkTextSecondary : neutral600;
  static Color getTextMuted(bool isDark) => isDark ? darkTextTertiary : neutral500;
  static Color getSurface(bool isDark) => isDark ? darkSurface : Colors.white;

  // Gradient helpers for rich maroon effects
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );

  static LinearGradient get cardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neutral50, neutral100.withOpacity(0.8)],
  );

  // NEW: Dark mode gradients
  static LinearGradient get darkCardGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkCard, darkSurface.withOpacity(0.8)],
  );

  // Shadow colors that work well with maroon
  static Color get primaryShadow => primary.withOpacity(0.3);
  static Color get softShadow => neutral400.withOpacity(0.2);
  static Color get darkShadow => Colors.black.withOpacity(0.4);
}