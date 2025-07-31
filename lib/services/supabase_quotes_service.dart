import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/motivational_quote.dart';

class SupabaseQuotesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<MotivationalQuote>> fetchMotivationalQuotes() async {
    try {
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .order('created_at', ascending: true);

      return (response as List)
          .map((quote) => MotivationalQuote.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes: $e');
    }
  }

  Future<List<MotivationalQuote>> fetchFavoriteQuotes(
    Set<String> favoriteIds,
  ) async {
    if (favoriteIds.isEmpty) return [];

    try {
      // Convert set to list for Supabase IN filter
      final idsList = favoriteIds.toList();
      final response = await _supabase
          .from('motivational_quotes')
          .select('*')
          .filter('id', 'in', idsList);

      return (response as List)
          .map((quote) => MotivationalQuote.fromSupabase(quote))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite quotes: $e');
    }
  }
}
