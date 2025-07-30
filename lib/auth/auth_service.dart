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
    final res = await supabaseAuth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', res.user!.id)
          .single();

      if (profile['marked_for_deletion_at'] != null) {
        await Supabase.instance.client
            .from('profiles')
            .update({'marked_for_deletion_at': null})
            .eq('id', res.user!.id);
      }
    }

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
    notifyListeners();
  }
}
