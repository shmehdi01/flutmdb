part of 'favorite_cubit.dart';

class FavoriteState {
  final List<FavoriteMovie> favorites;

  FavoriteState(this.favorites);

  bool isFavorite(int movieId) {
    return favorites.contains(movieId);
  }
}


