import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/modular/explorer/explorer_route.dart';

final explorerModulo = createModule(
  path: '/',
register: registerExplorerRoutes,
) ;