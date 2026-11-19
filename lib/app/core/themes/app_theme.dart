import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/themes/app_colors.dart';

class AppTheme {
  static final ThemeData themeDark = _theme(AppColors.dark, Brightness.dark);

  static final ThemeData themeLight = _theme(AppColors.light, Brightness.light);

  static ThemeData _theme(AppColors colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme(colors, brightness),
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.text,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surface,
        contentTextStyle: TextStyle(color: colors.text),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colors.text,
        ),
        titleLarge: TextStyle(fontSize: 22, color: colors.text),
        bodyMedium: TextStyle(fontSize: 16, color: colors.textMuted),
      ),
    );
  }

  static ColorScheme _colorScheme(AppColors colors, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.primary,
      onSecondary: colors.onPrimary,
      error: colors.error,
      onError: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.text,
      onSurfaceVariant: colors.textMuted,
      outline: colors.border,
    );
  }
}
