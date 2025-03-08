import 'package:flutmdb/app/domain/models/favorite_movie.dart';
import 'package:flutmdb/app/utils/network_util.dart';
import 'package:flutmdb/app/views/movie_detail/cubits/favorite_cubit/favorite_cubit.dart';

import 'package:flutmdb/app/views/movie_list/cubits/get_movies/get_movies_cubit.dart';
import 'package:flutmdb/app/views/movie_list/cubits/network_cubit/network_cubit.dart';
import 'package:flutmdb/app/views/movie_list/widgets/movie_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../movie_detail/movie_detail_page.dart';
import 'cubits/toggle_view/toggle_cubit.dart';
import 'widgets/movie_card.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late final ScrollController _scrollController;
  late FavoriteCubit _favoriteCubit;

  @override
  void initState() {
    context.read<NetworkCubit>().listenNetwork();
    context.read<GetMoviesCubit>().getMovies(page: 1);
    _scrollController = ScrollController();
    _favoriteCubit = context.read<FavoriteCubit>()
      ..getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutMDB"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ToggleViewCubit>().toggleState();
            },
            icon: BlocBuilder<ToggleViewCubit, ToggleViewState>(
              builder: (context, state) {
                return Icon(state.showListView ? Icons.list : Icons.grid_view);
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, state) {
          if (state is NetworkAvailable) {
            return _networkMovieList();
          }
          return _favoriteMovieList();
        },
      ),
    );
  }

  Widget _favoriteMovieList() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          return Center(
            child: Text("No Favorites List"),
          );
        }

        return BlocBuilder<ToggleViewCubit, ToggleViewState>(
          builder: (context, viewState) {
            if (viewState.showListView) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final movieItem = state.favorites[index];
                  return MovieListItem(
                    movieId: movieItem.id,
                    title: movieItem.title,
                    releaseDate: movieItem.date,
                    voteAverage: movieItem.rating,
                    poster: movieItem.poster,
                    onFavoriteTap: () {
                      _favoriteCubit.handleFavorites(movieItem);
                    },
                    onTap: () async {
                      final isNetworkAvailable =
                      await NetworkUtil.isNetworkConnected();
                      if (!isNetworkAvailable) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No Internet Available"),
                          ),
                        );
                        return;
                      }
                      MovieDetailPage.navigate(
                        context,
                        movieId: movieItem.id,
                      );
                    },
                  );
                },
                itemCount: state.favorites.length,
              );
            }

            return GridView.builder(
              itemBuilder: (_, index) {
                final movieItem = state.favorites[index];
                return MovieCard(
                  movieId: movieItem.id,
                  title: movieItem.title,
                  releaseDate: movieItem.date,
                  voteAverage: movieItem.rating,
                  poster: movieItem.poster,
                  onFavoriteTap: () {
                    _favoriteCubit.handleFavorites(movieItem);
                  },
                  onTap: () async {
                    final isNetworkAvailable =
                    await NetworkUtil.isNetworkConnected();
                    if (!isNetworkAvailable) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("No Internet Available"),
                        ),
                      );
                      return;
                    }
                    MovieDetailPage.navigate(
                      context,
                      movieId: movieItem.id,
                    );
                  },
                );
              },
              itemCount: state.favorites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .55,
                crossAxisSpacing: 2,
              ),
            );
          },
        );
      },
    );
  }

  Widget _networkMovieList() {
    return BlocBuilder<GetMoviesCubit, GetMoviesState>(
      builder: (context, state) {
        if (state is GetMoviesResult) {
          return BlocBuilder<ToggleViewCubit, ToggleViewState>(
            builder: (context, viewState) {

              if (viewState.showListView) {
                return ListView.builder(
                  itemBuilder: (_, index) {
                    final movieItem = state.results[index];
                    return MovieListItem(
                      movieId: movieItem.id,
                      title: movieItem.originalTitle,
                      releaseDate: movieItem.releaseDate,
                      voteAverage: movieItem.voteAverage,
                      poster: movieItem.posterPath,
                      onFavoriteTap: () {
                        _favoriteCubit
                            .handleFavorites(FavoriteMovie.fromMovieItem(
                            movieItem));
                      },
                      onTap: () {
                        MovieDetailPage.navigate(
                          context,
                          movieId: movieItem.id,
                          movieItem: movieItem,
                        );
                      },
                    );
                  },
                  itemCount: state.results.length,
                  controller: _scrollController,
                );
              }

              return GridView.builder(
                itemBuilder: (_, index) {
                  final movieItem = state.results[index];
                  return MovieCard(
                    movieId: movieItem.id,
                    title: movieItem.originalTitle,
                    releaseDate: movieItem.releaseDate,
                    voteAverage: movieItem.voteAverage,
                    poster: movieItem.posterPath,
                    onFavoriteTap: () {
                      _favoriteCubit
                          .handleFavorites(FavoriteMovie.fromMovieItem(
                          movieItem));
                    },
                    onTap: () {
                      MovieDetailPage.navigate(
                        context,
                        movieId: movieItem.id,
                        movieItem: movieItem,
                      );
                    },
                  );
                },
                itemCount: state.results.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .55,
                  crossAxisSpacing: 2,
                ),
              );
            },
          );
        } else if (state is GetMoviesError) {
          return Center(
            child: Text(state.message),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
