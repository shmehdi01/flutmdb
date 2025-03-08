import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutmdb/app/config/app_navigator.dart';
import 'package:flutmdb/app/config/di.dart';
import 'package:flutmdb/app/domain/models/favorite_movie.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';
import 'package:flutmdb/app/utils/image_util.dart';
import 'package:flutmdb/app/views/movie_detail/cubits/get_movie_detail/get_movie_detail_cubit.dart';
import 'package:flutmdb/app/views/movie_list/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/favorite_cubit/favorite_cubit.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
  });

  static navigate(BuildContext context, {
    required int movieId,
    MovieItem? movieItem,
  }) {
    return AppNavigator.push(
      context,
      BlocProvider(
        create: (context) =>
            GetMovieDetailCubit(DI.inject(), movieItem: movieItem),
        child: MovieDetailPage(
          movieId: movieId,
        ),
      ),
    );
  }

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    context.read<GetMovieDetailCubit>().getDetail(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetMovieDetailCubit, GetMovieDetailState>(
        builder: (context, state) {
          if (state is GetMovieDetailPreLoading) {
            final movieItem = state.movieItem;
            return movieDetailWidget(
              backdropPath: movieItem.backdropPath,
              posterPath: movieItem.posterPath,
              movieId: movieItem.id,
              originalTitle: movieItem.originalTitle,
              releaseDate: movieItem.releaseDate,
              voteAverage: movieItem.voteAverage,
              voteCount: movieItem.voteCount,
              overview: movieItem.overview,
            );
          } else if (state is GetMovieDetailResult) {
            final detail = state.result;
            return movieDetailWidget(
                backdropPath: detail.backdropPath,
                posterPath: detail.posterPath,
                movieId: detail.id,
                originalTitle: detail.originalTitle,
                releaseDate: detail.releaseDate,
                voteAverage: detail.voteAverage,
                voteCount: detail.voteCount,
                overview: detail.overview,
                tagline: detail.tagline,
                genres: detail.genres,
                status: detail.status);
          } else if (state is GetMovieDetailError) {
            return Center(
              child: Text(state.message),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _backdropPoster(String path) {
    return CachedNetworkImage(imageUrl: ImageUtil.backdropUrl(path));
  }

  Widget _poster(String path, int movieId) {
    return Hero(
      tag: movieId,
      child: SizedBox(
        height: 220,
        child: AspectRatio(
          aspectRatio: 440 / 640,
          child: CachedNetworkImage(imageUrl: ImageUtil.posterUrl(path)),
        ),
      ),
    );
  }

  Widget movieDetailWidget({
    required String backdropPath,
    required String posterPath,
    required int movieId,
    required String originalTitle,
    required String releaseDate,
    required double voteAverage,
    required int voteCount,
    required String overview,
    String? tagline,
    List<Genre>? genres,
    String? status,
  }) {
    final favoriteCubit = context.read<FavoriteCubit>();
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            title: Text(originalTitle),
            actions: [
              IconButton(
                onPressed: () {
                  favoriteCubit.handleFavorites(
                    FavoriteMovie(
                      id: movieId,
                      title: originalTitle,
                      rating: voteAverage,
                      date: releaseDate,
                      poster: posterPath,
                    ),
                  );
                },
                icon: BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    return favoriteIcon(state.isFavorite(movieId));
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                alignment: Alignment.topCenter,
                child: _backdropPoster(backdropPath),
              ),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  _poster(posterPath, movieId),
                  Expanded(
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          originalTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          releaseDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey,
                          ),
                        ),
                        Row(
                          children: [
                            Badge(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              backgroundColor: Colors.amber,
                              label: Text(
                                voteAverage.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              " (${voteCount} Votes)",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (tagline != null)
                Text(
                  tagline,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              Text(
                "Overview",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                overview,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.blueGrey,
                ),
              ),
              if (genres != null) ...[
                Text(
                  "Genres",
                  style: TextStyle(fontSize: 16),
                ),
                Wrap(
                  spacing: 8,
                  children:
                  genres.map((e) => Chip(label: Text(e.name))).toList(),
                )
              ],
              if (status != null) ...[
                Text(
                  "Status",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueGrey,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
