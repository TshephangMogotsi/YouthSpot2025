import 'dart:io';
import '../services/release_logger.dart';

/// Network connectivity service for checking internet connection
class NetworkConnectivityService {
  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to lookup Google's DNS - fast and reliable
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      final hasConnection =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      await ReleaseLogger.logInfo(
        'Internet connectivity check: $hasConnection',
      );
      return hasConnection;
    } catch (e) {
      await ReleaseLogger.logError(
        'Internet connectivity check failed',
        error: e,
      );
      return false;
    }
  }

  /// Check if Supabase endpoint is reachable
  static Future<bool> canReachSupabase() async {
    try {
      // Extract domain from Supabase URL
      const supabaseUrl = "https://xcznelduagrrfzwkcrrs.supabase.co";
      final uri = Uri.parse(supabaseUrl);

      final result = await InternetAddress.lookup(
        uri.host,
      ).timeout(const Duration(seconds: 10));

      final canReach = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      await ReleaseLogger.logInfo('Supabase reachability check: $canReach');
      return canReach;
    } catch (e) {
      await ReleaseLogger.logError(
        'Supabase reachability check failed',
        error: e,
      );
      return false;
    }
  }

  /// Comprehensive network check before API calls
  static Future<NetworkStatus> checkNetworkStatus() async {
    final hasInternet = await hasInternetConnection();

    if (!hasInternet) {
      return NetworkStatus(
        isConnected: false,
        canReachSupabase: false,
        errorMessage:
            'No internet connection detected. Please check your network settings and try again.',
      );
    }

    final supabaseReachable = await canReachSupabase();

    if (!supabaseReachable) {
      return NetworkStatus(
        isConnected: true,
        canReachSupabase: false,
        errorMessage:
            'Cannot reach authentication servers. Please check your internet connection and try again.',
      );
    }

    return NetworkStatus(
      isConnected: true,
      canReachSupabase: true,
      errorMessage: null,
    );
  }
}

/// Network status result
class NetworkStatus {
  final bool isConnected;
  final bool canReachSupabase;
  final String? errorMessage;

  NetworkStatus({
    required this.isConnected,
    required this.canReachSupabase,
    this.errorMessage,
  });

  bool get isFullyConnected => isConnected && canReachSupabase;
}
