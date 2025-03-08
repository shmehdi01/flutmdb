import 'package:flutmdb/app/domain/models/favorite_movie.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';

abstract interface class FavoriteRepository {

  Future<List<FavoriteMovie>> getFavorites();

  Future<void> saveFavorite(FavoriteMovie movie);

  Future<void> removeFavorite(int movieId);
}