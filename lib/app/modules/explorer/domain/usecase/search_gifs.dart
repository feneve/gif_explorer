import 'package:fpdart/fpdart.dart';
import 'package:gif_explorer/app/core/failures/failure.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class SearchGifs {
 final IExplorerRepository _explorerRepository;

  SearchGifs( this._explorerRepository);

  Future<Either<IFailure, List<Gif>>> call({
    required int limit,
    required int offset,
    required String query,
  }) {
    return _explorerRepository.searchGifs(limit: limit, offset: offset, query: query);
  }
}
