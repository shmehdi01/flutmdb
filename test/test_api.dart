import 'package:flutmdb/app/data/network/api_service.dart';
import 'package:flutmdb/app/data/network/movie_api_impl.dart';
import 'package:flutmdb/app/data/network/request/movies_request.dart';
import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/data/repository/movie_repository_impl.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/domain/models/resource.dart';
import 'package:flutmdb/app/domain/repository/movie_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ApiService apiService;
  late MovieRepository repository;
  setUp(() {
    apiService = MovieApiImpl(
      apiKey: 'YOUR_API_KEY',
    );

    repository = MovieRepositoryImpl(apiService);
  });

  test('Test Movie List', () async {
     final response = await apiService.discoverMovies(MoviesRequest.defaultRequest(page: 1));
     expect(response.results.isNotEmpty, true);
  });

  test('Test Movie Detail', () async {
    final response = await apiService.getMovieDetail(927342);
    expect(response.title, "Amaran");
  });

  test('Repo Success Movie Detail', () async {
    Resource resource = await repository.getMovieDetail(927342);
    expect((resource as Result<MovieDetail>).data.title, 'Amaran');
  });

  test('Invalid Api Key Test', () async {
    Resource resource = await repository.getMovieDetail(927342);
    expect((resource as Error).apiCode, 7);
  });


}
