import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/modular/explorer/presentation/pages/explorer_page.dart';

void registerExplorerRoutes(ModularContext c ){
  c.route(
    '/',
     child:(context, state) => const ExplorerPage(),);
}