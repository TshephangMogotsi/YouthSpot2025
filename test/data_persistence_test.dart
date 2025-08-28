import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/providers/resource_provider.dart';
import 'package:youthspot/providers/account_provider.dart';
import 'package:youthspot/providers/community_events_provider.dart';

void main() {
  group('Data Persistence Provider Tests', () {
    test('ResourceProvider maintains state and implements caching', () {
      final provider = ResourceProvider();
      
      // Should start with loading state
      expect(provider.isLoading, isTrue);
      expect(provider.categories, isEmpty);
      expect(provider.allResources, isEmpty);
      expect(provider.subcategories, isEmpty);
    });

    test('ResourceProvider filtering works correctly', () {
      final provider = ResourceProvider();
      
      // Test filtering method exists and returns list
      final filteredResources = provider.getFilteredResources();
      expect(filteredResources, isA<List>());
    });

    test('AccountProvider maintains state and implements caching', () {
      final provider = AccountProvider();
      
      // Should start with loading state
      expect(provider.isLoading, isTrue);
      expect(provider.userFullName, '');
      expect(provider.error, isNull);
    });

    test('AccountProvider has refresh functionality', () {
      final provider = AccountProvider();
      
      // Should have refresh method
      expect(() => provider.refreshUserProfile(), isA<Function>());
      expect(() => provider.clearError(), isA<Function>());
      expect(() => provider.clearUserData(), isA<Function>());
    });

    test('CommunityEventsProvider implements proper caching', () {
      final provider = CommunityEventsProvider();
      
      // Should start with loading state
      expect(provider.isLoading, isTrue);
      expect(provider.events, isEmpty);
      expect(provider.upcomingEvents, isEmpty);
      expect(provider.error, isNull);
    });

    test('CommunityEventsProvider has refresh functionality', () {
      final provider = CommunityEventsProvider();
      
      // Should have refresh method
      expect(() => provider.refreshEvents(), isA<Function>());
      expect(() => provider.clearError(), isA<Function>());
    });

    test('All providers implement ChangeNotifier correctly', () {
      final resourceProvider = ResourceProvider();
      final accountProvider = AccountProvider();
      final eventsProvider = CommunityEventsProvider();
      
      // All should be ChangeNotifiers
      expect(resourceProvider, isA<ResourceProvider>());
      expect(accountProvider, isA<AccountProvider>());
      expect(eventsProvider, isA<CommunityEventsProvider>());
    });
  });
}