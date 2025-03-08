import 'package:flutmdb/app/domain/models/movie_item.dart';

class MovieListResponse {
  final int page;
  final List<MovieItem> results;
  final int totalPages;
  final int totalResults;

  MovieListResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      page: json['page'],
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieItem.fromJson(e))
          .toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}
