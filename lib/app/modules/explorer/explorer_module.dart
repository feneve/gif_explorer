import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/modules/explorer/explorer_bindings.dart';
import 'package:gif_explorer/app/modules/explorer/explorer_route.dart';

final explorerModulo = createModule(
  path: '/',
register: (c){
  registerExplorerBindings(c);
  registerExplorerRoutes(c);
}
 
) ;