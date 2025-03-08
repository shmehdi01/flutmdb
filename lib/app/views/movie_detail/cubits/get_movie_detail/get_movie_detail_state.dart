part of 'get_movie_detail_cubit.dart';

@immutable
abstract class GetMovieDetailState {}

class GetMovieDetailInitial extends GetMovieDetailState {}
class GetMovieDetailLoading extends GetMovieDetailState {}
class GetMovieDetailPreLoading extends GetMovieDetailState {
  final MovieItem movieItem;

  GetMovieDetailPreLoading(this.movieItem);
}
class GetMovieDetailResult extends GetMovieDetailState {
  final MovieDetail result;

  GetMovieDetailResult(this.result);
}
class GetMovieDetailError extends GetMovieDetailState {
  final String message;

  GetMovieDetailError(this.message);
}
