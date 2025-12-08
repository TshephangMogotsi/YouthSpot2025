import 'package:flutter_test/flutter_test.dart';
import 'package:youthspot/db/models/journal_model.dart';

void main() {
  group('Journal Search Functionality', () {
    late List<JournalEntry> sampleJournals;

    setUp(() {
      // Create sample journal entries for testing
      sampleJournals = [
        JournalEntry(
          id: 1,
          isImportant: false,
          number: 1,
          title: 'My First Day at Work',
          description: 'Today was amazing! I started my new job and met wonderful colleagues.',
          createdTime: DateTime.now(),
        ),
        JournalEntry(
          id: 2,
          isImportant: true,
          number: 2,
          title: 'Vacation Plans',
          description: 'Planning a trip to the beach next summer. Need to book tickets soon.',
          createdTime: DateTime.now(),
        ),
        JournalEntry(
          id: 3,
          isImportant: false,
          number: 3,
          title: 'Grocery Shopping',
          description: 'Bought fruits, vegetables, and some snacks for the week.',
          createdTime: DateTime.now(),
        ),
        JournalEntry(
          id: 4,
          isImportant: true,
          number: 4,
          title: 'Work Meeting',
          description: 'Important discussion about the project deadline. Need to finish by Friday.',
          createdTime: DateTime.now(),
        ),
      ];
    });

    // Helper method to filter journals based on search query
    List<JournalEntry> filterJournals(List<JournalEntry> journals, String query) {
      return journals.where((journal) {
        final titleMatches = journal.title.toLowerCase().contains(query.toLowerCase());
        final descriptionMatches = journal.description.toLowerCase().contains(query.toLowerCase());
        return titleMatches || descriptionMatches;
      }).toList();
    }

    test('Search should return all journals when query is empty', () {
      const query = '';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(4));
    });

    test('Search should match journals by title', () {
      const query = 'work';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(2));
      expect(filteredJournals.any((j) => j.title.contains('Work')), true);
    });

    test('Search should match journals by description', () {
      const query = 'beach';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(1));
      expect(filteredJournals.first.title, equals('Vacation Plans'));
    });

    test('Search should match journals by both title and description', () {
      const query = 'project';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(1));
      expect(filteredJournals.first.description.contains('project'), true);
    });

    test('Search should be case-insensitive', () {
      const query = 'VACATION';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(1));
      expect(filteredJournals.first.title, equals('Vacation Plans'));
    });

    test('Search should return empty list when no matches found', () {
      const query = 'nonexistent';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.isEmpty, true);
    });

    test('Search should handle partial word matches', () {
      const query = 'vaca';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(1));
      expect(filteredJournals.first.title, equals('Vacation Plans'));
    });

    test('Search should handle special characters', () {
      const query = 'fruits, vegetables';
      final filteredJournals = filterJournals(sampleJournals, query);

      expect(filteredJournals.length, equals(1));
      expect(filteredJournals.first.title, equals('Grocery Shopping'));
    });
  });
}
