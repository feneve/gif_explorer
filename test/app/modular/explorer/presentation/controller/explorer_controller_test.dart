import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/search_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/explorer_controller.dart';
import 'package:gif_explorer/app/modules/explorer/presentation/controller/states/explorer_state.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

const testGif = Gif(
  id: 'gif-test-1',
  title: 'GIF de teste',
  previewUrl: 'https://example.com/preview.gif',
  originalUrl: 'https://example.com/original.gif',
);

class FakeExplorerRepository implements IExplorerRepository {
  FakeExplorerRepository({
    required this.resultsByOffset,
    this.searchResultsByOffset = const {},
  });

  final Map<int, Either<IFailure, List<Gif>>> resultsByOffset;
  final Map<int, Either<IFailure, List<Gif>>> searchResultsByOffset;

  final List<int> receivedLimits = [];
  final List<int> receivedOffsets = [];
  final List<String> receivedQueries = [];

  @override
  Future<Either<IFailure, List<Gif>>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    receivedLimits.add(limit);
    receivedOffsets.add(offset);

    return resultsByOffset[offset] ??
        Right<IFailure, List<Gif>>([]);
  }

  @override
  Future<Either<IFailure, List<Gif>>> searchGifs({
    required int limit,
    required int offset,
    required String query,
  }) async {
    receivedQueries.add(query);

    return searchResultsByOffset[offset] ??
        Right<IFailure, List<Gif>>([]);
  }
}

void main() {
  ExplorerController createController(
    FakeExplorerRepository repository,
  ) {
    final getTrendingGifs = GetTrendingGifs(repository);
    final searchGifs = SearchGifs(repository );

    return ExplorerController(getTrendingGifs, searchGifs);
  }

  test('emite loading e success quando recebe GIFs em Right', () async {
    final repository = FakeExplorerRepository(
      resultsByOffset: {
        0: Right<IFailure, List<Gif>>([testGif]),
      },
    );
    final controller = createController(repository);
    addTearDown(controller.dispose);

    final emittedStates = <ExplorerStateEnum>[];
    controller.addListener(() {
      emittedStates.add(controller.state.stateEnum);
    });

    await controller.loadTrendingGifs(limit: 4, offset: 0);

    expect(emittedStates, [
      ExplorerStateEnum.loading,
      ExplorerStateEnum.success,
    ]);
    expect(controller.state.gifs, [testGif]);
    expect(controller.state.hasMore, isFalse);
  });

  test('emite loading e error quando recebe uma falha em Left', () async {
    final repository = FakeExplorerRepository(
      resultsByOffset: {
        0: Left<IFailure, List<Gif>>(NetworkFailure()),
      },
    );
    final controller = createController(repository);
    addTearDown(controller.dispose);

    final emittedStates = <ExplorerStateEnum>[];
    controller.addListener(() {
      emittedStates.add(controller.state.stateEnum);
    });

    await controller.loadTrendingGifs(limit: 4, offset: 0);

    expect(emittedStates, [
      ExplorerStateEnum.loading,
      ExplorerStateEnum.error,
    ]);
    expect(
      controller.state.errorMensagem,
      'Verifique sua conexão e tente novamente.',
    );
  });

  test('anexa a próxima página e usa o offset da quantidade carregada',
      () async {
    final firstPage = [
      for (var i = 1; i <= 4; i++)
        Gif(
          id: 'gif-$i',
          title: 'GIF $i',
          previewUrl: 'https://example.com/preview-$i.gif',
          originalUrl: 'https://example.com/original-$i.gif',
        ),
    ];

    final secondPage = [
      for (var i = 5; i <= 8; i++)
        Gif(
          id: 'gif-$i',
          title: 'GIF $i',
          previewUrl: 'https://example.com/preview-$i.gif',
          originalUrl: 'https://example.com/original-$i.gif',
        ),
    ];

    final repository = FakeExplorerRepository(
      resultsByOffset: {
        0: Right<IFailure, List<Gif>>(firstPage),
        4: Right<IFailure, List<Gif>>(secondPage),
      },
    );
    final controller = createController(repository);
    addTearDown(controller.dispose);

    await controller.loadTrendingGifs(limit: 4, offset: 0);
    await controller.loadMoreTrendingGifs();

    expect(controller.state.gifs, [...firstPage, ...secondPage]);
    expect(controller.state.gifs, hasLength(8));
    expect(repository.receivedLimits, [4, 4]);
    expect(repository.receivedOffsets, [0, 4]);
    expect(controller.state.isLoadingMore, isFalse);
  });
}