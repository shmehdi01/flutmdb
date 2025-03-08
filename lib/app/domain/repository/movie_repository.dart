import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/domain/models/resource.dart';

abstract interface class MovieRepository {

  Future<Resource<MovieListResponse>> getMovies({required int page});

  Future<Resource<MovieDetail>> getMovieDetail(int movieId);
}