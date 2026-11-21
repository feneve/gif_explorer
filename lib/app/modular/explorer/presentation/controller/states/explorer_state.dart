import 'package:gif_explorer/app/core/services/reactive/reactive_state.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

enum ExplorerStateEnum { loading, success, error, initial, empty }

class ExplorerState extends ReactiveState {
  final ExplorerStateEnum stateEnum;
  final List<Gif> gifs;
  final String? errorMensagem;

  const ExplorerState({
     this.gifs = const [],
     this.errorMensagem ,
     this.stateEnum = ExplorerStateEnum.initial
  } );


}
