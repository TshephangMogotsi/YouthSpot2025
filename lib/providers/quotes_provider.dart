import 'package:flutter/material.dart';
import '../db/app_db.dart';
import '../db/models/motivational_qoutes_model.dart';
import '../services/supabase_quotes_service.dart';

class QuoteProvider with ChangeNotifier {
  List<MotivationalQoute> _quotes = [];
  bool _isLoading = true;
  final SupabaseQuotesService _quotesService = SupabaseQuotesService();
  Set<int> _favoriteIds = {};

  List<MotivationalQoute> get quotes => _quotes;
  bool get isLoading => _isLoading;

  // Getter to filter favorite quotes
  List<MotivationalQoute> get favoriteQuotes =>
      _quotes.where((quote) => quote.isFavorite).toList();

  Future<void> fetchQuotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load favorite IDs from local database first
      await _loadFavoriteIds();

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

  Future<void> _loadFavoriteIds() async {
    try {
      final favoriteQuotes = await SSIDatabase.instance.readAllFavoriteQoutes();
      _favoriteIds = favoriteQuotes.map((q) => q.id).toSet();
    } catch (e) {
      print('Error loading favorite IDs: $e');
      _favoriteIds = {};
    }
  }

  void toggleFavorite(int quoteId) {
    final quoteIndex = _quotes.indexWhere((quote) => quote.id == quoteId);
    if (quoteIndex != -1) {
      // Toggle favorite status
      _quotes[quoteIndex] = _quotes[quoteIndex].copyWith(
        isFavorite: !_quotes[quoteIndex].isFavorite,
      );

      // Update local storage
      if (_quotes[quoteIndex].isFavorite) {
        // Add to database and favorite IDs set
        _favoriteIds.add(quoteId);
        SSIDatabase.instance.insertFavoriteQoute(_quotes[quoteIndex]);
      } else {
        // Remove from database and favorite IDs set
        _favoriteIds.remove(quoteId);
        SSIDatabase.instance.deleteFavoriteQoute(quoteId);
      }

      notifyListeners(); // Notify to rebuild UI
    }
  }
}