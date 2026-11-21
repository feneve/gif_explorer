import 'package:gif_explorer/app/core/services/reactive/reactive_controller.dart';
import 'package:gif_explorer/app/modular/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modular/explorer/presentation/controller/states/explorer_state.dart';

class ExplorerController extends ReactiveController<ExplorerState> {
  final GetTrendingGifs _getTrendingGifs;

  ExplorerController(this._getTrendingGifs) : super(const ExplorerState());

  Future<void> loadTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    emit(ExplorerState(stateEnum: ExplorerStateEnum.loading));
    try {
      final gifs = await _getTrendingGifs(limit: limit, offset: offset);
      if (gifs.isEmpty) {
        emit(ExplorerState(stateEnum: ExplorerStateEnum.empty));
        return;
      }
      emit(ExplorerState(stateEnum: ExplorerStateEnum.success,gifs: gifs));
    } catch (_) {
      emit(
        ExplorerState(
          stateEnum: ExplorerStateEnum.error,
          errorMensagem: "Não foi possível carregar os GIFs. Tente novamente",
        ),
      );
    }
  }
}
