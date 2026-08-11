import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    return true;
  }
}