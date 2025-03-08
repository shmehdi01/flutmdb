import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutmdb/app/utils/network_util.dart';
import 'package:meta/meta.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkInitial());

  StreamSubscription? _streamSubscription;

  void listenNetwork() {
    _streamSubscription = Connectivity().onConnectivityChanged.listen((event) {
      if (NetworkUtil.hasNetwork(event)) {
        emit(NetworkAvailable());
      }
      else {
        emit(NoNetwork());
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
