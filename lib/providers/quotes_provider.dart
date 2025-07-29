import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/app_db.dart';
import '../db/models/motivational_qoutes_model.dart';

class QuoteProvider with ChangeNotifier {
  List<MotivationalQoute> _quotes = [];
  bool _isLoading = true;
  final List<int> _viewedQuoteIds = []; // Track viewed quote IDs

  List<MotivationalQoute> get quotes => _quotes;
  bool get isLoading => _isLoading;

  // Getter to filter favorite quotes
  List<MotivationalQoute> get favoriteQuotes =>
      _quotes.where((quote) => quote.isFavorite).toList();

  Future<void> fetchQuotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await FirebaseFirestore.instance.collection('motivational_quotes').get();
      _quotes = snapshot.docs.map((doc) => MotivationalQoute(
            id: doc['id'],
            quote: doc['quote'],
            author: doc['author'],
            backgroundImage: doc['backgroundImage'],
            isFavorite: doc['isFavorite'],
          )).toList();
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int quoteId) {
    final quoteIndex = _quotes.indexWhere((quote) => quote.id == quoteId);
    if (quoteIndex != -1) {
      // Toggle favorite status
      _quotes[quoteIndex] = _quotes[quoteIndex].copyWith(
        isFavorite: !_quotes[quoteIndex].isFavorite,
      );

      // If using local storage, update the database accordingly
      if (_quotes[quoteIndex].isFavorite) {
        // Add to database
        SSIDatabase.instance.insertFavoriteQoute(_quotes[quoteIndex]);
      } else {
        // Remove from database
        SSIDatabase.instance.deleteFavoriteQoute(quoteId);
      }

      notifyListeners(); // Notify to rebuild UI
    }
  }

  void viewQuote(int quoteId) {
    if (!_viewedQuoteIds.contains(quoteId)) {
      _viewedQuoteIds.add(quoteId);
      notifyListeners();
    }
  }
}