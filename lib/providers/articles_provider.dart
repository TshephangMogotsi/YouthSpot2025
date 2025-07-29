import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../db/models/articles_model.dart';


class ArticlesProvider with ChangeNotifier {
  List<Article> _articles = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Article> get articles => _articles;

  ArticlesProvider() {
    loadInitialArticles();
  }

  void _listenForArticles() {
    firestore.collection('articles').snapshots().listen((snapshot) {
      _articles = snapshot.docs.map((doc) => Article.fromSnapshot(doc)).toList();
      notifyListeners();
    });
  }

  void loadInitialArticles() async {
    if (_articles.isEmpty) {
      final snapshot = await firestore.collection('articles').limit(3).get();
      _articles = snapshot.docs.map((doc) => Article.fromSnapshot(doc)).toList();
      notifyListeners();
      _listenForArticles();
    }
  }

}
