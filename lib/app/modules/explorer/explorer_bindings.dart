import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gif_explorer/app/core/constantes/api_config.dart';
import 'package:gif_explorer/app/modules/explorer/data/datasource/explorer_remote_data_source.dart';
import 'package:gif_explorer/app/modules/explorer/data/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modules/explorer/domain/repository/explorer_repository.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/get_trending_gifs.dart';
import 'package:gif_explorer/app/modules/explorer/domain/usecase/search_gifs.dart';

void registerExplorerBindings(ModularContext c){

c.addSingleton<Dio>(() => Dio());
c.addInstance<String>(ApiConfig.giphyApiKey);
c.add<IExplorerRemoteDataSource>(ExplorerRemoteDataSource.new);
c.add<IExplorerRepository>(ExplorerRepository.new);
c.add<GetTrendingGifs>(GetTrendingGifs.new);
c.add<SearchGifs>(SearchGifs.new);
}