import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/data/datasource/explorer_remote_data_source.dart';
import 'package:gif_explorer/app/modules/explorer/data/mapper/gif_mapper.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class ExplorerRepository implements IExplorerRepository {
  final IExplorerRemoteDataSource explorerRemoteDataSource;

  ExplorerRepository({required this.explorerRemoteDataSource});

  @override
  Future<Either<IFailure, List<Gif>>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await explorerRemoteDataSource.getTrendingGifs(
        limit: limit,
        offset: offset,
      );

      final data = response['data'];

      if (data is! List) {
        throw const FormatException(
          'A resposta da GIPHY não contém uma lista válida em "data".',
        );
      }

      final gifs = data.map<Gif>((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Um item da lista de GIFs tem um formato inválido.',
          );
        }

        return GifMapper.fromMap(item);
      }).toList(growable: false);

      return Right<IFailure, List<Gif>>(gifs);
    } on FormatException {
      return Left<IFailure, List<Gif>>(InvalidResponseFailure());
    } on DioException {
      return Left<IFailure, List<Gif>>(NetworkFailure());
    } catch (_) {
      return Left<IFailure, List<Gif>>(UnexpectedFailure());
    }
  }
}