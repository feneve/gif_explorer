import 'package:flutter_test/flutter_test.dart';
import 'package:gif_explorer/app/modular/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modular/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modular/explorer/presentation/controller/explorer_controller.dart';
import 'package:gif_explorer/app/modular/explorer/presentation/controller/states/explorer_state.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class FakeExplorerRepository implements IExplorerRepository {
  final List<Gif> gifsToReturn;
  @override
  Future<List<Gif>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    return gifsToReturn;
  }

  FakeExplorerRepository({required this.gifsToReturn});

}
void main() {
  late ExplorerController controller;
  late List<ExplorerStateEnum> emittedStates;
  late Gif testGif;

  setUp(() {
    testGif = const Gif(
      id: 'gif-test-1',
      title: 'GIF de teste',
      previewUrl: 'https://example.com/preview.gif',
      originalUrl: 'https://example.com/original.gif',
    );

    final repository = FakeExplorerRepository(
      gifsToReturn: [testGif],
    );
    final useCase = GetTrendingGifs(repository);

    controller = ExplorerController(useCase);
    emittedStates = [];

    controller.addListener(() {
      emittedStates.add(controller.state.stateEnum);
    });
  });

  tearDown(() {
    controller.dispose();
  });

  test('emite loading e success com os GIFs recebidos', () async {
    await controller.loadTrendingGifs(limit: 20, offset: 0);

    expect(emittedStates, [
      ExplorerStateEnum.loading,
      ExplorerStateEnum.success,
    ]);
    expect(controller.state.gifs, [testGif]);
  });
}

  

  