import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Release-compatible logging service for debugging production issues
class ReleaseLogger {
  static const String _logKey = 'app_logs';
  static const int _maxLogEntries = 100;

  /// Log an error with timestamp for release debugging
  static Future<void> logError(String message, {Object? error, StackTrace? stackTrace}) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] ERROR: $message';
    
    // Always log to console in debug mode
    if (kDebugMode) {
      print(logEntry);
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('Stack: $stackTrace');
    }
    
    // Store in SharedPreferences for release mode debugging
    await _storeLogs(logEntry);
  }

  /// Log info message
  static Future<void> logInfo(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] INFO: $message';
    
    if (kDebugMode) {
      print(logEntry);
    }
    
    await _storeLogs(logEntry);
  }

  /// Store logs in SharedPreferences
  static Future<void> _storeLogs(String logEntry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingLogs = prefs.getStringList(_logKey) ?? [];
      
      existingLogs.add(logEntry);
      
      // Keep only the last 100 entries to prevent storage bloat
      if (existingLogs.length > _maxLogEntries) {
        existingLogs.removeRange(0, existingLogs.length - _maxLogEntries);
      }
      
      await prefs.setStringList(_logKey, existingLogs);
    } catch (e) {
      // Fallback if SharedPreferences fails
      if (kDebugMode) {
        print('Failed to store log: $e');
      }
    }
  }

  /// Get stored logs for debugging
  static Future<List<String>> getLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_logKey) ?? [];
    } catch (e) {
      return ['Failed to retrieve logs: $e'];
    }
  }

  /// Clear stored logs
  static Future<void> clearLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_logKey);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear logs: $e');
      }
    }
  }

  /// Get logs as formatted string for sharing/debugging
  static Future<String> getLogsAsString() async {
    final logs = await getLogs();
    return logs.join('\n');
  }
}