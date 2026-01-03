import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme with a clean, functional dark aesthetic
class AppTheme {
  static const _background = Color(0xFF131314);
  static const _surface = Color(0xFF1E1F20);
  static const _surfaceVariant = Color(0xFF444746);
  static const _primary = Color(0xFF8AB4F8);
  static const _secondary = Color(0xFF81C995);
  static const _error = Color(0xFFF28B82);
  static const _warning = Color(0xFFFDD663);
  static const _text = Color(0xFFE2E2E6);
  static const _textMuted = Color(0xFFC4C7C5);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _background,
      colorScheme: const ColorScheme.dark(
        surface: _background,
        primary: _primary,
        secondary: _secondary,
        error: _error,
        onSurface: _text,
        onPrimary: _background,
        onSecondary: _background,
        onError: _background,
        surfaceContainerHighest: _surfaceVariant,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: _text,
        displayColor: _text,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: _surfaceVariant.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _surfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: const TextStyle(color: _textMuted),
        hintStyle: const TextStyle(color: _textMuted),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: _surfaceVariant),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: _textMuted,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _surfaceVariant,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _background,
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _text,
        ),
        iconTheme: const IconThemeData(color: _text),
      ),
    );
  }

  // Semantic colors for the editor
  static const Color starterColor = _primary; // Blue for starters
  static const Color conditionColor = _warning; // Yellow for conditions
  static const Color actionColor = _secondary; // Green for actions
  static const Color metadataColor = _primary; // Blue for metadata
}
