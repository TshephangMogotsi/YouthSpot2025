import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quotes_model.dart';

class SupabaseQuotesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<QuotesModel>> fetchMotivationalQuotes() async {
    try {
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .order('id');

      return (response as List)
          .map((quote) => QuotesModel.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }

  Future<List<QuotesModel>> fetchFavoriteQuotes(List<int> favoriteIds) async {
    if (favoriteIds.isEmpty) return [];
    
    try {
      // Convert list to comma-separated string for Supabase IN filter
      final idsString = favoriteIds.join(',');
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .filter('id', 'in', '($idsString)');

      return (response as List)
          .map((quote) => QuotesModel.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite quotes: $e');
    }
  }
}