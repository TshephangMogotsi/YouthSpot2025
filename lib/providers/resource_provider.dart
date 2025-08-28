import 'package:flutter/material.dart';
import '../db/models/resource_model.dart';
import '../services/resource_service.dart';

class ResourceProvider with ChangeNotifier {
  List<ResourceCategory> _categories = [];
  List<Resource> _allResources = [];
  List<ResourceSubcategory> _subcategories = [];
  bool _isLoading = false;
  final ResourceService _resourceService = ResourceService();

  List<ResourceCategory> get categories => _categories;
  List<Resource> get allResources => _allResources;
  List<ResourceSubcategory> get subcategories => _subcategories;
  bool get isLoading => _isLoading;

  ResourceProvider() {
    _isLoading = true; // Start with loading state
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    if (_categories.isEmpty && _allResources.isEmpty) {
      // Only set loading if not already loading
      if (!_isLoading) {
        _isLoading = true;
        notifyListeners();
      }
      
      try {
        // Add minimum loading time to ensure shimmer is visible if needed
        final loadingFuture = Future.wait([
          _resourceService.fetchCategories(),
          _resourceService.fetchResources(),
        ]);
        
        final minLoadingTime = Future.delayed(const Duration(milliseconds: 800));
        
        final results = await Future.wait([loadingFuture, minLoadingTime]);
        final dataResults = results[0] as List;
        
        _categories = dataResults[0] as List<ResourceCategory>;
        _allResources = dataResults[1] as List<Resource>;
      } catch (e) {
        // Handle error - for now just log it
        print('Error loading resources: $e');
        // Still set empty lists to prevent infinite loading
        _categories = [];
        _allResources = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchSubcategories(String categoryId) async {
    try {
      final subcategories = await _resourceService.fetchSubcategories(categoryId);
      _subcategories = subcategories;
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error loading subcategories: $e');
    }
  }

  void clearSubcategories() {
    _subcategories = [];
    notifyListeners();
  }

  List<Resource> getFilteredResources({
    ResourceCategory? selectedCategory,
    ResourceSubcategory? selectedSubcategory,
  }) {
    List<Resource> resources = _allResources;

    if (selectedCategory != null) {
      resources = resources.where((r) => r.categoryId == selectedCategory.id).toList();
    }

    if (selectedSubcategory != null) {
      resources = resources.where((r) => r.subcategoryId == selectedSubcategory.id).toList();
    }

    return resources;
  }

  Future<void> refreshData() async {
    _categories = [];
    _allResources = [];
    _subcategories = [];
    await loadInitialData();
  }
}