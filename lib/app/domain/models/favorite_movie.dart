import 'package:flutmdb/app/domain/models/movie_item.dart';

class FavoriteMovie {
  final int id;
  final String title;
  final String date;
  final String poster;
  final double rating;

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.poster,
    required this.date,
    required this.rating,
  });

  factory FavoriteMovie.fromJson(Map<String, dynamic> map) {
    return FavoriteMovie(
      id: map['id'],
      title: map['title'],
      poster: map['poster'],
      date: map['date'],
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'rating': rating,
      'poster': poster,
    };
  }

  factory FavoriteMovie.fromMovieItem(MovieItem movieItem) {
    return FavoriteMovie(
      id: movieItem.id,
      title: movieItem.originalTitle,
      poster: movieItem.posterPath,
      date: movieItem.releaseDate,
      rating: movieItem.voteAverage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is MovieItem) {
      return id == other.id;
    }
    if (other is FavoriteMovie) {
      return id == other.id;
    }
    if (other is int) {
      return id == other;
    }
    return identical(this, other);
  }

  @override
  int get hashCode => id;

}
