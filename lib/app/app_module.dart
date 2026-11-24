import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/modules/explorer/explorer_module.dart';


final appModule = createModule(
  register :(c){
    c.module(explorerModulo);
  }
);