import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../config/supabase_manager.dart';
import '../services/connectivity_helper.dart';

class AuthService extends ChangeNotifier {
  GoTrueClient? get _supabaseAuth => SupabaseManager.client?.auth;
  StreamSubscription<AuthState>? _authSubscription;

  AuthService() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    if (SupabaseManager.isReady && _supabaseAuth != null) {
      // Listen to auth state changes and notify our listeners
      _authSubscription = _supabaseAuth!.onAuthStateChange.listen((data) {
        notifyListeners();
      });
    }
  }

  // Reinitialize listener when Supabase becomes available
  void reinitialize() {
    _authSubscription?.cancel();
    _initializeAuthListener();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  User? get currentUser => _supabaseAuth?.currentUser;
  Stream<AuthState>? get authStateChanges => _supabaseAuth?.onAuthStateChange;
  
  bool get isAuthenticated => currentUser != null;
  bool get isServiceAvailable => SupabaseManager.isReady && _supabaseAuth != null;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    // Check if authentication service is available
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }

    try {
      final res = await _supabaseAuth!.signInWithPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw AuthException('Request timed out. Please check your internet connection and try again.');
        },
      );

      if (res.user != null) {
        try {
          final profile = await SupabaseManager.client!
              .from('profiles')
              .select()
              .eq('id', res.user!.id)
              .single()
              .timeout(
                const Duration(seconds: 15),
                onTimeout: () {
                  throw Exception('Profile fetch timeout');
                },
              );

          if (profile['marked_for_deletion_at'] != null) {
            await SupabaseManager.client!
                .from('profiles')
                .update({'marked_for_deletion_at': null})
                .eq('id', res.user!.id);
          }
        } catch (profileError) {
          // Profile fetch failed, but user is still authenticated
          print('Profile fetch error: $profileError');
        }
        
        // Notify listeners that authentication state has changed
        notifyListeners();
      }

      return res;
    } on AuthException catch (e) {
      // Handle specific Supabase auth errors
      String errorMessage;
      switch (e.message) {
        case 'Invalid login credentials':
          errorMessage = 'Invalid email or password. Please check your credentials and try again.';
          break;
        case 'Email not confirmed':
          errorMessage = 'Please verify your email address before signing in.';
          break;
        case 'Too many requests':
          errorMessage = 'Too many login attempts. Please wait a moment and try again.';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed. Please try again.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      // Handle network and other errors
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw AuthException('Network timeout. Please check your internet connection and try again.');
      }
      throw AuthException('Network error. Please check your internet connection and try again.');
    }
  }

  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String gender,
    required String dateOfBirth,
    required String mobileNumber,
  }) async {
    // Check if authentication service is available
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }

    try {
      final res = await _supabaseAuth!.signUp(email: email, password: password).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw AuthException('Request timed out. Please check your internet connection and try again.');
        },
      );

      if (res.user != null) {
        try {
          await SupabaseManager.client!.from('profiles').insert({
            'id': res.user!.id,
            'username': username,
            'full_name': fullName,
            'gender': gender,
            'date_of_birth': dateOfBirth,
            'mobile_number': mobileNumber,
          }).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Profile creation timeout');
            },
          );
        } catch (profileError) {
          // Profile creation failed, but user account was created
          print('Profile creation error: $profileError');
          // We should still throw an error since the registration isn't complete
          if (profileError.toString().contains('timeout')) {
            throw AuthException('Account created but profile setup timed out. Please try signing in.');
          }
          throw AuthException('Account created but profile setup failed. Please contact support.');
        }
        
        // Notify listeners that authentication state has changed
        notifyListeners();
      }
      return res;
    } on AuthException catch (e) {
      // Handle specific Supabase auth errors
      String errorMessage;
      switch (e.message) {
        case 'User already registered':
          errorMessage = 'An account with this email already exists. Please sign in instead.';
          break;
        case 'Password should be at least 6 characters':
          errorMessage = 'Password must be at least 6 characters long.';
          break;
        case 'Invalid email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'Signup requires a valid password':
          errorMessage = 'Please enter a valid password.';
          break;
        default:
          errorMessage = e.message ?? 'Registration failed. Please try again.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      // Handle network and other errors
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw AuthException('Network timeout. Please check your internet connection and try again.');
      }
      throw AuthException('Network error. Please check your internet connection and try again.');
    }
  }

  Future<void> signOut() async {
    if (!isServiceAvailable) return;
    await _supabaseAuth!.signOut();
    // Notify listeners that authentication state has changed
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    // Check if authentication service is available
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }

    try {
      await _supabaseAuth!.resetPasswordForEmail(email).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw AuthException('Request timed out. Please check your internet connection and try again.');
        },
      );
    } on AuthException catch (e) {
      // Handle specific Supabase auth errors
      String errorMessage;
      switch (e.message) {
        case 'Email address not found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'Invalid email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = e.message ?? 'Password reset failed. Please try again.';
      }
      throw AuthException(errorMessage);
    } catch (e) {
      // Handle network and other errors
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw AuthException('Network timeout. Please check your internet connection and try again.');
      }
      throw AuthException('Network error. Please check your internet connection and try again.');
    }
  }

  Future<void> updateUsername({required String username}) async {
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }
    await _supabaseAuth!.updateUser(UserAttributes(data: {'username': username}));
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }
    await SupabaseManager.client!.rpc('delete_user');
    await _supabaseAuth!.signOut();
  }

  Future<void> reauthenticateUser({required String currentPassword}) async {
    if (!isServiceAvailable) {
      throw AuthException('Authentication service is not available. Please check your connection and try again.');
    }
    
    final email = _supabaseAuth!.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw Exception("User email is missing. Please log in again.");
    }
    await _supabaseAuth!.signInWithPassword(
      email: email,
      password: currentPassword,
    );
  }

  Future<void> updatePassword({required String newPassword}) async {
    await supabaseAuth.updateUser(UserAttributes(password: newPassword));
  }
}
