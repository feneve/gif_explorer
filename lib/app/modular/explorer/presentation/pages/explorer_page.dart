import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/core/themes/theme_controller.dart';

class ExplorerPage extends StatelessWidget {
  const ExplorerPage({super.key});

 
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.state.themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifs explorar"),
        actions: [
          IconButton(
            onPressed: themeController.toggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip : isDark ? "Tema claro" : "Tema escuro",),]
        
      ),
      body: 
       Center(child: Text("Explore os gifs")),
    );
  }
}