import 'package:dio/dio.dart';
import 'package:flutmdb/app/data/network/api_error.dart';
import 'package:flutmdb/app/data/network/api_service.dart';
import 'package:flutmdb/app/data/network/request/movies_request.dart';
import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/domain/models/resource.dart';
import 'package:flutmdb/app/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiService apiService;

  MovieRepositoryImpl(this.apiService);

  @override
  Future<Resource<MovieDetail>> getMovieDetail(int movieId) async {
     try {
       final data = await apiService.getMovieDetail(movieId);
       return Result(data);
     }
     catch(e) {
       return _handleError(e);
     }
  }

  @override
  Future<Resource<MovieListResponse>> getMovies({required int page}) async {
    try {
      final data = await apiService.discoverMovies(
        MoviesRequest.defaultRequest(page: page),
      );
      return Result(data);
    }
    catch(e) {
      return _handleError(e);
    }
  }

  Error<T> _handleError<T>(e) {
    String message = e.toString();
    int code= -1;
    int apiCode =  -1;
    if (e is ParseError) {
      message = e.message;
    }
    if (e is DioException) {
      Map<String, dynamic> resp = e.response?.data ?? <String, dynamic>{};
      message = resp['status_message'] ?? e.toString();
      apiCode = resp['status_code'];
      code = e.response?.statusCode ?? -1;
    }
    return Error(message, code, apiCode);
  }
}
