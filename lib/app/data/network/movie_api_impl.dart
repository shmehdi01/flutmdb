import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutmdb/app/data/network/api_error.dart';
import 'package:flutmdb/app/data/network/api_service.dart';
import 'package:flutmdb/app/data/network/model_parser_mixin.dart';
import 'package:flutmdb/app/data/network/request/movies_request.dart';
import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';
import 'package:flutmdb/app/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MovieApiImpl with ModelParseMixin implements ApiService {
  late final Dio _dio;

  MovieApiImpl({required String apiKey}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        headers: {
          'accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (option, handler) {
      return handler.next(option..queryParameters['api_key'] = apiKey);
    }));
  }

  @override
  Future<MovieListResponse> discoverMovies(MoviesRequest request) async {
    final response =
        await _dio.get('discover/movie', queryParameters: request.toQuery());
    if (response.statusCode == 200) {
      return parse<MovieListResponse>(response.data)!;
    }

    throw ApiError(
      message: response.data,
      code: response.statusCode ?? 500,
    );
  }

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final response = await _dio.get('movie/$movieId');
    if (response.statusCode == 200) {
      return parse<MovieDetail>(response.data)!;
    }

    throw ApiError(
      message: response.data,
      code: response.statusCode ?? 500,
    );
  }
}
