import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/services/reactive/reactive_state.dart';

class ThemeState extends ReactiveState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});
}
