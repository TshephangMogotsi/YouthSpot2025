import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/db/models/resource_model.dart';
import 'package:youthspot/main.dart';

class ResourceService {
  Future<List<ResourceCategory>> fetchCategories() async {
    final response = await supabase.from('resource_categories').select();
    final List<dynamic> data = response;
    return data.map((e) => ResourceCategory.fromMap(e)).toList();
  }

  Future<List<ResourceSubcategory>> fetchSubcategories(String categoryId) async {
    final response = await supabase
        .from('resource_subcategories')
        .select()
        .eq('category_id', categoryId);
    final List<dynamic> data = response;
    return data.map((e) => ResourceSubcategory.fromMap(e)).toList();
  }

  Future<List<Resource>> fetchResources({
    String? categoryId,
    String? subcategoryId,
  }) async {
    var query = supabase.from('resources').select();

    if (subcategoryId != null) {
      query = query.eq('subcategory_id', subcategoryId);
    } else if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query;
    final List<dynamic> data = response;
    return data.map((e) => Resource.fromMap(e)).toList();
  }
}
