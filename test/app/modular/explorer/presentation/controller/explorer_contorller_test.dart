import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
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
  FakeExplorerRepository({required this.result});

  final Either<IFailure, List<Gif>> result;

  @override
  Future<Either<IFailure, List<Gif>>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    return result;
  }
}

void main() {
  ExplorerController createController(
    Either<IFailure, List<Gif>> result,
  ) {
    final repository = FakeExplorerRepository(result: result);
    final useCase = GetTrendingGifs(repository);
    return ExplorerController(useCase);
  }

  test('emite loading e success quando recebe GIFs em Right', () async {
    final controller = createController(
      Right<IFailure, List<Gif>>([testGif]),
    );
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
    final controller = createController(
      Left<IFailure, List<Gif>>(NetworkFailure()),
    );
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
}