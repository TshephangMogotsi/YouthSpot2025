import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment.dart';

class SupabaseManager {
  static bool _isInitialized = false;
  static bool _initializationFailed = false;
  static String? _lastError;
  
  static bool get isInitialized => _isInitialized;
  static bool get hasError => _initializationFailed;
  static String? get lastError => _lastError;
  
  /// Initialize Supabase with retry logic and better error handling
  static Future<bool> initialize() async {
    if (_isInitialized) return true;
    if (_initializationFailed) return false;
    
    // Validate configuration
    if (!Environment.isSupabaseConfigured) {
      _lastError = 'Supabase configuration is invalid. Please check your environment variables.';
      _initializationFailed = true;
      return false;
    }
    
    // Test network connectivity first
    if (!await _testConnectivity()) {
      _lastError = 'No internet connection available. Please check your network settings and try again.';
      _initializationFailed = true;
      return false;
    }
    
    // Attempt initialization with retry logic
    for (int attempt = 1; attempt <= Environment.maxRetryAttempts; attempt++) {
      try {
        if (kDebugMode) {
          print('Attempting Supabase initialization (attempt $attempt/${Environment.maxRetryAttempts})');
        }
        
        await Supabase.initialize(
          url: Environment.supabaseUrl,
          anonKey: Environment.supabaseAnonKey,
        ).timeout(
          Environment.connectionTimeout,
          onTimeout: () => throw TimeoutException(
            'Connection timeout after ${Environment.connectionTimeout.inSeconds} seconds',
            Environment.connectionTimeout,
          ),
        );
        
        // Test the connection
        await _testSupabaseConnection();
        
        _isInitialized = true;
        _initializationFailed = false;
        _lastError = null;
        
        if (kDebugMode) {
          print('Supabase initialized successfully');
        }
        
        return true;
        
      } catch (e) {
        _lastError = _getErrorMessage(e);
        
        if (kDebugMode) {
          print('Supabase initialization attempt $attempt failed: $_lastError');
        }
        
        // Don't retry on certain types of errors
        if (_isFatalError(e)) {
          break;
        }
        
        // Wait before next attempt (except for last attempt)
        if (attempt < Environment.maxRetryAttempts) {
          await Future.delayed(Environment.retryDelay * attempt);
        }
      }
    }
    
    _initializationFailed = true;
    return false;
  }
  
  /// Test basic network connectivity
  static Future<bool> _testConnectivity() async {
    try {
      // Try to resolve a reliable DNS
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Test Supabase connection specifically
  static Future<void> _testSupabaseConnection() async {
    try {
      // Try a simple operation to test if Supabase is accessible
      final client = Supabase.instance.client;
      // This will throw if the connection is not working
      await client.auth.getUser();
    } catch (e) {
      // This is expected if user is not authenticated, but it means connection works
      if (e.toString().contains('Invalid JWT') || 
          e.toString().contains('not logged in') ||
          e.toString().contains('No session')) {
        return; // Connection is working
      }
      rethrow; // Re-throw other errors
    }
  }
  
  /// Check if an error is fatal (should not retry)
  static bool _isFatalError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('invalid') ||
           errorString.contains('unauthorized') ||
           errorString.contains('forbidden') ||
           errorString.contains('configuration');
  }
  
  /// Get user-friendly error message
  static String _getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Connection timeout. Please check your internet connection and try again.';
    }
    
    if (error is SocketException) {
      if (error.message.contains('Failed host lookup')) {
        return 'Unable to connect to server. Please check your internet connection or try again later.';
      }
      return 'Network error: ${error.message}';
    }
    
    final errorString = error.toString();
    
    if (errorString.contains('No address associated with hostname')) {
      return 'Server is temporarily unavailable. Please try again later.';
    }
    
    if (errorString.contains('Connection refused')) {
      return 'Unable to connect to server. Please try again later.';
    }
    
    if (errorString.contains('Network is unreachable')) {
      return 'No internet connection. Please check your network settings.';
    }
    
    // Return a generic but helpful message for unknown errors
    return 'Connection error. Please check your internet connection and try again.';
  }
  
  /// Retry initialization (for manual retry by user)
  static Future<bool> retryInitialization() async {
    _isInitialized = false;
    _initializationFailed = false;
    _lastError = null;
    return await initialize();
  }
  
  /// Get Supabase client safely
  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }
  
  /// Check if Supabase is ready for use
  static bool get isReady => _isInitialized && !_initializationFailed;
}