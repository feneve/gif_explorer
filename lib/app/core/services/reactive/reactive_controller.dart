import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/core/services/reactive/reactive_state.dart';

abstract class IReactiveService <State extends ReactiveState> extends ValueListenable<State> implements Disposable{
  void emit (State state);
}

class ReactiveController <State extends ReactiveState> extends IReactiveService<State>{
  final ValueNotifier<State> _listenable;


  ReactiveController(State initialState)
    : _listenable = ValueNotifier<State>(initialState);

  @override
  void addListener(VoidCallback listener) => _listenable.addListener(listener);

  @override
  void dispose() => _listenable.dispose();

  @override
  void emit(State state) => _listenable.value = state;

  @override
  void removeListener(VoidCallback listener) => _listenable.removeListener(listener);

  @override
  State get value => _listenable.value;

  
  State get state =>  value;
  }
