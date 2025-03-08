import 'package:bloc/bloc.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';
import 'package:flutmdb/app/domain/models/resource.dart';
import 'package:flutmdb/app/domain/repository/movie_repository.dart';
import 'package:meta/meta.dart';

part 'get_movie_detail_state.dart';

class GetMovieDetailCubit extends Cubit<GetMovieDetailState> {
  final MovieRepository _repository;
  final MovieItem? movieItem;

  GetMovieDetailCubit(this._repository, {this.movieItem})
      : super(GetMovieDetailInitial());

  void getDetail(int id) async {
    if (movieItem != null) {
      emit(GetMovieDetailPreLoading(movieItem!));
    } else {
      emit(GetMovieDetailLoading());
    }

    final resource = await _repository.getMovieDetail(id);
    switch (resource) {
      case Result<MovieDetail>():
        emit(GetMovieDetailResult(resource.data));
        break;
      case Error<MovieDetail>():
        emit(GetMovieDetailError(resource.message));
        break;
    }
  }
}
