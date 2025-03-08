import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {

  static Future<bool> isNetworkConnected() async {
    final list = await Connectivity().checkConnectivity();
    return hasNetwork(list);
  }

  static bool hasNetwork(List<ConnectivityResult> list) {
    return list.length == 1 && list.contains(ConnectivityResult.none) == false;
  }
}
