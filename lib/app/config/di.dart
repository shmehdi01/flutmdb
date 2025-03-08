import 'package:flutmdb/app/data/network/api_service.dart';
import 'package:flutmdb/app/data/repository/favorite_repository_impl.dart';
import 'package:flutmdb/app/data/repository/movie_repository_impl.dart';
import 'package:flutmdb/app/domain/repository/favorite_repository.dart';
import 'package:flutmdb/app/domain/repository/movie_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../data/network/movie_api_impl.dart';

class DI {
  static final _injector = GetIt.instance;

  static Future<void> initialize({required String apiKey}) async {
    _injector.registerSingleton<ApiService>(MovieApiImpl(
      apiKey: apiKey,
    ));
    _injector.registerFactory<MovieRepository>(
      () => MovieRepositoryImpl(inject()),
    );
    _injector.registerFactory<FavoriteRepository>(
          () => FavoriteRepositoryImpl(),
    );
  }

  static T inject<T extends Object>() => _injector.get<T>();
}
