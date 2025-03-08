import 'dart:developer';

import 'package:flutmdb/app/config/di.dart';
import 'package:flutmdb/app/views/movie_list/cubits/get_movies/get_movies_cubit.dart';
import 'package:flutmdb/app/views/movie_list/cubits/network_cubit/network_cubit.dart';
import 'package:flutmdb/app/views/movie_list/movie_list_page.dart';
import 'package:flutmdb/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'app/views/movie_detail/cubits/favorite_cubit/favorite_cubit.dart';
import 'app/views/movie_list/cubits/toggle_view/toggle_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.initialize(apiKey: 'eadb266aa37c26749a997233b4f52f3c');
  await Hive.initFlutter();
  runApp(
    BlocProvider(
      create: (context) => FavoriteCubit(DI.inject()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter TMDB',
      theme: AppTheme.defaultAppTheme(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetMoviesCubit(DI.inject()),
          ),
          BlocProvider(
            create: (context) => NetworkCubit(),
          ),
          BlocProvider(
            create: (context) => ToggleViewCubit(),
          ),
        ],
        child: MovieListPage(),
      ),
    );
  }
}
