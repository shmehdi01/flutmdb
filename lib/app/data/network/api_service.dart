import 'package:flutmdb/app/data/network/request/movies_request.dart';
import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';

abstract interface class ApiService {

  Future<MovieListResponse> discoverMovies(MoviesRequest request);

  Future<MovieDetail> getMovieDetail(int movieId);
}