import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../user_provider.dart';

class MoodPointsProvider with ChangeNotifier {
  MoodPointsProvider(this.userProvider);

  final UserProvider userProvider;

  int _moodPoints = 0;
  int _milestonePoints = 0;
  bool _isInitialized = false;
  DateTime? _lastRecordedDate;
  int _consecutiveDays = 0;
  final Set<int> _moodMilestonesAwarded = {};

  // Getter for Mood Points
  int get moodPoints => _moodPoints;

  // Getter for Milestone Points
  int get milestonePoints => _milestonePoints;

  // Getter for Total Points
  int get totalMoodPoints => _moodPoints + _milestonePoints;

  // Getter for Initialization Status
  bool get isInitialized => _isInitialized;

  // Getter for Last Recorded Date
  DateTime? get lastRecordedDate => _lastRecordedDate;

  @visibleForTesting
  void setLastRecordedDate(DateTime date) {
    _lastRecordedDate = date;
  }

  @visibleForTesting
  set testConsecutiveDays(int days) {
    _consecutiveDays = days;
  }

  // Initialize mood points, bypass Firebase if in test mode
  Future<void> initializeMoodPoints({bool useFirebase = true}) async {
    if (userProvider.user != null && useFirebase) {
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.user!.uid)
            .snapshots()
            .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            _loadDataFromSnapshot(snapshot.data());
          } else {
            if (kDebugMode) {
              print('Snapshot does not exist!');
            }
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing mood points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, or Firebase disabled. Skipping initialization.');
      }
    }
  }

  // Loads data from the snapshot
  void _loadDataFromSnapshot(Map<String, dynamic>? data) {
    _moodPoints = data?['moodPoints'] ?? 0;
    _milestonePoints = data?['milestonePoints'] ?? 0;
    _consecutiveDays = data?['consecutiveDays'] ?? 0;
    _lastRecordedDate = (data?['lastRecordedDate'] as Timestamp?)?.toDate();
    _isInitialized = true;
    notifyListeners();
  }

  // Add points for recording a mood
  Future<void> addMoodPoints() async {
    final now = DateTime.now();
    if (_isConsecutive(now)) {
      _consecutiveDays++;
    } else {
      _consecutiveDays = 1; // Reset streak if not consecutive
    }

    _lastRecordedDate = now;
    _moodPoints += 100; // Add base points for recording a mood
    checkMoodMilestoneRewards(); // Check if any milestone is reached
    notifyListeners();

    await _saveMoodPointsToFirebase();
  }

  // Check if today's mood recording continues a consecutive streak
  bool _isConsecutive(DateTime now) {
    if (_lastRecordedDate == null) return true; // First entry
    final difference = now.difference(_lastRecordedDate!).inDays;
    return difference == 1; // Only consecutive if 1 day has passed
  }

  // Check and apply milestone rewards for mood tracking streak
  void checkMoodMilestoneRewards() {
    final milestones = {
      7: 750,
      15: 1500,
      30: 2500,
      60: 4000,
      90: 6000,
      120: 8000,
      180: 10000,
      240: 12000,
      300: 15000,
      365: 18000,
    };

    // Loop through milestones and award points if consecutiveDays meets or exceeds the milestone
    milestones.forEach((streak, reward) {
      if (_consecutiveDays >= streak && !_moodMilestonesAwarded.contains(streak)) {
        _moodMilestonesAwarded.add(streak); // Mark milestone as awarded
        _milestonePoints += reward; // Award milestone points
        if (kDebugMode) {
          print('Milestone for $streak consecutive days reached. Awarded $reward points.');
        }
      }
    });
  }

  // Save updated mood points, milestone points, last recorded date, and streak to Firebase
  Future<void> _saveMoodPointsToFirebase() async {
    if (userProvider.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProvider.user!.uid)
          .update({
        'moodPoints': _moodPoints,
        'milestonePoints': _milestonePoints,
        'consecutiveDays': _consecutiveDays,
        'lastRecordedDate': _lastRecordedDate,
      });
    }
  }
}