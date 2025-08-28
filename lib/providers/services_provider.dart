import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../db/models/service_model.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];
  bool _isLoading = false;
  final SupabaseClient supabase = Supabase.instance.client;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;

  ServiceProvider() {
    _isLoading = true; // Start with loading state
    loadInitialServices();
  }

  Future<void> loadInitialServices() async {
    if (_services.isEmpty) {
      // Only set loading if not already loading
      if (!_isLoading) {
        _isLoading = true;
        notifyListeners();
      }
      
      try {
        // Add minimum loading time to ensure shimmer is visible
        final loadingFuture = supabase
            .from('services')
            .select();
        
        final minLoadingTime = Future.delayed(const Duration(milliseconds: 800));
        
        final results = await Future.wait([loadingFuture, minLoadingTime]);
        final response = results[0];
        
        _services = (response as List)
            .map((service) => Service.fromMap(service))
            .toList();
      } catch (e) {
        // Handle error - for now just log it
        print('Error loading services: $e');
        // Still set empty services list to prevent infinite loading
        _services = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> loadImages() async {
    // Your image loading logic here if necessary
    return true;
  }
}
