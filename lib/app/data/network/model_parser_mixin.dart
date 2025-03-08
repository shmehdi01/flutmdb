import 'dart:developer';

import 'package:flutmdb/app/data/network/responses/movie_list_response.dart';
import 'package:flutmdb/app/domain/models/movie_detail.dart';

import 'api_error.dart';

mixin ModelParseMixin {

  T? parse<T>(Map<String, dynamic> json) {
    try {
      if (T == MovieDetail) {
        return MovieDetail.fromJson(json) as T;
      }

      if (T == MovieListResponse) {
        return MovieListResponse.fromJson(json) as T;
      }
    }
    catch(e,s) {
      log(e.toString(), stackTrace: s, name: 'Parse Error');
      throw ParseError(message: e.toString());
    }

    return null;
  }

  bool isSubtype<T1, T2>() => <T1>[] is List<T2>;

}