import 'package:flutter/foundation.dart';

class Environment {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xcznelduagrifzwkcrrs.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY', 
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhjem5lbGR1YWdycmZ6d2tjcnJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3ODkxMjAsImV4cCI6MjA2NTM2NTEyMH0.Rmp0pnQEc7RRW80oU-MI_OwnEzwJl0v0niyZHIcu8Qw',
  );

  // Network Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Debug flags
  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  
  // Validation
  static bool get isSupabaseConfigured => 
      supabaseUrl.isNotEmpty && 
      supabaseAnonKey.isNotEmpty &&
      !supabaseUrl.contains('example') &&
      !supabaseAnonKey.contains('your-anon-key');
}