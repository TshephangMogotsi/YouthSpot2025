// Firebase import removed
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../user_provider.dart';

class ArticlePointsProvider with ChangeNotifier {
  ArticlePointsProvider(this.userProvider);

  final UserProvider userProvider;

  int _articlePoints = 0;
  int _milestonePoints = 0;
  final List<String> _readArticleIds = []; // Track IDs of articles already read
  final Set<int> _articleMilestonesAwarded = {}; // Track awarded milestones
  bool _isInitialized = false; // Add this flag

  // Getter for Article Points
  int get articlePoints => _articlePoints;

  // Getter for Milestone Points
  int get milestonePoints => _milestonePoints;

  // Getter for Total Points
  int get totalPoints => _articlePoints + _milestonePoints;

  // Getter for Read Article IDs
  List<String> get readArticleIds => _readArticleIds;

  // Initialize article points from Firebase
 
  // Getter for Initialization Status
  bool get isInitialized => _isInitialized;

  // Initialize article points from Firebase
  Future<void> initializeArticlePoints() async {
    if (userProvider.user != null) {
      try {
        // Firebase functionality removed - implement with Supabase or other backend
        print('Firebase Firestore removed - initializeArticlePoints method needs reimplementation');
        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(userProvider.user!.uid)
        //     .snapshots()
        //     .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        //   if (snapshot.exists) {
        //     Map<String, dynamic>? userData = snapshot.data();
        //
        //     _articlePoints = userData?['articlePoints'] ?? 0;
        //     _milestonePoints = userData?['milestonePoints'] ?? 0;
        //     _readArticleIds.addAll(List<String>.from(
        //         userData?['readArticleIds'] ?? []));
        //
        //     _isInitialized = true; // Set flag after initialization
        //     notifyListeners();
        //   } else {
        //     if (kDebugMode) {
        //       print('Snapshot does not exist!');
        //     }
        //   }
        // });
        
        // Initialize with default values for now
        _articlePoints = 0;
        _milestonePoints = 0;
        _readArticleIds.clear();
        
        _isInitialized = true;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing article points: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is null, cannot initialize article points.');
      }
    }
  }
  // Add points for reading an article
  void addArticlePoints(String articleId) async {
    if (!_readArticleIds.contains(articleId)) {
      _readArticleIds.add(articleId); // Track that this article was read
      _articlePoints += 100; // Add 100 points for reading the article

      notifyListeners();

      // Check milestone rewards for articles
      checkArticleMilestoneRewards();

      // Save updated points and read article IDs to Firebase after adding points
      await saveArticlePointsToFirebase();
    } else {
      if (kDebugMode) {
        print('Article already read. No points awarded.');
      }
    }
  }

  // Check and apply milestone rewards for articles
  void checkArticleMilestoneRewards() {
    int articlesRead = _readArticleIds.length;

    // Define milestone rewards
    final milestones = {
      10: 750,
      20: 1500,
      30: 2500,
      50: 4000,
      75: 6000,
      100: 8000,
      150: 10000,
      200: 12000,
      250: 15000,
      300: 18000,
    };

    milestones.forEach((milestone, reward) {
      if (articlesRead == milestone && !_articleMilestonesAwarded.contains(milestone)) {
        _articleMilestonesAwarded.add(milestone); // Mark milestone as awarded
        _milestonePoints += reward; // Award milestone points
        if (kDebugMode) {
          print('Milestone for $milestone articles reached. Awarded $reward points.');
        }
      }
    });
  }

  // Save updated article points and read article IDs to Firebase
  Future<void> saveArticlePointsToFirebase() async {
    // Firebase functionality removed - implement with Supabase or other backend
    print('Firebase Firestore removed - saveArticlePointsToFirebase method needs reimplementation');
    // if (userProvider.user != null) {
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(userProvider.user!.uid)
    //       .update({
    //     'articlePoints': _articlePoints,
    //     'milestonePoints': _milestonePoints,
    //     'readArticleIds': _readArticleIds, // Store the list of read article IDs
    //   });
    // }
  }
}
