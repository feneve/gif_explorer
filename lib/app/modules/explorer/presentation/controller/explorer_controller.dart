import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/core/services/reactive/reactive_controller.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/states/explorer_state.dart';

class ExplorerController extends ReactiveController<ExplorerState> {
  final GetTrendingGifs _getTrendingGifs;

  ExplorerController(this._getTrendingGifs)
      : super(const ExplorerState());

  static const int _pageSize = 4;
  static const int _maxTrendingOffset = 499;

  Future<void> loadTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    emit(const ExplorerState(stateEnum: ExplorerStateEnum.loading));

    final result = await _getTrendingGifs(
      limit: limit,
      offset: offset,
    );

    result.fold(
      (failure) {
        emit(
          ExplorerState(
            stateEnum: ExplorerStateEnum.error,
            errorMensagem: _messageFor(failure),
          ),
        );
      },
      (gifs) {
        if (gifs.isEmpty) {
          emit(const ExplorerState(stateEnum: ExplorerStateEnum.empty));
          return;
        }

        final hasMore =
            gifs.length == limit &&
            offset + gifs.length <= _maxTrendingOffset;

        emit(
          ExplorerState(
            stateEnum: ExplorerStateEnum.success,
            gifs: gifs,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  Future<void> loadMoreTrendingGifs() async {
    if (state.isLoadingMore || !state.hasMore || state.gifs.isEmpty) {
      return;
    }

    final offset = state.gifs.length;

    if (offset > _maxTrendingOffset) {
      emit(state.copyWith(hasMore: false));
      return;
    }

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
      ),
    );

    final result = await _getTrendingGifs(
      limit: _pageSize,
      offset: offset,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            loadMoreError: _messageFor(failure),
          ),
        );
      },
      (newGifs) {
        if (newGifs.isEmpty) {
          emit(
            state.copyWith(
              isLoadingMore: false,
              hasMore: false,
            ),
          );
          return;
        }

        final updatedGifs = [...state.gifs, ...newGifs];
        final hasMore = newGifs.length == _pageSize &&
            updatedGifs.length <= _maxTrendingOffset;

        emit(
          state.copyWith(
            gifs: updatedGifs,
            isLoadingMore: false,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  String _messageFor(IFailure failure) {
    if (failure is NetworkFailure) {
      return 'Verifique sua conexão e tente novamente.';
    }

    if (failure is InvalidResponseFailure) {
      return 'A resposta recebida não estava no formato esperado.';
    }

    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}