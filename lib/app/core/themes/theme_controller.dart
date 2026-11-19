
import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/services/reactive/reactive_controller.dart';
import 'package:gif_explorer/app/core/themes/theme_state.dart';

class ThemeController extends ReactiveController<ThemeState> {
  ThemeController() :super(ThemeState(themeMode: ThemeMode.dark));

  void toggleTheme() {
    if(state.themeMode == ThemeMode.dark){
      emit(ThemeState(themeMode: ThemeMode.light));
    }else{ emit(ThemeState(themeMode: ThemeMode.dark));}
      
  }

  void setThemeMode(ThemeMode themeMode) {
    emit(ThemeState(themeMode: themeMode));
  }
}
