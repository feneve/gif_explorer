import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class GetTrendingGifs {
  final IExplorerRepository _repository;
  GetTrendingGifs(this._repository);

  Future<Either<IFailure,List<Gif>>> call({required int limit, required int offset}) {
    return _repository.getTrendingGifs(limit: limit, offset: offset);
  }
}
