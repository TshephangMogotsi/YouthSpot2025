import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountProvider with ChangeNotifier {
  String _userFullName = '';
  bool _isLoading = false;
  String? _error;

  String get userFullName => _userFullName;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AccountProvider() {
    _isLoading = true; // Start with loading state
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    // Only load if user name is empty (implement caching like ArticlesProvider)
    if (_userFullName.isEmpty) {
      // Only set loading if not already loading
      if (!_isLoading) {
        _isLoading = true;
        _error = null;
        notifyListeners();
      }

      try {
        final currentUser = Supabase.instance.client.auth.currentUser;
        if (currentUser == null) {
          _userFullName = '';
          return;
        }

        final response = await Supabase.instance.client
            .from('profiles')
            .select('full_name')
            .eq('id', currentUser.id)
            .single();

        _userFullName = response['full_name'] ?? '';
      } catch (e) {
        _error = 'Error loading user profile: ${e.toString()}';
        print('Error loading user profile: $e');
        // Set empty name on error to prevent infinite loading
        _userFullName = '';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshUserProfile() async {
    _userFullName = '';
    _error = null;
    await loadUserProfile();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearUserData() {
    _userFullName = '';
    _error = null;
    notifyListeners();
  }
}