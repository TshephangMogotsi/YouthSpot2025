import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../db/models/service_model.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];
  bool _isLoading = false;
  String? _error;
  final SupabaseClient supabase = Supabase.instance.client;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  ServiceProvider() {
    _isLoading = true; // Start with loading state
    loadInitialServices();
  }

  Future<void> loadInitialServices() async {
    if (_services.isEmpty) {
      // Only set loading if not already loading
      if (!_isLoading) {
        _isLoading = true;
        _error = null;
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
        _error = null;
      } catch (e) {
        // Handle error - set error message for user
        print('Error loading services: $e');
        _error = 'Unable to load services';
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

  Future<void> retry() async {
    _services = [];
    _error = null;
    await loadInitialServices();
  }
}
