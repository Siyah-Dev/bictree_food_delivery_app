
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
  final connectivity = Connectivity();

  // Read the current connection status when the provider starts.
  yield await connectivity.checkConnectivity();

  // Continue listening for network changes.
  yield* connectivity.onConnectivityChanged;
});
