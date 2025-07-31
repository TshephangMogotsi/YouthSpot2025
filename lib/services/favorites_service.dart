import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_quotes';

  // Get all favorite quote IDs
  static Future<Set<String>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
      return favoritesList.toSet();
    } catch (e) {
      print('Error loading favorite IDs: $e');
      return {};
    }
  }

  // Add a quote ID to favorites
  static Future<void> addFavorite(String quoteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteIds();
      favoriteIds.add(quoteId);
      await prefs.setStringList(_favoritesKey, favoriteIds.toList());
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Remove a quote ID from favorites
  static Future<void> removeFavorite(String quoteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = await getFavoriteIds();
      favoriteIds.remove(quoteId);
      await prefs.setStringList(_favoritesKey, favoriteIds.toList());
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Check if a quote is favorited
  static Future<bool> isFavorite(String quoteId) async {
    final favoriteIds = await getFavoriteIds();
    return favoriteIds.contains(quoteId);
  }
}