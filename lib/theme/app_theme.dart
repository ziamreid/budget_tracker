import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Dark Glassmorphic Color Palette ───────────────────────────

  // Base gradient backgrounds
  static const Color darkBg1 = Color(0xFF1a1a2e);
  static const Color darkBg2 = Color(0xFF16213e);
  static const Color darkBg = darkBg1; // Backward alias

  // Glassmorphic card backgrounds
  static const Color glassDark = Color(0xFF1E1E2E);
  static const Color glassLight = Color(0xFF2A2A3E);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color darkCard = glassDark; // Backward alias

  // Primary accent colors (purple/indigo)
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B7FFF);
  static const Color primaryLighter = Color(0xFFA59AFF);
  static const Color accentIndigo = primaryPurple; // Backward alias
  static const Color accentViolet = primaryLight; // Backward alias

  // Secondary accent colors
  static const Color accentPink = Color(0xFFFF6B9D);
  static const Color accentCyan = Color(0xFF00D9FF);
  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentAmber = accentOrange; // Backward alias
  static const Color accentGreen = success; // Backward alias
  static const Color accentTeal = accentCyan; // Backward alias

  // Semantic colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD93D);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF448AFF);
  static const Color accentRed = error; // Backward alias for error/warning

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8D1);
  static const Color textMuted = Color(0xFF6B6B80);
  static const Color darkTextPrimary = textPrimary; // Backward alias
  static const Color darkTextSecondary = textSecondary; // Backward alias
  static const Color lightTextMuted = textMuted; // Backward alias
  static const Color darkTextMuted = textMuted; // Backward alias

  // Border colors
  static const Color darkBorder = glassBorder; // Backward alias

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [darkBg1, darkBg2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryPurple, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x40FFFFFF), Color(0x10FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadow Styles ───────────────────────────────────────────
  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.3),
      blurRadius: 30,
      offset: const Offset(0, 15),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.5),
      blurRadius: 40,
      spreadRadius: 5,
    ),
  ];

  // ── Border Radius ───────────────────────────────────────────
  static const double radiusSmall = 12;
  static const double radiusMedium = 16;
  static const double radiusLarge = 20;
  static const double radiusXLarge = 28;

  static BorderRadius get smallRadius => BorderRadius.circular(radiusSmall);
  static BorderRadius get mediumRadius => BorderRadius.circular(radiusMedium);
  static BorderRadius get largeRadius => BorderRadius.circular(radiusLarge);
  static BorderRadius get xLargeRadius => BorderRadius.circular(radiusXLarge);

  // ── Glassmorphic Decorations ────────────────────────────────
  static BoxDecoration get glassDecoration => BoxDecoration(
    gradient: glassGradient,
    borderRadius: largeRadius,
    border: Border.all(color: glassBorder, width: 1),
  );

  static BoxDecoration get glassCardDecoration => BoxDecoration(
    color: glassDark.withValues(alpha: 0.7),
    borderRadius: largeRadius,
    border: Border.all(color: glassBorder, width: 1),
    boxShadow: glassShadow,
  );

  // ── Text Theme ───────────────────────────────────────────
  static TextTheme get _textTheme => GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
    ),
    displaySmall: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineLarge: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    headlineMedium: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.inter(
      color: textSecondary,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.inter(
      color: textSecondary,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.inter(
      color: textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.inter(
      color: textSecondary,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  );

  // ── Theme Data ─────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: primaryLight,
      tertiary: accentCyan,
      surface: glassDark,
      onPrimary: textPrimary,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      outline: glassBorder,
    ),
    textTheme: _textTheme,
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: largeRadius),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: textPrimary,
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: glassDark.withValues(alpha: 0.9),
      selectedItemColor: primaryPurple,
      unselectedItemColor: textMuted,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: glassDark.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: mediumRadius,
        borderSide: const BorderSide(color: glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: mediumRadius,
        borderSide: const BorderSide(color: glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: mediumRadius,
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      hintStyle: const TextStyle(color: textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: largeRadius),
        textStyle: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: glassBorder),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: largeRadius),
        textStyle: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPurple,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? textPrimary : textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primaryPurple : glassBorder,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? Colors.transparent
            : Colors.transparent,
      ),
    ),
    dividerTheme: const DividerThemeData(color: glassBorder, thickness: 0.5),
  );

  static ThemeData get light => dark;
}

// ── Glassmorphic Helper Widget ─────────────────────────────────
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.blur = 10,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppTheme.glassDark.withValues(alpha: 0.7),
        gradient: gradient ?? AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppTheme.glassBorder, width: 1),
        boxShadow: AppTheme.glassShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ── Backward-Compatible AppColors Extension ───────────────────────
extension AppColors on BuildContext {
  AppThemeData get appColors => AppThemeData(
    accentIndigo: AppTheme.accentIndigo,
    accentViolet: AppTheme.accentViolet,
    accentAmber: AppTheme.accentAmber,
    accentGreen: AppTheme.accentGreen,
    accentTeal: AppTheme.accentTeal,
    accentPink: AppTheme.accentPink,
    accentCyan: AppTheme.accentCyan,
    accentOrange: AppTheme.accentOrange,
    darkBg: AppTheme.darkBg,
    darkCard: AppTheme.darkCard,
    darkTextPrimary: AppTheme.darkTextPrimary,
    darkTextSecondary: AppTheme.darkTextSecondary,
    textMuted: AppTheme.textMuted,
    primaryPurple: AppTheme.primaryPurple,
    primaryLight: AppTheme.primaryLight,
    background: AppTheme.darkBg,
    surface: AppTheme.glassDark,
    border: AppTheme.glassBorder,
    bg: AppTheme.darkBg,
    textPrimary: AppTheme.textPrimary,
    textSecondary: AppTheme.textSecondary,
    card: AppTheme.glassDark,
  );
}

class AppThemeData {
  final Color accentIndigo;
  final Color accentViolet;
  final Color accentAmber;
  final Color accentGreen;
  final Color accentTeal;
  final Color accentPink;
  final Color accentCyan;
  final Color accentOrange;
  final Color darkBg;
  final Color darkCard;
  final Color darkTextPrimary;
  final Color darkTextSecondary;
  final Color textMuted;
  final Color primaryPurple;
  final Color primaryLight;
  final Color background;
  final Color surface;
  final Color border;
  final Color bg;
  final Color textPrimary;
  final Color textSecondary;
  final Color card;

  AppThemeData({
    required this.accentIndigo,
    required this.accentViolet,
    required this.accentAmber,
    required this.accentGreen,
    required this.accentTeal,
    required this.accentPink,
    required this.accentCyan,
    required this.accentOrange,
    required this.darkBg,
    required this.darkCard,
    required this.darkTextPrimary,
    required this.darkTextSecondary,
    required this.textMuted,
    required this.primaryPurple,
    required this.primaryLight,
    required this.background,
    required this.surface,
    required this.border,
    required this.bg,
    required this.textPrimary,
    required this.textSecondary,
    required this.card,
  });
}
