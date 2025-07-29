import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LeaderboardProvider extends ChangeNotifier {
  int _currentUserPosition = 0;
  int _currentUserPoints = 0;

  int get currentUserPosition => _currentUserPosition;
  int get currentUserPoints => _currentUserPoints;

  // Fetch the user's position from Firestore before the leaderboard page loads
  Future<void> fetchUserPositionAndPoints(String uid, int rating) async {
    try {
      // Ensure that the user's rating is valid (it should not be null)
      if (rating == 0) {
        if (kDebugMode) {
          print("Rating is 0, unable to fetch position");
        }
        _currentUserPosition = 0;
        notifyListeners();
        return;
      }

      // Fetch all users ordered by rating (including those with same rating)
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('rating', descending: true)
          .get();

      // Convert the snapshot into a list of users
      List<QueryDocumentSnapshot<Map<String, dynamic>>> userDocs = snapshot.docs;

      // Find the position of the current user
      int position = 1; // Start from 1
      for (var doc in userDocs) {
        if (doc.id == uid) {
          break; // Stop when we find the current user
        }
        position++;
      }

      // Log the fetched data for debugging
      print('Calculated position for user $uid: $position');

      // Set the current user's position and points
      _currentUserPosition = position;
      _currentUserPoints = rating;

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error fetching user position: $e');
      _currentUserPosition = 0; // Set to 0 if there's an error
      notifyListeners();
    }
  }

  void updateUserPosition(int position, int points) {
    _currentUserPosition = position;
    _currentUserPoints = points;
    notifyListeners();
  }

  void resetPosition() {
    _currentUserPosition = 0;
    _currentUserPoints = 0;
    notifyListeners();
  }
}
