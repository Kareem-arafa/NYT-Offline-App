import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController {
  static final ConnectivityController _singleton = ConnectivityController._internal();

  ConnectivityController._internal();

  static ConnectivityController getInstance() => _singleton;

  bool isConnected = false;

  StreamController connectionChangeController = StreamController.broadcast();

  Future<void> init() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    isInternetConnected(result);
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      isInternetConnected(result);
    });
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  bool isInternetConnected(List<ConnectivityResult>? result) {
    bool connectionResult = false;
    if (result == null) {
      connectionResult = false;
    } else {
      if (result.contains(ConnectivityResult.none)) {
        connectionResult = false;
      } else if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        connectionResult = true;
      }
    }
    isConnected = connectionResult;
    connectionChangeController.add(connectionResult);
    return connectionResult;
  }
}
