import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityController {
  /// Private constructor
  ConnectivityController._();

  /// Static instance
  static final ConnectivityController instance = ConnectivityController._();

  /// Notifier for connection status
  ValueNotifier<bool> isConnected = ValueNotifier(true);

  /// Initialize connectivity monitoring
  Future<void> init() async {
    final result = await Connectivity().checkConnectivity();
    isInternetConnected(result);
    Connectivity().onConnectivityChanged.listen(isInternetConnected);
  }

  /// Handle connectivity changes
  bool isInternetConnected(List<ConnectivityResult>? result) {
    if (result!.contains(ConnectivityResult.none)) {
      isConnected.value = false;
      return false;
    } else
    //  if (result.contains(ConnectivityResult.mobile) ||
    //     result.contains(ConnectivityResult.wifi) )
    {
      isConnected.value = true;
      return true;
    }
    // return false;
  }
}
