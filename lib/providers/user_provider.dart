import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  // UserModel removed - app now uses Supabase directly without user model

  // Fetch user method removed - auth handled directly by Supabase AuthService
  Future<void> fetchUser() async {
    // This method is kept for backward compatibility but does nothing
    // Auth is now handled by AuthService using Supabase
  }

  bool get isUserFetched => true; // Always return true since auth is handled by Supabase

  // Update user method removed - user updates handled directly via Supabase
  Future<void> updateUser(Map<String, dynamic> userData) async {
    // This method is kept for backward compatibility but does nothing
    // User updates are now handled directly via Supabase client calls
  }

  // User position method removed - leaderboard functionality handled elsewhere
  Future<int?> fetchUserPosition() async {
    // This method is kept for backward compatibility but returns null
    // Leaderboard functionality should be handled via LeaderboardProvider
    return null;
  }
}