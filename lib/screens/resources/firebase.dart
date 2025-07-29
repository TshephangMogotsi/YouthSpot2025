import 'package:cloud_firestore/cloud_firestore.dart';

import 'file_model.dart';

Future<List<PDFDocument>> fetchAllDocuments() async {
  List<PDFDocument> pdfDocuments = [];

  // Define the sub-collections manually
  List<Map<String, String>> subCollections = [
    {'parent': 'Health', 'child': 'documents'},
    {'parent': 'Ready to Work', 'child': 'entrepreneurshipskills'},
    {'parent': 'Ready to Work', 'child': 'peopleskills'},
    {'parent': 'Ready to Work', 'child': 'workskills'},
    {'parent': 'Ready to Work', 'child': 'moneyskills'},
    {'parent': 'Relationships', 'child': 'documents'}
  ];

  // Loop through each parent-child collection pair and fetch documents
  for (var subCollection in subCollections) {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('resources')
        .doc(subCollection['parent'])
        .collection(subCollection['child']!)
        .get();

    for (var doc in querySnapshot.docs) {
      pdfDocuments.add(PDFDocument.fromFirestore(doc));
    }
  }

  return pdfDocuments;
}
