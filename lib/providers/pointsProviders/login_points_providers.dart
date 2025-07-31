import 'package:flutter/foundation.dart';
// Firebase import removed
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_provider.dart';

class LoginPointsProvider with ChangeNotifier {
  LoginPointsProvider(this.userProvider);

  final UserProvider userProvider;

  int _loginPoints = 0;
  int _loginMilestonePoints = 0;
  DateTime? _lastLoginDate;
  int _consecutiveDays = 0; // Track consecutive login days
  int _weeklyLoginCount = 0; // Track weekly logins for milestone checks
  final Set<int> _loginMilestonesAwarded = {}; // Track awarded milestones
  bool _isInitialized = false;

   // Test properties
  int testConsecutiveDays = 0;
  int testWeeklyLoginCount = 0;

  void setTestConsecutiveDays(int days) {
    testConsecutiveDays = days;
    _consecutiveDays = days;
  }

  void setTestWeeklyLoginCount(int count) {
    testWeeklyLoginCount = count;
    _weeklyLoginCount = count;
  }

  // Getters
  int get totalPoints => _loginPoints + _loginMilestonePoints;
  bool get isInitialized => _isInitialized;

  // Getter for daily login points
  int get loginPoints => _loginPoints;

  // Getter for milestone login points
  int get loginMilestonePoints => _loginMilestonePoints;

  // Getter for total login points (daily + milestone)
  int get totalLoginPoints => _loginPoints + _loginMilestonePoints;

  // Initialize points from Firebase
  Future<void> initializeLoginPoints() async {
    if (userProvider.user != null) {
      try {
        // FirebaseFirestore.instance - REMOVED
            .collection('users')
            .doc(userProvider.user!.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            _loginPoints = data?['loginPoints'] ?? 0;
            _loginMilestonePoints = data?['loginMilestonePoints'] ?? 0;
            _lastLoginDate = (data?['lastLoginDate'] as Timestamp?)?.toDate();
            _consecutiveDays = data?['consecutiveDays'] ?? 0;
            _weeklyLoginCount = data?['weeklyLoginCount'] ?? 0;

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
          print('Error initializing login points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, cannot initialize login points.');
      }
    }
  }

  // Add points for a daily login
  Future<void> addDailyLoginPoints() async {
    final now = DateTime.now();
    if (_isNewDay(now)) {
      _loginPoints += 100;
      _updateConsecutiveLogins(now);
      checkLoginMilestoneRewards(); // Check for milestones
      notifyListeners();

      await saveLoginPointsToFirebase();
    } else {
      if (kDebugMode) {
        print('Already rewarded for today.');
      }
    }
  }

  // Check and update consecutive login days
  void _updateConsecutiveLogins(DateTime now) {
    if (_lastLoginDate != null &&
        now.difference(_lastLoginDate!).inDays == 1) {
      _consecutiveDays++;
      _weeklyLoginCount++;
    } else {
      _consecutiveDays = 1;
      _weeklyLoginCount = 1;
    }

    _lastLoginDate = now;
  }

  // Check and apply milestone rewards for login activity
  void checkLoginMilestoneRewards() {
    final milestones = {
      3: 750,
      6: 1500,
      9: 2500,
      12: 4000,
      18: 6000,
      24: 8000,
    };

    final monthsLoggedIn = (_consecutiveDays / 30).floor();

    milestones.forEach((months, reward) {
      if (monthsLoggedIn >= months && !_loginMilestonesAwarded.contains(months)) {
        _loginMilestonesAwarded.add(months);
        _loginMilestonePoints += reward;
        if (kDebugMode) {
          print('Milestone for $months months of activity reached. Awarded $reward points.');
        }
      }
    });
  }

  // Save updated login points and milestone info to Firebase
  Future<void> saveLoginPointsToFirebase() async {
    if (userProvider.user != null) {
      await // FirebaseFirestore.instance - REMOVED
          .collection('users')
          .doc(userProvider.user!.uid)
          .update({
        'loginPoints': _loginPoints,
        'loginMilestonePoints': _loginMilestonePoints,
        'lastLoginDate': _lastLoginDate,
        'consecutiveDays': _consecutiveDays,
        'weeklyLoginCount': _weeklyLoginCount,
      });
    }
  }

  // Helper to check if today is a new day compared to the last login
  bool _isNewDay(DateTime now) {
    return _lastLoginDate == null ||
        now.difference(_lastLoginDate!).inDays >= 1;
  }
}
