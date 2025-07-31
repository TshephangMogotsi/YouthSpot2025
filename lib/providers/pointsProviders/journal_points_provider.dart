import 'package:flutter/foundation.dart';
// Firebase import removed
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_provider.dart';

class JournalPointsProvider with ChangeNotifier {
  JournalPointsProvider(this.userProvider);

  final UserProvider userProvider;

  int _journalPoints = 0;
  int _journalMilestonePoints = 0;
  int _journalEntries = 0;
  final Set<int> _awardedMilestones = {}; // Track awarded milestones to avoid duplication
  bool _isInitialized = false;

  // Getters
  int get journalPoints => _journalPoints;
  int get journalMilestonePoints => _journalMilestonePoints;
  int get totalPoints => _journalPoints + _journalMilestonePoints;
  bool get isInitialized => _isInitialized;

  Future<void> initializeJournalPoints() async {
    if (userProvider.user != null) {
      try {
        // FirebaseFirestore.instance - REMOVED
            .collection('users')
            .doc(userProvider.user!.uid)
            .snapshots()
            .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic>? userData = snapshot.data();
            _journalPoints = userData?['journalPoints'] ?? 0;
            _journalMilestonePoints = userData?['journalMilestonePoints'] ?? 0;
            _journalEntries = userData?['journalEntries'] ?? 0;
            _isInitialized = true;
            notifyListeners();
          } else {
            if (kDebugMode) {
              print('Snapshot does not exist!');
            }
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing journal points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, cannot initialize journal points.');
      }
    }
  }

  // Add points for a new journal entry and check for milestone rewards
  void addJournalEntryPoints() {
    _journalEntries++;
    _journalPoints += 100;

    checkJournalMilestoneRewards();
    notifyListeners();

    // Save updated points to Firebase
    saveJournalPointsToFirebase();
  }

  // Check and award milestone points based on the number of journal entries
  void checkJournalMilestoneRewards() {
    final milestones = {
      5: 500,
      10: 1000,
      20: 2000,
      30: 3000,
      40: 4500,
      50: 6000,
      75: 8000,
      100: 10000,
    };

    milestones.forEach((entryCount, reward) {
      if (_journalEntries == entryCount && !_awardedMilestones.contains(entryCount)) {
        _awardedMilestones.add(entryCount);
        _journalMilestonePoints += reward;
        if (kDebugMode) {
          print('Milestone for $entryCount journal entries reached. Awarded $reward points.');
        }
      }
    });
  }

  // Save journal points and milestone points to Firebase
  Future<void> saveJournalPointsToFirebase() async {
    if (userProvider.user != null) {
      await // FirebaseFirestore.instance - REMOVED
          .collection('users')
          .doc(userProvider.user!.uid)
          .update({
        'journalPoints': _journalPoints,
        'journalMilestonePoints': _journalMilestonePoints,
        'journalEntries': _journalEntries,
      });
    }
  }
}