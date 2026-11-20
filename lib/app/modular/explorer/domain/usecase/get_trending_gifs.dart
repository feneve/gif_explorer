import 'package:gif_explorer/app/modular/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

class GetTrendingGifs {
  final IExplorerRepository _repository;
  GetTrendingGifs(this._repository);

  Future<List<Gif>> call({required int limit, required int offset}) {
    return _repository.getTrendingGifs(limit: limit, offset: offset);
  }
}
