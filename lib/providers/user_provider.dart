// Firebase imports removed
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../db/models/user.dart';  // Ensure this file path is correct
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // Method to check if the user is authenticated and fetch user details
  Future<void> fetchUser() async {
    try {
      // Firebase functionality removed - implement with Supabase or other backend
      print('Firebase auth removed - fetchUser method needs reimplementation');
      // User? firebaseUser = FirebaseAuth.instance.currentUser;
      //
      // if (firebaseUser != null) {
      //   // Fetch user document from Firestore
      //   DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(firebaseUser.uid)
      //       .get();
      //
      //   if (userDoc.exists && userDoc.data() != null) {
      //     _user = UserModel.fromSnapshot(userDoc);
      //     notifyListeners(); // Notify listeners that user is fetched
      //   } else {
      //     print('User document does not exist');
      //   }
      // } else {
      //   print('No user is currently signed in');
      // }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  bool get isUserFetched => _user != null;

  Future<void> updateUser(UserModel user, {String? profilePictureUrl}) async {
    try {
      // Firebase functionality removed - implement with Supabase or other backend
      print('Firebase Firestore removed - updateUser method needs reimplementation');
      // Map<String, dynamic> userData = user.toMap();
      // if (profilePictureUrl != null) {
      //   userData['imageUrl'] = profilePictureUrl;
      // }
      //
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user.uid)
      //     .update(userData);
      // _user = user.copyWith(imageUrl: profilePictureUrl);
      // notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<int?> fetchUserPosition() async {
    try {
      // Firebase functionality removed - implement with Supabase or other backend
      print('Firebase auth/firestore removed - fetchUserPosition method needs reimplementation');
      // User? firebaseUser = FirebaseAuth.instance.currentUser;
      //
      // if (firebaseUser != null) {
      //   DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(firebaseUser.uid)
      //       .get();
      //
      //   if (userDoc.exists && userDoc.data() != null) {
      //     UserModel user = UserModel.fromSnapshot(userDoc);
      //
      //     // Count how many users have a higher rating
      //     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      //         .collection('users')
      //         .where('rating', isGreaterThan: user.rating)
      //         .get();
      //
      //     int position = snapshot.docs.length + 1;
      //     return position; // Return the user's position
      //   } else {
      //     print('User document does not exist');
      //   }
      // } else {
      //   print('No user is currently signed in');
      // }
    } catch (e) {
      print('Error fetching user position: $e');
    }
    return null; // Return null if user is not found or an error occurs
  }
}