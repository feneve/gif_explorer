import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

void main() {
  const testGif = Gif(
    id: 'gif-123',
    title: 'GIF de teste',
    previewUrl: 'https://example.com/preview.gif',
    originalUrl: 'https://example.com/original.gif',
  );

  test('encaminha limit e offset e retorna os GIFs em Right', () async {
    final repository = FakeExplorerRepository(
      result: Right<IFailure, List<Gif>>([testGif]),
    );
    final useCase = GetTrendingGifs(repository);

    final result = await useCase.call(limit: 20, offset: 40);

    result.fold(
      (failure) => fail('Esperava sucesso, mas recebeu uma falha.'),
      (gifs) => expect(gifs.single.id, 'gif-123'),
    );

    expect(repository.receivedLimit, 20);
    expect(repository.receivedOffset, 40);
  });

  test('repassa a falha recebida do repositório em Left', () async {
    final repository = FakeExplorerRepository(
      result: Left<IFailure, List<Gif>>(NetworkFailure()),
    );
    final useCase = GetTrendingGifs(repository);

    final result = await useCase.call(limit: 20, offset: 40);

    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Esperava uma falha, mas recebeu sucesso.'),
    );
  });
}

class FakeExplorerRepository implements IExplorerRepository {
  FakeExplorerRepository({required this.result});

  final Either<IFailure, List<Gif>> result;

  int? receivedLimit;
  int? receivedOffset;

  @override
  Future<Either<IFailure, List<Gif>>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    receivedLimit = limit;
    receivedOffset = offset;
    return result;
  }
}