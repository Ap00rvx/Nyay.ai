import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const primary = Colors.black; // black accents (ties, coats)
    const background = Colors.white; // white surfaces (shirts, paper)
    const surface = Colors.white;
    const secondary = Color(0xFF2F2F2F); // dark grey for subtle elements

    final colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: background,
      onBackground: Colors.black,
      surface: surface,
      onSurface: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE5E5E5)),
      listTileTheme: const ListTileThemeData(iconColor: primary),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black),
      ),
    );
  }

  static ThemeData get dark {
    const primary = Colors.white; // white accents on black backgrounds
    const background = Colors.black;
    const surface = Color(0xFF0F0F0F);
    const secondary = Color(0xFFBDBDBD);

    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: Colors.black,
      secondary: secondary,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: background,
      onBackground: Colors.white,
      surface: surface,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF2A2A2A)),
      listTileTheme: const ListTileThemeData(iconColor: primary),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}
