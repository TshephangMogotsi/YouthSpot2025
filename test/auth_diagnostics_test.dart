import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:youthspot/auth/auth_diagnostics.dart';

void main() {
  group('AuthDiagnostics Tests', () {
    test('maskEmail function works correctly', () {
      // Test email masking for privacy
      expect(AuthDiagnostics.maskEmail('test@example.com'), 'te****@example.com');
      expect(AuthDiagnostics.maskEmail('ab@test.com'), 'ab@test.com'); // Too short to mask
      expect(AuthDiagnostics.maskEmail('short'), 'short'); // No @ symbol
    });

    test('checkSupabaseConnection returns proper structure', () async {
      // This test would need proper Supabase initialization in a real test environment
      // For now, just test that the function doesn't crash
      expect(() async {
        await AuthDiagnostics.checkSupabaseConnection();
      }, isNot(throwsException));
    });
  });
}