import 'dart:io';

/// Simple connectivity helper to check network status
class ConnectivityHelper {
  /// Check if the device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if Supabase endpoint is reachable
  static Future<bool> canReachSupabase() async {
    try {
      final result = await InternetAddress.lookup('xcznelduagrrfzwkcrrs.supabase.co')
          .timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get network diagnostic information
  static Future<Map<String, bool>> getNetworkDiagnostics() async {
    return {
      'hasInternet': await hasInternetConnection(),
      'canReachSupabase': await canReachSupabase(),
    };
  }

  /// Get user-friendly error message based on network status
  static Future<String> getConnectionErrorMessage() async {
    final diagnostics = await getNetworkDiagnostics();
    
    if (!diagnostics['hasInternet']!) {
      return 'No internet connection. Please check your network settings and try again.';
    } else if (!diagnostics['canReachSupabase']!) {
      return 'Cannot reach authentication servers. Please try again later.';
    } else {
      return 'Network error. Please check your connection and try again.';
    }
  }
}