import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/models/articles_model.dart';

class ArticlesProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _allArticles = [];
  bool _isLoading = false;
  final SupabaseClient supabase = Supabase.instance.client;

  List<Article> get articles => _articles;
  List<Article> get allArticles => _allArticles;
  bool get isLoading => _isLoading;

  ArticlesProvider() {
    _isLoading = true; // Start with loading state
    loadInitialArticles();
  }

  Future<void> loadInitialArticles() async {
    if (_articles.isEmpty) {
      // Only set loading if not already loading
      if (!_isLoading) {
        _isLoading = true;
        notifyListeners();
      }
      
      try {
        // Add minimum loading time to ensure shimmer is visible
        final loadingFuture = supabase
            .from('articles')
            .select('*, authors(*), categories(*)')
            .limit(10);
        
        final minLoadingTime = Future.delayed(const Duration(milliseconds: 800));
        
        final results = await Future.wait([loadingFuture, minLoadingTime]);
        final response = results[0];
        
        _articles = (response as List)
            .map((article) => Article.fromMap(article))
            .toList();
      } catch (e) {
        // Handle error - for now just log it
        print('Error loading articles: $e');
        // Still set empty articles list to prevent infinite loading
        _articles = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchAllArticles() async {
    if (_allArticles.isEmpty) {
      final response =
          await supabase.from('articles').select('*, authors(*), categories(*)');
      _allArticles = (response as List)
          .map((article) => Article.fromMap(article))
          .toList();
      notifyListeners();
    }
  }
}
