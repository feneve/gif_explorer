import 'package:gif_explorer/app/shared/domain/entities/gif.dart';

abstract class IExplorerRepository {
  Future<List<Gif>> getTrendingGifs({required int limit, required int offset});
}
