import 'dart:convert';

import 'package:flutmdb/app/domain/models/favorite_movie.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';
import 'package:flutmdb/app/domain/repository/favorite_repository.dart';
import 'package:hive/hive.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {

    Future<Box<String>> _favoriteBox() async {
      final box = await Hive.openBox<String>('favorites');
      return box;
    }

  @override
  Future<List<FavoriteMovie>> getFavorites() async {
    final box = await _favoriteBox();
    final list = box.values.map((e) {
       return FavoriteMovie.fromJson(jsonDecode(e));
    }).toList();
    await box.close();
    return list;
  }

  @override
  Future<void> saveFavorite(FavoriteMovie movie) async {
     final box = await _favoriteBox();
     await box.put(movie.id, jsonEncode(movie.toJson()));
     await box.close();
  }

  @override
  Future<void> removeFavorite(int movieId) async{
    final box = await _favoriteBox();
    await box.delete(movieId);
    await box.close();
  }

}