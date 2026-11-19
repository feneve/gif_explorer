import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color onPrimary;
  final Color surface;
  final Color background;
  final Color surfaceVariant;
  final Color text;
  final Color textMuted;
  final Color border;
  final Color error;
  final Color success;
  final Color warning;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.text,
    required this.textMuted,
    required this.border,
    required this.error,
    required this.success,
    required this.warning,
  });

  static const AppColors light = AppColors(
    primary: Color(0xFF8135E8),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFF7F5FA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEDE8F3),
    text: Color(0xFF1B1524),
    textMuted: Color(0xFF756B80),
    border: Color(0xFFDCD5E5),
    error: Color(0xFFD32F45),
    success: Color(0xFF16875D),
    warning: Color(0xFFB7791F),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF9747FF),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFF0D0B10),
    surface: Color(0xFF151219),
    surfaceVariant: Color(0xFF292330),
    text: Color(0xFFFFFFFF),
    textMuted: Color(0xFFA99DB5),
    border: Color(0xFF39313F),
    error: Color(0xFFFF5C70),
    success: Color(0xFF35C98A),
    warning: Color(0xFFFFBF5E),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? text,
    Color? textMuted,
    Color? border,
    Color? error,
    Color? success,
    Color? warning,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
   if(other is! AppColors){
    return this;
   }
   
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(
        surfaceVariant,
        other.surfaceVariant,
        t,
      )!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
}

}