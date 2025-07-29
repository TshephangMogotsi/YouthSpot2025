import 'package:flutter/material.dart';

import '../db/app_db.dart';
import '../db/models/goal_model.dart'; // Ensure this is the correct import for your database access

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  GoalProvider() {
    // Fetch goals from the database on initialization
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    _goals = await SSIDatabase.instance.readAllGoals();
    notifyListeners(); // Notify listeners after fetching goals
  }

  Future<Goal> addGoal(Goal goal) async {
    final newGoal = await SSIDatabase.instance.createGoal(goal);
    await fetchGoals(); // Fetch goals after adding
    return newGoal;
  }

  Future<void> updateGoals(Goal goal) async {
    await SSIDatabase.instance.updateGoal(goal);
    fetchGoals(); // Refresh the medication list
  }

  Future<void> editGoal(Goal newGoal, Goal oldGoal) async {
    await SSIDatabase.instance.updateGoal(newGoal);
    await fetchGoals(); // Fetch goals after editing
  }

  Future<void> deleteGoal(Goal goal) async {
    await SSIDatabase.instance.deleteGoal(goal.id!);
    await fetchGoals(); // Fetch goals after deleting
  }

  //delete inactive goals - goals whose date has passed
  Future<void> deleteInactiveGoals() async {
    DateTime now = DateTime.now();
    _goals = await SSIDatabase.instance.readAllGoals();
    for (var goal in _goals) {
      if (goal.endDay.isBefore(now)) {
        await SSIDatabase.instance.deleteGoal(goal.id!);
      }
    }
    fetchGoals();
  }

  //get list of active goals
  List<Goal> getActiveGoals() {
    DateTime now = DateTime.now();
    return _goals.where((goal) => goal.endDay.isAfter(now)).toList();
  }
}
