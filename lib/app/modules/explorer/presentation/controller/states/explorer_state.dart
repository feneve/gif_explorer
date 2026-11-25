import 'package:gif_explorer/app/core/services/reactive/reactive_state.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

enum ExplorerStateEnum { loading, success, error, initial, empty }

class ExplorerState extends ReactiveState {
  final ExplorerStateEnum stateEnum;
  final List<Gif> gifs;
  final String? errorMensagem;
  final bool isLoadingMore;
  final bool hasMore;
  final String? loadMoreError;
  final String? searchQuery;
  final String? searchInputError;

  const ExplorerState({
    this.gifs = const [],
    this.errorMensagem,
    this.stateEnum = ExplorerStateEnum.initial,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.loadMoreError,
    this.searchQuery,
    this.searchInputError,
  });

  ExplorerState copyWith({
    ExplorerStateEnum? stateEnum,
    List<Gif>? gifs,
    String? errorMensagem,
    bool? isLoadingMore,
    bool? hasMore,
    String? loadMoreError,
    bool clearErrorMensagem = false,
    bool clearLoadMoreError = false,
    String? searchQuey,
    String? searchInputError,
    bool clearSearchQuery = false,
    bool clearSearchInputError = false,
  }) {
    return ExplorerState(
      stateEnum: stateEnum ?? this.stateEnum,
      gifs: gifs ?? this.gifs,
      errorMensagem: clearErrorMensagem
          ? null
          : errorMensagem ?? this.errorMensagem,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
     searchQuery:
          clearSearchQuery ? null : searchQuery ?? searchQuery,
      searchInputError: clearSearchInputError
          ? null
          : searchInputError ?? this.searchInputError,
    );
  }
}
