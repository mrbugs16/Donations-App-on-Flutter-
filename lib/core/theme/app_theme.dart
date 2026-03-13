// file: lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ColorScheme _colorSchemeLight = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  );

  static final ColorScheme _colorSchemeDark = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _colorSchemeLight,
    appBarTheme: AppBarTheme(
      backgroundColor: _colorSchemeLight.primary,
      foregroundColor: _colorSchemeLight.onPrimary,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _colorSchemeDark,
    appBarTheme: AppBarTheme(
      backgroundColor: _colorSchemeDark.primary,
      foregroundColor: _colorSchemeDark.onPrimary,
    ),
  );
}
