import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

abstract class IExplorerRepository {
  Future<Either<IFailure, List<Gif>>> getTrendingGifs({required int limit, required int offset});

  Future<Either<IFailure,List<Gif>>> searchGifs({required int limit, required int offset, required String query });
}
