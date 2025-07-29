import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_provider.dart';

class MotivationalQuotesProvider with ChangeNotifier {
  MotivationalQuotesProvider(this.userProvider);

  final UserProvider userProvider;

  int _dailyQuotePoints = 0;
  int _quoteMilestonePoints = 0;
  DateTime? _lastQuoteOpenDate;
  int _consecutiveDays = 0; // Track consecutive days of opening quotes
  final Set<int> _quoteMilestonesAwarded = {}; // Track awarded milestones
  final List<String> _viewedQuoteIds = []; // Track IDs of quotes already viewed
  bool _isInitialized = false;

  // Test properties
  int testConsecutiveDays = 0;

  void setTestConsecutiveDays(int days) {
    testConsecutiveDays = days;
    _consecutiveDays = days;
  }

  // Getters
  int get totalPoints => _dailyQuotePoints + _quoteMilestonePoints;
  bool get isInitialized => _isInitialized;

  // Getter for daily quote points
  int get dailyQuotePoints => _dailyQuotePoints;

  // Getter for milestone quote points
  int get quoteMilestonePoints => _quoteMilestonePoints;

  // Getter for total quote points (daily + milestone)
  int get totalQuotePoints => _dailyQuotePoints + _quoteMilestonePoints;

  // Initialize points from Firebase
  Future<void> initializeQuotePoints() async {
    if (userProvider.user != null) {
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.user!.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            _dailyQuotePoints = data?['dailyQuotePoints'] ?? 0;
            _quoteMilestonePoints = data?['quoteMilestonePoints'] ?? 0;
            _lastQuoteOpenDate = (data?['lastQuoteOpenDate'] as Timestamp?)?.toDate();
            _consecutiveDays = data?['consecutiveDays'] ?? 0;
            _viewedQuoteIds.addAll(List<String>.from(data?['viewedQuoteIds'] ?? []));

            _isInitialized = true;
            notifyListeners();
          } else {
            if (kDebugMode) {
              print('User data does not exist in Firebase.');
            }
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing quote points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, cannot initialize quote points.');
      }
    }
  }

  // Add points for opening quotes daily
  Future<void> addDailyQuotePoints() async {
    final now = DateTime.now();
    if (_isNewDay(now)) {
      _dailyQuotePoints += 500;
      _updateConsecutiveDays(now);
      checkQuoteMilestoneRewards(); // Check for milestones
      notifyListeners();

      await saveQuotePointsToFirebase();
    } else {
      if (kDebugMode) {
        print('Already rewarded Quotes Points for today.');
      }
    }
  }

  // Add points for opening an individual quote
  Future<void> addIndividualQuotePoints() async {
    _dailyQuotePoints += 50;
    notifyListeners();

    await saveQuotePointsToFirebase();
  }

  // Add points for viewing a quote
  Future<void> addQuotePoints(String quoteId) async {
    if (!_viewedQuoteIds.contains(quoteId)) {
      _viewedQuoteIds.add(quoteId);
      _dailyQuotePoints += 50;
      notifyListeners();

      // Check milestone rewards for quotes
      checkQuoteMilestoneRewards();

      // Save updated points and viewed quote IDs to Firebase after adding points
      await saveQuotePointsToFirebase();
    } else {
      if (kDebugMode) {
        print('Quote already viewed. No points awarded.');
      }
    }
  }

  // Check and update consecutive days of opening quotes
  void _updateConsecutiveDays(DateTime now) {
    if (_lastQuoteOpenDate != null &&
        now.difference(_lastQuoteOpenDate!).inDays == 1) {
      _consecutiveDays++;
    } else {
      _consecutiveDays = 1;
    }

    _lastQuoteOpenDate = now;
  }

  // Check and apply milestone rewards for quote activity
  void checkQuoteMilestoneRewards() {
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

    milestones.forEach((days, reward) {
      if (_consecutiveDays >= days && !_quoteMilestonesAwarded.contains(days)) {
        _quoteMilestonesAwarded.add(days);
        _quoteMilestonePoints += reward;
        if (kDebugMode) {
          print('Milestone for $days consecutive days of opening quotes reached. Awarded $reward points.');
        }
      }
    });
  }

  // Save updated quote points and milestone info to Firebase
  Future<void> saveQuotePointsToFirebase() async {
    if (userProvider.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProvider.user!.uid)
          .update({
        'dailyQuotePoints': _dailyQuotePoints,
        'quoteMilestonePoints': _quoteMilestonePoints,
        'lastQuoteOpenDate': _lastQuoteOpenDate,
        'consecutiveDays': _consecutiveDays,
        'viewedQuoteIds': _viewedQuoteIds, // Store the list of viewed quote IDs
      });
    }
  }

  // Helper to check if today is a new day compared to the last quote open date
  bool _isNewDay(DateTime now) {
    return _lastQuoteOpenDate == null ||
        now.difference(_lastQuoteOpenDate!).inDays >= 1;
  }
}