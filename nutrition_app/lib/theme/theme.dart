import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E6B5E),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF9AD8C0),
    onPrimaryContainer: Color(0xFF00382B),
    secondary: Color(0xFFF2A541),
    onSecondary: Color(0xFF3C2300),
    secondaryContainer: Color(0xFFFFDEA5),
    onSecondaryContainer: Color(0xFF281400),
    tertiary: Color(0xFF8C4A3E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDBC9),
    onTertiaryContainer: Color(0xFF360F00),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFAF6EF),
    onBackground: Color(0xFF1E1B16),
    surface: Color(0xFFFDF8F3),
    onSurface: Color(0xFF1E1B16),
    surfaceVariant: Color(0xFFE3EFE7),
    onSurfaceVariant: Color(0xFF43483E),
    outline: Color(0xFF73786D),
    outlineVariant: Color(0xFFC3C8BC),
    shadow: Color(0x26000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF31342E),
    onInverseSurface: Color(0xFFF2F1EA),
    inversePrimary: Color(0xFF7EC5AB),
    surfaceTint: Color(0xFF2E6B5E),
  );

  static ThemeData get theme {
    final baseTextTheme = GoogleFonts.manropeTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(height: 1.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle:
              baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle:
              baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle:
              baseTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: baseTextTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primary.withOpacity(0.16),
        secondarySelectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        brightness: colorScheme.brightness,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        labelStyle: baseTextTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 32,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        tileColor: colorScheme.surface,
        titleTextStyle:
            baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        subtitleTextStyle: baseTextTheme.bodyMedium,
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
    );
  }
}
