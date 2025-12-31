import 'dart:io';
import 'package:dio/dio.dart';

/// Service to check network connectivity and status
class NetworkService {
  final Dio _dio = Dio();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      // Try to lookup Google's DNS
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check if a specific host is reachable
  Future<bool> isHostReachable(String host) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Ping the exchange rate API to check if it's available
  Future<bool> isExchangeRateApiAvailable() async {
    try {
      final response = await _dio.get(
        'https://v6.exchangerate-api.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      return false;
    }
  }

  /// Get network status with details
  Future<NetworkStatus> getNetworkStatus() async {
    final hasInternet = await hasInternetConnection();

    if (!hasInternet) {
      return NetworkStatus(
        isConnected: false,
        connectionType: ConnectionType.none,
        message: 'No internet connection',
      );
    }

    final apiAvailable = await isExchangeRateApiAvailable();

    return NetworkStatus(
      isConnected: true,
      connectionType: ConnectionType.wifi, // Simplified - could detect actual type
      message: apiAvailable ? 'Connected' : 'API unavailable',
      isApiAvailable: apiAvailable,
    );
  }
}

/// Network connection status
class NetworkStatus {
  final bool isConnected;
  final ConnectionType connectionType;
  final String message;
  final bool isApiAvailable;

  NetworkStatus({
    required this.isConnected,
    required this.connectionType,
    required this.message,
    this.isApiAvailable = true,
  });

  bool get canFetchRates => isConnected && isApiAvailable;
}

/// Connection type enum
enum ConnectionType {
  none,
  wifi,
  mobile,
}
