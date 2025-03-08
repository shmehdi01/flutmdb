import 'package:bloc/bloc.dart';
import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';
import 'package:flutmdb/app/domain/models/resource.dart';
import 'package:flutmdb/app/domain/repository/movie_repository.dart';
import 'package:meta/meta.dart';

part 'get_movies_state.dart';

class GetMoviesCubit extends Cubit<GetMoviesState> {
  final MovieRepository _repository;
  GetMoviesCubit(this._repository) : super(GetMoviesInitial());

  int _totalPage = 0;
  int _currentPage = 0;
  final _results =  <MovieItem>[];

  void getMovies({required int page}) async {
    emit(GetMoviesLoading());
    final resource = await _repository.getMovies(page: page);
    switch (resource) {

      case Result<MovieListResponse>():

        if (page == 1) {
          _results.clear();
        }
        _results.addAll(resource.data.results);
        _totalPage = resource.data.totalPages;
        _currentPage = resource.data.page;

        emit(GetMoviesResult(_results, _totalPage));
        break;
      case Error<MovieListResponse>():
        emit(GetMoviesError(resource.message));
        break;
    }
  }


  void loadMore() {
     getMovies(page: _currentPage+1);
  }

  bool get canLoadMore => _currentPage < _totalPage;


}
