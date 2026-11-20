import 'package:flutter_test/flutter_test.dart';
import 'package:gif_explorer/app/modular/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modular/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

void main() {
  test('encaminha limit e offset ao repositório e retorna os GIFs', () async {
    final repository = FakeExplorerRepository();
    final useCase = GetTrendingGifs(repository);

    final result = await useCase.call(limit: 20, offset: 40);

    expect(result.single.id, 'gif-123');
    expect(repository.receivedLimit, 20);
    expect(repository.receivedOffset, 40);
  });
}

class FakeExplorerRepository implements IExplorerRepository {
  int? receivedLimit;
  int? receivedOffset;

  @override
  Future<List<Gif>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    receivedLimit = limit;
    receivedOffset = offset;

    return [
      const Gif(
        id: 'gif-123',
        title: 'GIF de teste',
        previewUrl: 'https://example.com/preview.gif',
        originalUrl: 'https://example.com/original.gif',
      ),
    ];
  }
}
