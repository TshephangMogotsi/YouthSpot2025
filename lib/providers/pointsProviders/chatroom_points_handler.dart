// lib/provider/handlers/chatroom_points_handler.dart
import 'package:flutter/material.dart';

class ChatroomPointsHandler with ChangeNotifier {
  int _chatroomPoints = 0;
  final Set<int> _chatroomMilestonesAwarded = {};

  int get chatroomPoints => _chatroomPoints;

  Future<void> initializeChatroomPoints(Map<String, dynamic>? userData) async {
    _chatroomPoints = userData?['chatroomPoints'] ?? 0;
  }

  void joinChatroom() {
    _chatroomPoints += 100;
    checkChatroomMilestone();
    notifyListeners();
  }

  void checkChatroomMilestone() {
    if (_chatroomPoints == 500 && !_chatroomMilestonesAwarded.contains(5)) {
      _chatroomPoints += 500;
      _chatroomMilestonesAwarded.add(5);
    } else if (_chatroomPoints == 1000 && !_chatroomMilestonesAwarded.contains(10)) {
      _chatroomPoints += 1000;
      _chatroomMilestonesAwarded.add(10);
    } else if (_chatroomPoints == 2000 && !_chatroomMilestonesAwarded.contains(20)) {
      _chatroomPoints += 2000;
      _chatroomMilestonesAwarded.add(20);
    } else if (_chatroomPoints == 3000 && !_chatroomMilestonesAwarded.contains(30)) {
      _chatroomPoints += 3000;
      _chatroomMilestonesAwarded.add(30);
    } else if (_chatroomPoints == 4500 && !_chatroomMilestonesAwarded.contains(40)) {
      _chatroomPoints += 4500;
      _chatroomMilestonesAwarded.add(40);
    } else if (_chatroomPoints == 6000 && !_chatroomMilestonesAwarded.contains(50)) {
      _chatroomPoints += 6000;
      _chatroomMilestonesAwarded.add(50);
    } else if (_chatroomPoints == 8000 && !_chatroomMilestonesAwarded.contains(75)) {
      _chatroomPoints += 8000;
      _chatroomMilestonesAwarded.add(75);
    } else if (_chatroomPoints == 10000 && !_chatroomMilestonesAwarded.contains(100)) {
      _chatroomPoints += 10000;
      _chatroomMilestonesAwarded.add(100);
    }
  }

  Map<String, dynamic> toMap() {
    return {'chatroomPoints': _chatroomPoints};
  }
}
