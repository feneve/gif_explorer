import 'package:flutter_test/flutter_test.dart';
import 'package:gif_explorer/app/modular/explorer/data/datasource/explorer_remote_data_source.dart';
import 'package:gif_explorer/app/modular/explorer/data/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class FakeExplorerRemoteDataSource implements IExplorerRemoteDataSource {
  int? lastLimit;
  int? lastOffset;

  @override
  Future<Map<String, dynamic>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    lastLimit = limit;
    lastOffset = offset;

    return <String, dynamic>{
      'data': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'gif-test-1',
          'title': 'GIF de teste',
          'images': <String, dynamic>{
            'original': <String, dynamic>{
              'url': 'https://example.com/original.gif',
            },
            'fixed_height': <String, dynamic>{
              'url': 'https://example.com/preview.gif',
            },
          },
        },
      ],
    };
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

    expect(result, hasLength(1));
    expect(result.first, isA<Gif>());
    expect(result.first.id, 'gif-test-1');
    expect(result.first.title, 'GIF de teste');
    expect(result.first.previewUrl, 'https://example.com/preview.gif' );
    expect(result.first.originalUrl, 'https://example.com/original.gif' );

    expect(fakeDataSource.lastLimit, 20);
    expect(fakeDataSource.lastOffset, 40);
  });
}