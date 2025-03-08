import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutmdb/app/domain/models/favorite_movie.dart';
import 'package:flutmdb/app/domain/repository/favorite_repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;
  FavoriteCubit(this._repository) : super(FavoriteState([]));

  void getFavorites() async {
     final list = await _repository.getFavorites();
     emit(FavoriteState(list));
  }

  void handleFavorites(FavoriteMovie item) {
    setFavorites(item);
  }



  Future<void> setFavorites(FavoriteMovie item) async {
      if (state.isFavorite(item.id)) {
        await _repository.removeFavorite(item.id);
      }
      else {
        await _repository.saveFavorite(item);
      }

      getFavorites();
  }
}
