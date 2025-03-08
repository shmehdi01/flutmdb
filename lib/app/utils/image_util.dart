import 'package:flutmdb/app/utils/constant.dart';

class ImageUtil {

  static String backdropUrl(String path) {
    return "$kBaseImageUrl/original/$path";
  }

  static String posterUrl(String path, {String size = "w440_and_h660_face"}) {
    return "$kBaseImageUrl/$size/$path";
  }
}