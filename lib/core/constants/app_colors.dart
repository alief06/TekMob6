import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8B8DE8);
  static const Color primaryLight = Color(0xFFA6A8EE);
  static const Color secondary = Color(0xFF9EC4E1);
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8B8DE8),
      Color(0xFFA6A8EE),
      Color(0xFF9EC4E1),
    ],
  );
}
