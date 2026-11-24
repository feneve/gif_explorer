import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/explorer_controller.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/pages/explorer_page.dart';

void registerExplorerRoutes(ModularContext c) {
  c.route(
    '/',
    provide: (s) => s.addListenable<ExplorerController>(
      ExplorerController.new,
      (controller) => controller,
      (controller) => controller.dispose(),
    ),
    child: (context, state) => const ExplorerPage(),
  );
}
