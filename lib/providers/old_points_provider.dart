// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:youth_spot/provider/user_provider.dart';

// class PointsProvider with ChangeNotifier {
//   PointsProvider(this.userProvider);

//   final UserProvider userProvider;

//   int _totalPoints = 0;
//   int _articlePoints = 0;
//   bool hasInitialized = false; // Flag to indicate if points have been fetched

//   int _moodPoints = 0;
//   int _chatroomPoints = 0;
//   int _startedChatroomPoints = 0;
//   int _journalPoints = 0;
//   int _medicationPoints = 0;
//   int _loginPoints = 0;

//   // Getter for Article Points
//   int get articlePoints => _articlePoints;

//   // Getter for Mood Points
//   int get moodPoints => _moodPoints;

//   // Getter for Chatroom Points
//   int get chatroomPoints => _chatroomPoints;

//   // Getter for Started Chatroom Points
//   int get startedChatroomPoints => _startedChatroomPoints;

//   // Getter for Journal Points
//   int get journalPoints => _journalPoints;

//   // Getter for Medication Points
//   int get medicationPoints => _medicationPoints;

//   // Getter for Login Points
//   int get loginPoints => _loginPoints;

//   final List<String> _readArticleIds =
//       []; // Track the IDs of articles already read

//   // Track awarded milestones to ensure bonus is only given once
//   final Set<int> _articleMilestonesAwarded = {};
//   final Set<int> _moodMilestonesAwarded = {};
//   final Set<int> _chatroomMilestonesAwarded = {};
//   final Set<int> _journalMilestonesAwarded = {};
//   final Set<int> _medicationMilestonesAwarded = {};
//   final Set<int> _loginMilestonesAwarded = {};
//   final Set<int> _startedChatroomMilestonesAwarded = {};

//   // Getters
//   int get totalPoints => _totalPoints;

//   // Initialize points from Firebase
//   Future<void> initializePoints() async {
//     if (userProvider.user != null) {
//       try {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(userProvider.user!.uid)
//             .snapshots()
//             .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
//           if (snapshot.exists) {
//             Map<String, dynamic>? userData = snapshot.data();

//             _totalPoints = userData?['points'] ?? 0;
//             _articlePoints = userData?['articlePoints'] ?? 0;
//             _moodPoints = userData?['moodPoints'] ?? 0;
//             _chatroomPoints = userData?['chatroomPoints'] ?? 0;
//             _startedChatroomPoints = userData?['startedChatroomPoints'] ?? 0;
//             _journalPoints = userData?['journalPoints'] ?? 0;
//             _medicationPoints = userData?['medicationPoints'] ?? 0;
//             _loginPoints = userData?['loginPoints'] ?? 0;
//             _readArticleIds.addAll(List<String>.from(
//                 userData?['readArticleIds'] ?? [])); // Load read article IDs

//             notifyListeners(); // Notify UI that the points have been updated
//           } else {
//             print('Snapshot does not exist!');
//           }
//         });
//       } catch (e) {
//         print('Error initializing points: $e');
//       }
//     } else {
//       print('User is null, cannot initialize points.');
//     }
//   }

//   // General method to add points
//   void addPoints(int points, {String? action}) {
//     _totalPoints += points;
//     checkMilestoneRewards(action: action);
//     notifyListeners();
//     savePointsToFirebase();
//   }

//   // Add points for reading an article
//   void addArticlePoints(String articleId) async {
//     if (!_readArticleIds.contains(articleId)) {
//       _readArticleIds.add(articleId); // Track that this article was read
//       _articlePoints += 100; // Add 100 points for reading the article
//       _totalPoints += 100; // Add 100 points to total points
//       notifyListeners();

//       // Check milestone rewards for articles
//       checkMilestoneRewards(action: 'articles');

//       // Save updated points and read article IDs to Firebase after adding points
//       await savePointsToFirebase();
//     } else {
//       print('Article already read. No points awarded.');
//     }
//   }

//   // Add points for recording a mood
//   void recordMood() {
//     _moodPoints++;
//     addPoints(100, action: 'moods');
//   }

//   // Add points for joining a chatroom
//   void joinChatroom() {
//     _chatroomPoints++;
//     addPoints(100, action: 'chatrooms');
//   }

//   // Add points for starting a chatroom
//   void startChatroom() {
//     _startedChatroomPoints++;
//     addPoints(150, action: 'started_chatrooms');
//   }

//   // Add points for writing a journal entry
//   void writeJournalEntry() {
//     _journalPoints++;
//     addPoints(100, action: 'journal_entries');
//   }

//   // Add points for logging into the app
//   void login() {
//     _loginPoints++;
//     addPoints(50, action: 'logins');
//   }

//   // Add points for sharing a link
//   void shareLink() {
//     addPoints(150, action: 'shares');
//   }

//   // Add points for taking medication
//   void takeMedication() {
//     _medicationPoints++;
//     addPoints(100, action: 'medications');
//   }

//   void checkMilestoneRewards({String? action}) {
//     if (action == 'articles') {
//       int articlesRead = _readArticleIds.length;

//       print('Articles read: $articlesRead, Total points: $_totalPoints');

//       // Award milestone for exactly 10 articles
//       if (articlesRead == 10 && !_articleMilestonesAwarded.contains(10)) {
//         _articleMilestonesAwarded
//             .add(10); // Mark 10 articles milestone as awarded
//         _totalPoints += 750; // Award 750 milestone points
//         print('Milestone for 10 articles reached. Awarded 750 points.');
//       }

//       // Award milestone for exactly 20 articles
//       else if (articlesRead == 20 && !_articleMilestonesAwarded.contains(20)) {
//         _articleMilestonesAwarded
//             .add(20); // Mark 20 articles milestone as awarded
//         _totalPoints += 1500; // Award 1500 milestone points
//         print('Milestone for 20 articles reached. Awarded 1500 points.');
//       }

//       // Award milestone for exactly 30 articles
//       else if (articlesRead == 30 && !_articleMilestonesAwarded.contains(30)) {
//         _articleMilestonesAwarded
//             .add(30); // Mark 30 articles milestone as awarded
//         _totalPoints += 2500; // Award 2500 milestone points
//         print('Milestone for 30 articles reached. Awarded 2500 points.');
//       }

//       // Award milestone for exactly 50 articles
//       else if (articlesRead == 50 && !_articleMilestonesAwarded.contains(50)) {
//         _articleMilestonesAwarded
//             .add(50); // Mark 50 articles milestone as awarded
//         _totalPoints += 4000; // Award 4000 milestone points
//         print('Milestone for 50 articles reached. Awarded 4000 points.');
//       }

//       // Award milestone for exactly 75 articles
//       else if (articlesRead == 75 && !_articleMilestonesAwarded.contains(75)) {
//         _articleMilestonesAwarded
//             .add(75); // Mark 75 articles milestone as awarded
//         _totalPoints += 6000; // Award 6000 milestone points
//         print('Milestone for 75 articles reached. Awarded 6000 points.');
//       }

//       // Award milestone for exactly 100 articles
//       else if (articlesRead == 100 &&
//           !_articleMilestonesAwarded.contains(100)) {
//         _articleMilestonesAwarded
//             .add(100); // Mark 100 articles milestone as awarded
//         _totalPoints += 8000; // Award 8000 milestone points
//         print('Milestone for 100 articles reached. Awarded 8000 points.');
//       }

//       // Award milestone for exactly 150 articles
//       else if (articlesRead == 150 &&
//           !_articleMilestonesAwarded.contains(150)) {
//         _articleMilestonesAwarded
//             .add(150); // Mark 150 articles milestone as awarded
//         _totalPoints += 10000; // Award 10000 milestone points
//         print('Milestone for 150 articles reached. Awarded 10000 points.');
//       }

//       // Award milestone for exactly 200 articles
//       else if (articlesRead == 200 &&
//           !_articleMilestonesAwarded.contains(200)) {
//         _articleMilestonesAwarded
//             .add(200); // Mark 200 articles milestone as awarded
//         _totalPoints += 12000; // Award 12000 milestone points
//         print('Milestone for 200 articles reached. Awarded 12000 points.');
//       }

//       // Award milestone for exactly 250 articles
//       else if (articlesRead == 250 &&
//           !_articleMilestonesAwarded.contains(250)) {
//         _articleMilestonesAwarded
//             .add(250); // Mark 250 articles milestone as awarded
//         _totalPoints += 15000; // Award 15000 milestone points
//         print('Milestone for 250 articles reached. Awarded 15000 points.');
//       }

//       // Award milestone for exactly 300 articles
//       else if (articlesRead == 300 &&
//           !_articleMilestonesAwarded.contains(300)) {
//         _articleMilestonesAwarded
//             .add(300); // Mark 300 articles milestone as awarded
//         _totalPoints += 18000; // Award 18000 milestone points
//         print('Milestone for 300 articles reached. Awarded 18000 points.');
//       }

//       if (action == 'moods') {
//         if (_moodPoints == 7 && !_moodMilestonesAwarded.contains(7)) {
//           addPoints(750);
//           _moodMilestonesAwarded.add(7);
//         } else if (_moodPoints == 15 && !_moodMilestonesAwarded.contains(15)) {
//           addPoints(1500);
//           _moodMilestonesAwarded.add(15);
//         } else if (_moodPoints == 30 && !_moodMilestonesAwarded.contains(30)) {
//           addPoints(2500);
//           _moodMilestonesAwarded.add(30);
//         } else if (_moodPoints == 60 && !_moodMilestonesAwarded.contains(60)) {
//           addPoints(4000);
//           _moodMilestonesAwarded.add(60);
//         } else if (_moodPoints == 90 && !_moodMilestonesAwarded.contains(90)) {
//           addPoints(6000);
//           _moodMilestonesAwarded.add(90);
//         } else if (_moodPoints == 120 &&
//             !_moodMilestonesAwarded.contains(120)) {
//           addPoints(8000);
//           _moodMilestonesAwarded.add(120);
//         } else if (_moodPoints == 180 &&
//             !_moodMilestonesAwarded.contains(180)) {
//           addPoints(10000);
//           _moodMilestonesAwarded.add(180);
//         } else if (_moodPoints == 240 &&
//             !_moodMilestonesAwarded.contains(240)) {
//           addPoints(12000);
//           _moodMilestonesAwarded.add(240);
//         } else if (_moodPoints == 300 &&
//             !_moodMilestonesAwarded.contains(300)) {
//           addPoints(15000);
//           _moodMilestonesAwarded.add(300);
//         } else if (_moodPoints == 365 &&
//             !_moodMilestonesAwarded.contains(365)) {
//           addPoints(18000);
//           _moodMilestonesAwarded.add(365);
//         }
//       }

//       if (action == 'chatrooms') {
//         if (_chatroomPoints == 5 && !_chatroomMilestonesAwarded.contains(5)) {
//           addPoints(500);
//           _chatroomMilestonesAwarded.add(5);
//         } else if (_chatroomPoints == 10 &&
//             !_chatroomMilestonesAwarded.contains(10)) {
//           addPoints(1000);
//           _chatroomMilestonesAwarded.add(10);
//         } else if (_chatroomPoints == 20 &&
//             !_chatroomMilestonesAwarded.contains(20)) {
//           addPoints(2000);
//           _chatroomMilestonesAwarded.add(20);
//         } else if (_chatroomPoints == 30 &&
//             !_chatroomMilestonesAwarded.contains(30)) {
//           addPoints(3000);
//           _chatroomMilestonesAwarded.add(30);
//         } else if (_chatroomPoints == 40 &&
//             !_chatroomMilestonesAwarded.contains(40)) {
//           addPoints(4500);
//           _chatroomMilestonesAwarded.add(40);
//         } else if (_chatroomPoints == 50 &&
//             !_chatroomMilestonesAwarded.contains(50)) {
//           addPoints(6000);
//           _chatroomMilestonesAwarded.add(50);
//         } else if (_chatroomPoints == 75 &&
//             !_chatroomMilestonesAwarded.contains(75)) {
//           addPoints(8000);
//           _chatroomMilestonesAwarded.add(75);
//         } else if (_chatroomPoints == 100 &&
//             !_chatroomMilestonesAwarded.contains(100)) {
//           addPoints(10000);
//           _chatroomMilestonesAwarded.add(100);
//         }
//       }

//       if (action == 'started_chatrooms') {
//         if (_startedChatroomPoints == 5 &&
//             !_startedChatroomMilestonesAwarded.contains(5)) {
//           addPoints(750);
//           _startedChatroomMilestonesAwarded.add(5);
//         } else if (_startedChatroomPoints == 10 &&
//             !_startedChatroomMilestonesAwarded.contains(10)) {
//           addPoints(1500);
//           _startedChatroomMilestonesAwarded.add(10);
//         } else if (_startedChatroomPoints == 20 &&
//             !_startedChatroomMilestonesAwarded.contains(20)) {
//           addPoints(2500);
//           _startedChatroomMilestonesAwarded.add(20);
//         } else if (_startedChatroomPoints == 30 &&
//             !_startedChatroomMilestonesAwarded.contains(30)) {
//           addPoints(4000);
//           _startedChatroomMilestonesAwarded.add(30);
//         } else if (_startedChatroomPoints == 50 &&
//             !_startedChatroomMilestonesAwarded.contains(50)) {
//           addPoints(6000);
//           _startedChatroomMilestonesAwarded.add(50);
//         } else if (_startedChatroomPoints == 75 &&
//             !_startedChatroomMilestonesAwarded.contains(75)) {
//           addPoints(8000);
//           _startedChatroomMilestonesAwarded.add(75);
//         } else if (_startedChatroomPoints == 100 &&
//             !_startedChatroomMilestonesAwarded.contains(100)) {
//           addPoints(10000);
//           _startedChatroomMilestonesAwarded.add(100);
//         }
//       }

//       if (action == 'journal_entries') {
//         if (_journalPoints == 5 && !_journalMilestonesAwarded.contains(5)) {
//           addPoints(500);
//           _journalMilestonesAwarded.add(5);
//         } else if (_journalPoints == 10 &&
//             !_journalMilestonesAwarded.contains(10)) {
//           addPoints(1000);
//           _journalMilestonesAwarded.add(10);
//         } else if (_journalPoints == 20 &&
//             !_journalMilestonesAwarded.contains(20)) {
//           addPoints(2000);
//           _journalMilestonesAwarded.add(20);
//         } else if (_journalPoints == 30 &&
//             !_journalMilestonesAwarded.contains(30)) {
//           addPoints(3000);
//           _journalMilestonesAwarded.add(30);
//         } else if (_journalPoints == 40 &&
//             !_journalMilestonesAwarded.contains(40)) {
//           addPoints(4500);
//           _journalMilestonesAwarded.add(40);
//         } else if (_journalPoints == 50 &&
//             !_journalMilestonesAwarded.contains(50)) {
//           addPoints(6000);
//           _journalMilestonesAwarded.add(50);
//         } else if (_journalPoints == 75 &&
//             !_journalMilestonesAwarded.contains(75)) {
//           addPoints(8000);
//           _journalMilestonesAwarded.add(75);
//         } else if (_journalPoints == 100 &&
//             !_journalMilestonesAwarded.contains(100)) {
//           addPoints(10000);
//           _journalMilestonesAwarded.add(100);
//         }
//       }

//       if (action == 'medications') {
//         if (_medicationPoints == 7 &&
//             !_medicationMilestonesAwarded.contains(7)) {
//           addPoints(750);
//           _medicationMilestonesAwarded.add(7);
//         } else if (_medicationPoints == 15 &&
//             !_medicationMilestonesAwarded.contains(15)) {
//           addPoints(1500);
//           _medicationMilestonesAwarded.add(15);
//         } else if (_medicationPoints == 30 &&
//             !_medicationMilestonesAwarded.contains(30)) {
//           addPoints(2500);
//           _medicationMilestonesAwarded.add(30);
//         } else if (_medicationPoints == 60 &&
//             !_medicationMilestonesAwarded.contains(60)) {
//           addPoints(4000);
//           _medicationMilestonesAwarded.add(60);
//         } else if (_medicationPoints == 90 &&
//             !_medicationMilestonesAwarded.contains(90)) {
//           addPoints(6000);
//           _medicationMilestonesAwarded.add(90);
//         } else if (_medicationPoints == 120 &&
//             !_medicationMilestonesAwarded.contains(120)) {
//           addPoints(8000);
//           _medicationMilestonesAwarded.add(120);
//         } else if (_medicationPoints == 180 &&
//             !_medicationMilestonesAwarded.contains(180)) {
//           addPoints(10000);
//           _medicationMilestonesAwarded.add(180);
//         } else if (_medicationPoints == 240 &&
//             !_medicationMilestonesAwarded.contains(240)) {
//           addPoints(12000);
//           _medicationMilestonesAwarded.add(240);
//         } else if (_medicationPoints == 300 &&
//             !_medicationMilestonesAwarded.contains(300)) {
//           addPoints(15000);
//           _medicationMilestonesAwarded.add(300);
//         } else if (_medicationPoints == 365 &&
//             !_medicationMilestonesAwarded.contains(365)) {
//           addPoints(18000);
//           _medicationMilestonesAwarded.add(365);
//         }
//       }

//       if (action == 'logins') {
//         if (_loginPoints == 3 && !_loginMilestonesAwarded.contains(3)) {
//           addPoints(750);
//           _loginMilestonesAwarded.add(3);
//         } else if (_loginPoints == 30 &&
//             !_loginMilestonesAwarded.contains(30)) {
//           addPoints(2500);
//           _loginMilestonesAwarded.add(30);
//         } else if (_loginPoints == 90 &&
//             !_loginMilestonesAwarded.contains(90)) {
//           addPoints(6000);
//           _loginMilestonesAwarded.add(90);
//         } else if (_loginPoints == 180 &&
//             !_loginMilestonesAwarded.contains(180)) {
//           addPoints(10000);
//           _loginMilestonesAwarded.add(180);
//         } else if (_loginPoints == 365 &&
//             !_loginMilestonesAwarded.contains(365)) {
//           addPoints(18000);
//           _loginMilestonesAwarded.add(365);
//         }
//       }
//     }
//   }

//   // Save updated points and read article IDs to Firebase
//   Future<void> savePointsToFirebase() async {
//     if (userProvider.user != null) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userProvider.user!.uid)
//           .update({
//         'points': _totalPoints,
//         'articlePoints': _articlePoints,
//         'moodPoints': _moodPoints,
//         'chatroomPoints': _chatroomPoints,
//         'startedChatroomPoints': _startedChatroomPoints,
//         'journalPoints': _journalPoints,
//         'medicationPoints': _medicationPoints,
//         'loginPoints': _loginPoints,
//         'readArticleIds': _readArticleIds, // Store the list of read article IDs
//       });
//     }
//   }
// }
