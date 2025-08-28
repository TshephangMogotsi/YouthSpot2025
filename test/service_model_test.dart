import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/db/models/service_model.dart';

void main() {
  group('Service Model', () {
    test('Service should be created from map with all fields', () {
      final testMap = {
        'id': 'test-id-123',
        'name': 'Test Service',
        'location': 'Test Location',
        'latitude': 25.7479,
        'longitude': 28.2293,
        'location_url': 'https://www.google.com/maps/place/Test+Location',
        'image_url': 'https://example.com/image.jpg',
        'contacts': ['123-456-7890', '098-765-4321'],
        'type': 'healthcare',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final service = Service.fromMap(testMap);

      expect(service.id, equals('test-id-123'));
      expect(service.name, equals('Test Service'));
      expect(service.location, equals('Test Location'));
      expect(service.latitude, equals(25.7479));
      expect(service.longitude, equals(28.2293));
      expect(service.locationUrl, equals('https://www.google.com/maps/place/Test+Location'));
      expect(service.imageUrl, equals('https://example.com/image.jpg'));
      expect(service.contacts, equals(['123-456-7890', '098-765-4321']));
      expect(service.type, equals('healthcare'));
      expect(service.createdAt, isA<DateTime>());
    });

    test('Service should handle null optional fields', () {
      final testMap = {
        'id': 'test-id-456',
        'name': 'Minimal Service',
        'location': null,
        'latitude': null,
        'longitude': null,
        'location_url': null,
        'image_url': null,
        'contacts': null,
        'type': null,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final service = Service.fromMap(testMap);

      expect(service.id, equals('test-id-456'));
      expect(service.name, equals('Minimal Service'));
      expect(service.location, isNull);
      expect(service.latitude, isNull);
      expect(service.longitude, isNull);
      expect(service.locationUrl, isNull);
      expect(service.imageUrl, isNull);
      expect(service.contacts, isNull);
      expect(service.type, isNull);
      expect(service.createdAt, isA<DateTime>());
    });

    test('Service should handle empty contacts array', () {
      final testMap = {
        'id': 'test-id-789',
        'name': 'Empty Contacts Service',
        'contacts': [],
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final service = Service.fromMap(testMap);

      expect(service.id, equals('test-id-789'));
      expect(service.name, equals('Empty Contacts Service'));
      expect(service.contacts, equals([]));
    });

    test('Service should convert latitude and longitude to double', () {
      final testMap = {
        'id': 'test-id-numeric',
        'name': 'Numeric Coords Service',
        'latitude': '25.7479', // String that should be converted
        'longitude': '28.2293', // String that should be converted
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final service = Service.fromMap(testMap);

      expect(service.latitude, equals(25.7479));
      expect(service.longitude, equals(28.2293));
      expect(service.latitude, isA<double>());
      expect(service.longitude, isA<double>());
    });

    test('Service should handle location URL field', () {
      final testMap = {
        'id': 'test-id-url',
        'name': 'URL Service',
        'location_url': 'https://www.google.com/maps/place/Tebelopele+Voluntery+Counselling',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final service = Service.fromMap(testMap);

      expect(service.id, equals('test-id-url'));
      expect(service.name, equals('URL Service'));
      expect(service.locationUrl, equals('https://www.google.com/maps/place/Tebelopele+Voluntery+Counselling'));
    });
  });
}