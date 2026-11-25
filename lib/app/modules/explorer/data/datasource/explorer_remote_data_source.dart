import 'package:dio/dio.dart';

abstract class IExplorerRemoteDataSource {
  Future<Map<String, dynamic>> getTrendingGifs({
    required int limit,
    required int offset,
  });
  Future<Map<String, dynamic>> searchGifs({
    required int limit,
    required int offset,
    required String query,
  });
}

class ExplorerRemoteDataSource implements IExplorerRemoteDataSource {
  final Dio dio;
  final String apiKey;

  ExplorerRemoteDataSource({required this.dio, required this.apiKey});

  static const String _trendingEndpoint =
      'https://api.giphy.com/v1/gifs/trending';

  @override
  Future<Map<String, dynamic>> getTrendingGifs({
    required int limit,
    required int offset,
  }) async {
    final response = await dio.get<dynamic>(
      _trendingEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'limit': limit,
        'offset': offset,
        'rating': 'g',
      },
    );
    final responseData = response.data;

    if (responseData is Map<String, dynamic>) {
      return responseData;
    } else {
      throw const FormatException(
        "A resposta de tendências da GIPHY não tem o formato esperado",
      );
    }
  }

  static const String _searchEndpoint = 'https://api.giphy.com/v1/gifs/search';
  @override
  Future<Map<String, dynamic>> searchGifs({
    required int limit,
    required int offset,
    required String query,
  }) async {

final response = await dio.get<dynamic>(
  _searchEndpoint,
  queryParameters: {
     'api_key': apiKey,
      'limit': limit,
      'offset': offset,
      'q': query,
      'rating': 'g',
  }
);
final responseData = response.data;
if(responseData is Map<String,dynamic>){
  return responseData;
}else {
  throw const FormatException(
    "A resposta da busca  da GIPHY não tem o formato esperado.",
  );
}
  }
}
