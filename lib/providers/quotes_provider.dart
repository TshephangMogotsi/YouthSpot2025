import 'package:flutter/material.dart';
import '../models/motivational_quote.dart';
import '../services/supabase_quotes_service.dart';
import '../services/favorites_service.dart';

class QuoteProvider with ChangeNotifier {
  List<MotivationalQuote> _quotes = [];
  bool _isLoading = true;
  final SupabaseQuotesService _quotesService = SupabaseQuotesService();
  Set<String> _favoriteIds = {};

  List<MotivationalQuote> get quotes => _quotes;
  bool get isLoading => _isLoading;

  // Getter to filter favorite quotes
  List<MotivationalQuote> get favoriteQuotes =>
      _quotes.where((quote) => quote.isFavorite).toList();

  Future<void> fetchQuotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load favorite IDs from SharedPreferences
      _favoriteIds = await FavoritesService.getFavoriteIds();

      // Fetch quotes from Supabase
      final quotesFromSupabase = await _quotesService.fetchMotivationalQuotes();
      
      // Update favorite status based on local storage
      _quotes = quotesFromSupabase.map((quote) {
        return quote.copyWith(isFavorite: _favoriteIds.contains(quote.id));
      }).toList();
      
    } catch (e) {
      print('Error fetching quotes: $e');
      _quotes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String quoteId) async {
    final quoteIndex = _quotes.indexWhere((quote) => quote.id == quoteId);
    if (quoteIndex != -1) {
      // Toggle favorite status
      final isCurrentlyFavorite = _quotes[quoteIndex].isFavorite;
      _quotes[quoteIndex] = _quotes[quoteIndex].copyWith(
        isFavorite: !isCurrentlyFavorite,
      );

      // Update local storage
      if (!isCurrentlyFavorite) {
        // Add to favorites
        _favoriteIds.add(quoteId);
        await FavoritesService.addFavorite(quoteId);
      } else {
        // Remove from favorites
        _favoriteIds.remove(quoteId);
        await FavoritesService.removeFavorite(quoteId);
      }

      notifyListeners(); // Notify to rebuild UI
    }
  }
}