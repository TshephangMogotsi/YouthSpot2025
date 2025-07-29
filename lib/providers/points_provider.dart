import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_provider.dart';

class PointsProvider with ChangeNotifier {
  PointsProvider(this.userProvider);

  final UserProvider userProvider;

  int _totalPoints = 0;
  bool hasInitialized = false; // Flag to indicate if points have been fetched

  int _moodPoints = 0;
  int _chatroomPoints = 0;
  int _startedChatroomPoints = 0;
  int _journalPoints = 0;
  int _medicationPoints = 0;
  int _loginPoints = 0;

  // Getter for Mood Points
  int get moodPoints => _moodPoints;

  // Getter for Chatroom Points
  int get chatroomPoints => _chatroomPoints;

  // Getter for Started Chatroom Points
  int get startedChatroomPoints => _startedChatroomPoints;

  // Getter for Journal Points
  int get journalPoints => _journalPoints;

  // Getter for Medication Points
  int get medicationPoints => _medicationPoints;

  // Getter for Login Points
  int get loginPoints => _loginPoints;

  // Getters
  int get totalPoints => _totalPoints;

  // Initialize points from Firebase
  Future<void> initializePoints() async {
    if (userProvider.user != null) {
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.user!.uid)
            .snapshots()
            .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic>? userData = snapshot.data();

            _totalPoints = userData?['points'] ?? 0;
            _moodPoints = userData?['moodPoints'] ?? 0;
            _chatroomPoints = userData?['chatroomPoints'] ?? 0;
            _startedChatroomPoints = userData?['startedChatroomPoints'] ?? 0;
            _journalPoints = userData?['journalPoints'] ?? 0;
            _medicationPoints = userData?['medicationPoints'] ?? 0;
            _loginPoints = userData?['loginPoints'] ?? 0;

            hasInitialized = true; // Set initialization flag
            notifyListeners(); // Notify UI that points have been updated
          } else {
            if (kDebugMode) {
              print('Snapshot does not exist!');
            }
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, cannot initialize points.');
      }
    }
  }

  // General method to add points
  void addPoints(int points, {String? action}) {
    _totalPoints += points;
    checkMilestoneRewards(action: action);
    notifyListeners();
    savePointsToFirebase();
  }

  // Add points for recording a mood
  void recordMood() {
    _moodPoints++;
    addPoints(100, action: 'moods');
  }

  // Add points for joining a chatroom
  void joinChatroom() {
    _chatroomPoints++;
    addPoints(100, action: 'chatrooms');
  }

  // Add points for starting a chatroom
  void startChatroom() {
    _startedChatroomPoints++;
    addPoints(150, action: 'started_chatrooms');
  }

  // Add points for writing a journal entry
  void writeJournalEntry() {
    _journalPoints++;
    addPoints(100, action: 'journal_entries');
  }

  // Add points for logging into the app
  void login() {
    _loginPoints++;
    addPoints(50, action: 'logins');
  }

  // Add points for sharing a link
  void shareLink() {
    addPoints(150, action: 'shares');
  }

  // Add points for taking medication
  void takeMedication() {
    _medicationPoints++;
    addPoints(100, action: 'medications');
  }

  void checkMilestoneRewards({String? action}) {
    // Handle milestone rewards for other actions here
  }

  // Save updated points to Firebase
  Future<void> savePointsToFirebase() async {
    if (userProvider.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProvider.user!.uid)
          .update({
        'points': _totalPoints,
        'moodPoints': _moodPoints,
        'chatroomPoints': _chatroomPoints,
        'startedChatroomPoints': _startedChatroomPoints,
        'journalPoints': _journalPoints,
        'medicationPoints': _medicationPoints,
        'loginPoints': _loginPoints,
      });
    }
  }
}
