import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file_model.dart';

class DocumentProvider extends ChangeNotifier {
  // Categories for the GridView
  final List<String> categories = [
    'health',
    'ready_to_work',
    'relationships',
  ];

  // Subcategories under "Ready2work"
  final List<String> ready2workSubcategories = [
    'entrepreneurship_skills',
    'people_skills',
    'work_skills',
    'money_skills',
  ];

  List<PDFDocument> documents = []; // Holds all documents from Firestore
  String? selectedCategory = 'All'; // Default selection for "All"
  String? selectedSubcategory;

  bool isLoading = true; // Add a loading state

  DocumentProvider() {
    fetchAllDocuments();
  }

  // Function to fetch all documents from the 'resources' collection in Firestore
  Future<void> fetchAllDocuments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('resources') // Assuming 'resources' is the collection name
          .get();

      // Convert Firestore documents to PDFDocument model
      documents = querySnapshot.docs
          .map((doc) => PDFDocument.fromFirestore(doc))
          .toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching documents: $e');
      isLoading = false;
    }
  }

  // Function to set the selected category
  void setSelectedCategory(String? category) {
    selectedCategory = category;
    selectedSubcategory = null; // Reset subcategory when changing the main category
    notifyListeners();
  }

  // Function to set the selected subcategory
  void setSelectedSubcategory(String? subcategory) {
    selectedSubcategory = subcategory;
    notifyListeners();
  }

  // Get filtered documents based on the selected filter (category or subcategory)
  List<PDFDocument> getFilteredDocuments() {
    if (selectedCategory == 'All') {
      // If "All" is selected, return all documents
      return documents;
    } else if (selectedCategory == 'ready_to_work') {
      // Filter documents by "ready_to_work" category, further filtered by subcategory if one is selected
      return documents
          .where((doc) =>
              doc.category == 'ready_to_work' &&
              (selectedSubcategory == null || doc.subcategory == selectedSubcategory))
          .toList();
    } else {
      // Filter by other categories like 'health' or 'relationships'
      return documents.where((doc) => doc.category == selectedCategory).toList();
    }
  }
}
