import 'package:flutter/material.dart';
import 'package:gif_explorer/app/core/themes/app_theme.dart';
import 'package:gif_explorer/app/core/themes/theme_controller.dart';
import 'package:gif_explorer/app/core/themes/theme_state.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final ThemeController _themeController = ThemeController();


@override
void dispose() {
  _themeController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeState>(
      valueListenable: _themeController,
      builder: (context, themeState , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeLight,
          darkTheme: AppTheme.themeDark,
          themeMode: themeState.themeMode,
          home:  Scaffold(
            appBar: AppBar(
              title: Text("Aberte"),
              actions: [
                IconButton(
                  onPressed: _themeController.toggleTheme, 
                  icon: Icon(
                   themeState.themeMode == ThemeMode.dark
                   ? Icons.light_mode : Icons.dark_mode, 
                  ),
                  tooltip:themeState.themeMode == ThemeMode.dark
                  ? 'Mudar para tema claro'
                  : 'Mudar para tema escuro' ),
              ],
              ),
            body: Center(child: Text('GIF Explorer')),
          ),
        );
      },
    );
  }
}