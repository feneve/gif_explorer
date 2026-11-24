import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/data/datasource/explorer_remote_data_source.dart';
import 'package:gif_explorer/app/modules/explorer/data/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class FakeExplorerRemoteDataSource implements IExplorerRemoteDataSource {
  FakeExplorerRemoteDataSource({
    this.response = const {
      'data': <Map<String, dynamic>>[
        {
          'id': 'gif-test-1',
          'title': 'GIF de teste',
          'images': {
            'original': {
              'url': 'https://example.com/original.gif',
            },
            'fixed_height': {
              'url': 'https://example.com/preview.gif',
            },
          },
        },
      ],
    },
    this.errorToThrow,
  });

  final Map<String, dynamic> response;
  final Object? errorToThrow;

  int? lastLimit;
  int? lastOffset;

  @override
  Future<Map<String, dynamic>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    lastLimit = limit;
    lastOffset = offset;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return response;
  }
}

void main() {
  test('converte os GIFs da resposta e encaminha limit e offset', () async {
    final fakeDataSource = FakeExplorerRemoteDataSource();
    final repository = ExplorerRepository(
      explorerRemoteDataSource: fakeDataSource,
    );

    final result = await repository.getTrendingGifs(
      limit: 20,
      offset: 40,
    );

    result.fold(
      (failure) => fail('Esperava sucesso, mas recebeu $failure'),
      (gifs) {
        expect(gifs, hasLength(1));
        expect(gifs.first, isA<Gif>());
        expect(gifs.first.id, 'gif-test-1');
        expect(gifs.first.title, 'GIF de teste');
        expect(gifs.first.previewUrl, 'https://example.com/preview.gif' );
        expect(gifs.first.originalUrl, 'https://example.com/original.gif' );
      },
    );

    expect(fakeDataSource.lastLimit, 20);
    expect(fakeDataSource.lastOffset, 40);
  });

  test('retorna InvalidResponseFailure quando data não é uma lista', () async {
    final fakeDataSource = FakeExplorerRemoteDataSource(
      response: const {'data': 'formato-inválido'},
    );
    final repository = ExplorerRepository(
      explorerRemoteDataSource: fakeDataSource,
    );

    final result = await repository.getTrendingGifs(
      limit: 4,
      offset: 0,
    );

    result.fold(
      (failure) => expect(failure, isA<InvalidResponseFailure>()),
      (_) => fail('Esperava InvalidResponseFailure, mas recebeu sucesso.'),
    );
  });

  test('retorna NetworkFailure quando o DataSource lança DioException', () async {
    final fakeDataSource = FakeExplorerRemoteDataSource(
      errorToThrow: DioException(
        requestOptions: RequestOptions(path: '/trending'),
      ),
    );
    final repository = ExplorerRepository(
      explorerRemoteDataSource: fakeDataSource,
    );

    final result = await repository.getTrendingGifs(
      limit: 4,
      offset: 0,
    );

    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Esperava NetworkFailure, mas recebeu sucesso.'),
    );
  });
}