import 'package:flutter_test/flutter_test.dart';
import '../lib/models/motivational_quote.dart';
import '../lib/services/supabase_quotes_service.dart';
import '../lib/services/favorites_service.dart';

void main() {
  group('Motivational Quote Refactor Verification', () {
    test('MotivationalQuote.fromSupabase handles Supabase format correctly', () {
      final jsonData = {
        'id': 'f2ff55e3-a331-4502-b2ae-0a813bb58b1a', // UUID format
        'author': 'Maya Angelou',
        'quote': 'The best way to make your dreams come true is to wake up.',
        'background_image_url': 'https://example.com/background.jpg',
        'created': '2024-01-01T12:00:00Z',
      };

      final quote = MotivationalQuote.fromSupabase(jsonData);

      expect(quote.id, 'f2ff55e3-a331-4502-b2ae-0a813bb58b1a');
      expect(quote.author, 'Maya Angelou');
      expect(quote.quote, 'The best way to make your dreams come true is to wake up.');
      expect(quote.backgroundImageUrl, 'https://example.com/background.jpg');
      expect(quote.isFavorite, false); // Defaults to false
      expect(quote.backgroundImage, quote.backgroundImageUrl); // Backward compatibility
    });

    test('MotivationalQuote.fromSupabase handles qoute spelling variant', () {
      final jsonData = {
        'id': '123',
        'author': 'Test Author',
        'qoute': 'Test quote with alternative spelling', // Note: "qoute" not "quote"
        'background_image_url': 'https://example.com/image.jpg',
        'created': '2024-01-01T00:00:00Z',
      };

      final quote = MotivationalQuote.fromSupabase(jsonData);
      expect(quote.quote, 'Test quote with alternative spelling');
    });

    test('MotivationalQuote.fromSupabase handles missing fields gracefully', () {
      final jsonData = {
        'id': '456',
        'author': null,
        'quote': null,
        'background_image_url': null,
        'created': null,
      };

      expect(() => MotivationalQuote.fromSupabase(jsonData), returnsNormally);
      
      final quote = MotivationalQuote.fromSupabase(jsonData);
      expect(quote.id, '456');
      expect(quote.author, 'Unknown');
      expect(quote.quote, '');
      expect(quote.backgroundImageUrl, '');
    });

    test('MotivationalQuote.copyWith preserves data correctly', () {
      final originalQuote = MotivationalQuote(
        id: 'test-id',
        author: 'Original Author',
        quote: 'Original Quote',
        backgroundImageUrl: 'https://original.com/image.jpg',
        created: DateTime(2024, 1, 1),
      );

      final updatedQuote = originalQuote.copyWith(isFavorite: true);

      expect(updatedQuote.id, originalQuote.id);
      expect(updatedQuote.author, originalQuote.author);
      expect(updatedQuote.quote, originalQuote.quote);
      expect(updatedQuote.backgroundImageUrl, originalQuote.backgroundImageUrl);
      expect(updatedQuote.created, originalQuote.created);
      expect(updatedQuote.isFavorite, true);
      expect(originalQuote.isFavorite, false); // Original unchanged
    });

    test('Services exist and can be instantiated', () {
      expect(() => SupabaseQuotesService(), returnsNormally);
      
      // Test that static methods exist
      expect(FavoritesService.getFavoriteIds, isA<Function>());
      expect(FavoritesService.addFavorite, isA<Function>());
      expect(FavoritesService.removeFavorite, isA<Function>());
      expect(FavoritesService.isFavorite, isA<Function>());
    });
  });

  group('Data Type Compatibility Tests', () {
    test('String IDs work correctly (fixes UUID parsing error)', () {
      // Test that we can handle both UUID strings and numeric strings
      final uuidQuote = MotivationalQuote.fromSupabase({
        'id': 'f2ff55e3-a331-4502-b2ae-0a813bb58b1a',
        'author': 'Test',
        'quote': 'Test',
        'background_image_url': '',
        'created': '2024-01-01T00:00:00Z',
      });

      final numericQuote = MotivationalQuote.fromSupabase({
        'id': '123',
        'author': 'Test',
        'quote': 'Test',
        'background_image_url': '',
        'created': '2024-01-01T00:00:00Z',
      });

      expect(uuidQuote.id, isA<String>());
      expect(numericQuote.id, isA<String>());
      expect(uuidQuote.id, 'f2ff55e3-a331-4502-b2ae-0a813bb58b1a');
      expect(numericQuote.id, '123');
    });
  });
}