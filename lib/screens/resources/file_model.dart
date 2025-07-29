import 'package:cloud_firestore/cloud_firestore.dart';

class PDFDocument {
  final String name;
  final String url;
  final String category;
  final String? subcategory;

  PDFDocument({
    required this.name,
    required this.url,
    required this.category,
    this.subcategory,
  });

  // Factory method to create a PDFDocument from Firestore
  factory PDFDocument.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PDFDocument(
      name: data['name'] ?? '',
      url: data['url'] ?? '',
      category: data['category'] ?? '', // Ensure category field is fetched
      subcategory: data['subcategory'], // Subcategory might be null
    );
  }
}
