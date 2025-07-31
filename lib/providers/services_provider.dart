import 'package:flutter/material.dart';
// Firebase import removed
// import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvider with ChangeNotifier {
  List<dynamic> _services = []; // Changed from DocumentSnapshot to dynamic
  // final FirebaseFirestore firestore = FirebaseFirestore.instance; // Firebase removed

  List<dynamic> get services => _services;

  ServiceProvider() {
    _fetchServices();
  }

  void _fetchServices() {
    // Firebase functionality removed - implement with Supabase or other backend
    print('Firebase Firestore removed - _fetchServices method needs reimplementation');
    // firestore.collection('clinicalServices').snapshots().listen((snapshot) {
    //   _services = snapshot.docs;
    //   notifyListeners();
    // });
  }

  Future<bool> loadImages() async {
    // Your image loading logic here if necessary
    return true;
  }
}
