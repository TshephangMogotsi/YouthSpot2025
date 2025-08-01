import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class AuthService extends ChangeNotifier {
  final GoTrueClient supabaseAuth = Supabase.instance.client.auth;
  late StreamSubscription<AuthState> _authSubscription;

  AuthService() {
    // Listen to auth state changes and notify our listeners
    _authSubscription = supabaseAuth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  // Helper method to check if Supabase is properly initialized
  bool get _isSupabaseInitialized {
    try {
      return Supabase.instance.client.supabaseUrl.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  User? get currentUser => supabaseAuth.currentUser;
  Stream<AuthState> get authStateChanges => supabaseAuth.onAuthStateChange;
  
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    // Check if Supabase is properly initialized
    if (!_isSupabaseInitialized) {
      throw AuthException('Authentication service is not available. Please restart the app.');
    }

    try {
      final res = await supabaseAuth.signInWithPassword(
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
          final profile = await Supabase.instance.client
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
            await Supabase.instance.client
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
    // Check if Supabase is properly initialized
    if (!_isSupabaseInitialized) {
      throw AuthException('Authentication service is not available. Please restart the app.');
    }

    try {
      final res = await supabaseAuth.signUp(email: email, password: password).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw AuthException('Request timed out. Please check your internet connection and try again.');
        },
      );

      if (res.user != null) {
        try {
          await Supabase.instance.client.from('profiles').insert({
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
    await supabaseAuth.signOut();
    // Notify listeners that authentication state has changed
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    await supabaseAuth.resetPasswordForEmail(email);
  }

  Future<void> updateUsername({required String username}) async {
    await supabaseAuth.updateUser(UserAttributes(data: {'username': username}));
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    await Supabase.instance.client.rpc('delete_user');
    await supabaseAuth.signOut();
  }

  Future<void> reauthenticateUser({required String currentPassword}) async {
    final email = supabaseAuth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw Exception("User email is missing. Please log in again.");
    }
    await supabaseAuth.signInWithPassword(
      email: email,
      password: currentPassword,
    );
  }

  Future<void> updatePassword({required String newPassword}) async {
    await supabaseAuth.updateUser(UserAttributes(password: newPassword));
  }
}
