import 'package:flutter/material.dart';

class KConstants {
  KConstants._();

  static const String themeModeKey = 'themeModeKey';

  // Budget Tracker brand colors
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color accent = Color(0xFF06B6D4);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color incomeGreen = Color(0xFF10B981);
  static const Color expenseRed = Color(0xFFEF4444);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color textMutedLight = Color(0xFF64748B);

  // Balance card gradient (premium hero)
  static const List<Color> balanceGradientColors = [
    Color(0xFF0D9488),
    Color(0xFF059669),
    Color(0xFF047857),
  ];
  static const List<Color> balanceGradientColorsLight = [
    Color(0xFF14B8A6),
    Color(0xFF10B981),
    Color(0xFF059669),
  ];
}

class KStyle {
  KStyle._();

  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: -0.5,
  );

  static const TextStyle description = TextStyle(
    fontSize: 14,
    height: 1.4,
  );

  static const TextStyle amountLarge = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 28,
    letterSpacing: -1,
  );

  static const TextStyle amountMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const TextStyle label = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.5,
  );

  static const TextStyle overline = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 11,
    letterSpacing: 1.2,
  );
}
