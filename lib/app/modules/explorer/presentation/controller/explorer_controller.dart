import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/core/services/reactive/reactive_controller.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/search_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/states/explorer_state.dart';

class ExplorerController extends ReactiveController<ExplorerState> {
  final GetTrendingGifs _getTrendingGifs;
  final SearchGifs _searchGifs;

  ExplorerController(this._getTrendingGifs, this._searchGifs)
    : super(const ExplorerState());

  static const int _pageSize = 4;
  static const int _maxTrendingOffset = 499;
  static const int _maxSearchOffset = 4999;

  Future<void> loadTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    emit(const ExplorerState(stateEnum: ExplorerStateEnum.loading));

    final result = await _getTrendingGifs(limit: limit, offset: offset);

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
            gifs.length == limit && offset + gifs.length <= _maxTrendingOffset;

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

    final query = state.searchQuery;
    final offset = state.gifs.length;
    final maxOffset = query == null ? _maxTrendingOffset : _maxSearchOffset;

    if (offset > maxOffset) {
      emit(state.copyWith(hasMore: false));
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final result = query == null
        ? await _getTrendingGifs(limit: _pageSize, offset: offset)
        : await _searchGifs.call(
            limit: _pageSize,
            offset: offset,
            query: query,
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
          emit(state.copyWith(isLoadingMore: false, hasMore: false));
          return;
        }

        final updatedGifs = [...state.gifs, ...newGifs];
        final hasMore =
            newGifs.length == _pageSize && updatedGifs.length <= maxOffset;

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

  Future<void> searchGifs({
    required int limit,
    required int offset,
    required String query,
  }) async {
    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      emit(state.copyWith(searchInputError: 'Digite um termo para buscar.'));
      return;
    }

    if (normalizedQuery.length > 50) {
      emit(
        state.copyWith(
          searchInputError: 'A busca pode ter no máximo 50 caracteres.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        stateEnum: ExplorerStateEnum.loading,
        gifs: const [],
        searchQuey: normalizedQuery,
        hasMore: false,
        isLoadingMore: false,
        clearErrorMensagem: true,
        clearLoadMoreError: true,
        clearSearchInputError: true,
      ),
    );

    final result = await _searchGifs.call(
      limit: limit,
      offset: offset,
      query: normalizedQuery,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            stateEnum: ExplorerStateEnum.error,
            errorMensagem: _messageFor(failure),
            hasMore: false,
          ),
        );
      },
      (gifs) {
        if (gifs.isEmpty) {
          emit(
            state.copyWith(
              stateEnum: ExplorerStateEnum.empty,
              gifs: const [],
              hasMore: false,
              clearErrorMensagem: true,
            ),
          );
          return;
        }

        final hasMore =
            gifs.length == limit && offset + gifs.length <= _maxSearchOffset;

        emit(
          state.copyWith(
            stateEnum: ExplorerStateEnum.success,
            gifs: gifs,
            hasMore: hasMore,
            clearErrorMensagem: true,
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
