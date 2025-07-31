import 'package:supabase_flutter/supabase_flutter.dart';
import '../motivational_quotes/models/motivational_quote_model.dart';

class SupabaseQuotesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<MotivationalQoute>> fetchMotivationalQuotes() async {
    try {
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .order('id');

      return (response as List)
          .map((quote) => MotivationalQoute.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }

  Future<List<MotivationalQoute>> fetchFavoriteQuotes(List<int> favoriteIds) async {
    if (favoriteIds.isEmpty) return [];
    
    try {
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .in_('id', favoriteIds);

      return (response as List)
          .map((quote) => MotivationalQoute.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite quotes: $e');
    }
  }
}