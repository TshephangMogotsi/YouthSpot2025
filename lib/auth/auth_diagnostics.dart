import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

/// Diagnostic utilities for debugging authentication issues in release builds
class AuthDiagnostics {
  static final GoTrueClient _auth = Supabase.instance.client.auth;
  
  /// Check if Supabase is properly configured and accessible
  static Future<Map<String, dynamic>> checkSupabaseConnection() async {
    final results = <String, dynamic>{};
    
    try {
      // Check Supabase client initialization
      results['supabase_initialized'] = true;
      results['supabase_url'] = Supabase.instance.client.supabaseUrl;
      results['auth_client_available'] = _auth != null;
      
      // Check network connectivity to Supabase
      final client = HttpClient();
      final uri = Uri.parse('${Supabase.instance.client.supabaseUrl}/auth/v1/health');
      
      try {
        final request = await client.getUrl(uri).timeout(const Duration(seconds: 10));
        final response = await request.close().timeout(const Duration(seconds: 10));
        results['supabase_reachable'] = response.statusCode == 200;
        results['supabase_status_code'] = response.statusCode;
        client.close();
      } catch (e) {
        results['supabase_reachable'] = false;
        results['supabase_error'] = e.toString();
        client.close();
      }
      
      // Check app configuration
      results['app_identifier'] = 'com.example.youthspot';
      results['is_debug_mode'] = kDebugMode;
      results['is_release_mode'] = kReleaseMode;
      results['platform'] = Platform.operatingSystem;
      
    } catch (e) {
      results['error'] = e.toString();
      results['supabase_initialized'] = false;
    }
    
    return results;
  }
  
  /// Test password reset functionality with detailed logging
  static Future<Map<String, dynamic>> testPasswordReset(String email) async {
    final results = <String, dynamic>{};
    final timestamp = DateTime.now().toIso8601String();
    
    debugPrint('=== YouthSpot Password Reset Test - $timestamp ===');
    
    try {
      // First check connection
      final connectionTest = await checkSupabaseConnection();
      results['connection_test'] = connectionTest;
      
      debugPrint('YouthSpot: Connection test completed: $connectionTest');
      
      if (connectionTest['supabase_reachable'] != true) {
        results['success'] = false;
        results['error'] = 'Supabase is not reachable';
        return results;
      }
      
      // Attempt password reset
      debugPrint('YouthSpot: Attempting password reset for: ${maskEmail(email)}');
      
      final stopwatch = Stopwatch()..start();
      
      await _auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb 
          ? null 
          : 'com.example.youthspot://reset-password',
      ).timeout(const Duration(seconds: 30));
      
      stopwatch.stop();
      
      results['success'] = true;
      results['duration_ms'] = stopwatch.elapsedMilliseconds;
      results['timestamp'] = timestamp;
      
      debugPrint('YouthSpot: Password reset request completed successfully in ${stopwatch.elapsedMilliseconds}ms');
      
    } catch (e) {
      results['success'] = false;
      results['error'] = e.toString();
      results['error_type'] = e.runtimeType.toString();
      results['timestamp'] = timestamp;
      
      debugPrint('YouthSpot: Password reset failed: $e');
      
      // Additional error analysis
      if (e.toString().contains('XMLHttpRequest')) {
        results['likely_cause'] = 'Network request blocked - check network security config';
      } else if (e.toString().contains('timeout')) {
        results['likely_cause'] = 'Network timeout - check internet connection';
      } else if (e.toString().contains('SocketException')) {
        results['likely_cause'] = 'Network connectivity issue';
      } else if (e is AuthException) {
        results['likely_cause'] = 'Supabase authentication error';
        results['auth_error_code'] = (e as AuthException).statusCode;
      } else {
        results['likely_cause'] = 'Unknown error - check logs';
      }
    }
    
    debugPrint('=== YouthSpot Password Reset Test Complete ===');
    return results;
  }
  
  /// Mask email for logging privacy
  static String maskEmail(String email) {
    if (email.length <= 4) return email;
    final atIndex = email.indexOf('@');
    if (atIndex == -1) return email;
    
    final username = email.substring(0, atIndex);
    final domain = email.substring(atIndex);
    
    if (username.length <= 2) return email;
    
    final maskedUsername = '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$maskedUsername$domain';
  }
  
  /// Print diagnostic information to debug console
  static void printDiagnostics(Map<String, dynamic> results) {
    debugPrint('=== YouthSpot Auth Diagnostics ===');
    results.forEach((key, value) {
      debugPrint('$key: $value');
    });
    debugPrint('=================================');
  }
}