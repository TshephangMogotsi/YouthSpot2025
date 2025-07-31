import 'package:flutter_test/flutter_test.dart';
import '../lib/models/motivational_quote.dart';
import '../lib/services/supabase_quotes_service.dart';
import '../lib/services/favorites_service.dart';

void main() {
  group('Motivational Quote Model Tests', () {
    test('MotivationalQuote.fromSupabase creates correct object', () {
      final jsonData = {
        'id': '1',
        'author': 'Test Author',
        'quote': 'Test Quote',
        'background_image_url': 'https://example.com/image.jpg',
        'created': '2024-01-01T00:00:00Z',
      };

      final quote = MotivationalQuote.fromSupabase(jsonData);

      expect(quote.id, '1');
      expect(quote.author, 'Test Author');
      expect(quote.quote, 'Test Quote');
      expect(quote.backgroundImageUrl, 'https://example.com/image.jpg');
      expect(quote.isFavorite, false);
    });

    test('MotivationalQuote.fromSupabase handles qoute spelling', () {
      final jsonData = {
        'id': '1',
        'author': 'Test Author',
        'qoute': 'Test Quote with qoute spelling',
        'background_image_url': 'https://example.com/image.jpg',
        'created': '2024-01-01T00:00:00Z',
      };

      final quote = MotivationalQuote.fromSupabase(jsonData);

      expect(quote.quote, 'Test Quote with qoute spelling');
    });

    test('MotivationalQuote.copyWith updates favorite status', () {
      final quote = MotivationalQuote(
        id: '1',
        author: 'Test Author',
        quote: 'Test Quote',
        backgroundImageUrl: 'https://example.com/image.jpg',
        created: DateTime.now(),
      );

      final updatedQuote = quote.copyWith(isFavorite: true);

      expect(updatedQuote.isFavorite, true);
      expect(updatedQuote.id, quote.id);
      expect(updatedQuote.author, quote.author);
    });
  });

  group('Favorites Service Tests', () {
    test('FavoritesService methods exist', () {
      // These are just compilation tests since we can't test SharedPreferences easily
      expect(FavoritesService.getFavoriteIds, isA<Function>());
      expect(FavoritesService.addFavorite, isA<Function>());
      expect(FavoritesService.removeFavorite, isA<Function>());
      expect(FavoritesService.isFavorite, isA<Function>());
    });
  });

  group('Supabase Quotes Service Tests', () {
    test('SupabaseQuotesService instantiates', () {
      // Basic instantiation test
      expect(() => SupabaseQuotesService(), returnsNormally);
    });
  });
}