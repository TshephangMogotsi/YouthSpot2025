
// Firebase import removed - using generic Map instead of DocumentSnapshot
// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String userName;
  final String email;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final String? imageUrl;
  final int? rating; // Add this field

  UserModel({
    required this.uid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    this.imageUrl,
    this.rating, // Include in constructor
  });

  // Factory method to create a UserModel from a data Map (was Firestore document snapshot)
  factory UserModel.fromSnapshot(Map<String, dynamic> data) {
    return UserModel(
      uid: snapshot.id,
      fullName: data['fullName'] ?? data['fullname'] ?? 'No Name',
      userName: data['userName'] ?? data['screenName'] ?? 'No Username',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? data['dob'] ?? '',
      imageUrl: data['imageUrl'],
      rating: data['rating'] ?? 0, // Add this field here
    );
  }

  // Method to convert UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'imageUrl': imageUrl,
      'rating': rating, // Include this in the map
    };
  }

  // Method to create a copy of UserModel with optional new values
  UserModel copyWith({
    String? fullName,
    String? userName,
    String? email,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? imageUrl,
    int? rating, // Add this field
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating, // Include here
    );
  }
}
