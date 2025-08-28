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
    loadInitialArticles();
  }

  Future<void> loadInitialArticles() async {
    if (_articles.isEmpty) {
      _isLoading = true;
      notifyListeners();
      
      final response = await supabase
          .from('articles')
          .select('*, authors(*), categories(*)')
          .limit(10);
      _articles = (response as List)
          .map((article) => Article.fromMap(article))
          .toList();
      
      _isLoading = false;
      notifyListeners();
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
