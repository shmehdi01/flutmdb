part of 'get_movies_cubit.dart';

@immutable
abstract class GetMoviesState {}

class GetMoviesInitial extends GetMoviesState {}
class GetMoviesLoading extends GetMoviesState {}
class GetMoviesResult extends GetMoviesState {
  final List<MovieItem> results;
  final int total;

  GetMoviesResult(this.results, this.total);
}
class GetMoviesError extends GetMoviesState {
  final String message;

  GetMoviesError(this.message);

}
