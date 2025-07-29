import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id; // Add the id field
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final String author;

  Article({
    required this.id,  // Make id required
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.author,
  });

  factory Article.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Article(
      id: snapshot.id,  // Use Firestore document ID as the article ID
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image'] ?? '',
      author: data['author'] ?? '',
    );
  }
}
