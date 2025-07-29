import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final GoTrueClient supabaseAuth = Supabase.instance.client.auth;

  User? get currentUser => supabaseAuth.currentUser;
  Stream<AuthState> get authStateChanges => supabaseAuth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final res = await supabaseAuth.signInWithPassword(email: email, password: password);
    notifyListeners();
    return res;
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
    final res = await supabaseAuth.signUp(email: email, password: password);

    if (res.user != null) {
      await Supabase.instance.client.from('profiles').insert({
        'id': res.user!.id,
        'username': username,
        'full_name': fullName,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'mobile_number': mobileNumber,
      });
    }
    notifyListeners();
    return res;
  }

  Future<void> signOut() async {
    await supabaseAuth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    await supabaseAuth.resetPasswordForEmail(email);
  }

  Future<void> updateUsername({required String username}) async {
    await supabaseAuth.updateUser(UserAttributes(data: {'username': username}));
    notifyListeners();
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    await Supabase.instance.client.rpc('delete_user');
    await supabaseAuth.signOut();
    notifyListeners();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String newPassword,
    required String email,
    required String currentPassword,
  }) async {
    await supabaseAuth.updateUser(UserAttributes(password: newPassword));
    notifyListeners();
  }
}
