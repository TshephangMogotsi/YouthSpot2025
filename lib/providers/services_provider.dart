import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvider with ChangeNotifier {
  List<DocumentSnapshot> _services = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> get services => _services;

  ServiceProvider() {
    _fetchServices();
  }

  void _fetchServices() {
    firestore.collection('clinicalServices').snapshots().listen((snapshot) {
      _services = snapshot.docs;
      notifyListeners();
    });
  }

  Future<bool> loadImages() async {
    // Your image loading logic here if necessary
    return true;
  }
}
