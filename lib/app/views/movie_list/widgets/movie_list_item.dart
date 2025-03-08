import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutmdb/app/views/movie_detail/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:flutmdb/app/views/movie_detail/movie_detail_page.dart';
import 'package:flutmdb/app/views/movie_list/widgets/favorite_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/app_navigator.dart';
import 'package:flutmdb/app/domain/models/movie_item.dart';
import 'package:flutmdb/app/utils/image_util.dart';
import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  final int movieId;
  final String title;
  final String releaseDate;
  final double voteAverage;
  final String poster;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const MovieListItem({
    super.key,
    required this.movieId,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.poster,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: movieId,
      child: Card(
        child: ListTile(
          leading:  AspectRatio(
            aspectRatio: 440 / 660,
            child: CachedNetworkImage(
              imageUrl: ImageUtil.posterUrl(poster),
            ),
          ),
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            spacing: 6,
            children: [
              Text(
                releaseDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
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
            ],
          ),
          trailing: IconButton(
            onPressed: onFavoriteTap,
            icon: BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                return favoriteIcon(
                  state.isFavorite(movieId),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
