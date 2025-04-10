import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';

class GoalViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Fields for goal data
  String goalType = "";
  double startingWeight = 0.0;
  double targetWeight = 0.0;
  double currentWeight = 0.0;
  double progress = 0.0;
  DateTime startingDay = DateTime.now();
  bool achievedStatus = false;
  double goalPerWeek = 0.0;
  // Fetch goal data from API
  Future<void> fetchGoal() async {
    try {
      final goalData = await _apiService.getGoal();

      // Update fields with API response
      goalType = goalData["goalType"] ?? "";
      startingWeight = goalData["startingWeight"] ?? 0.0;
      targetWeight = goalData["targetWeight"] ?? 0.0;
      currentWeight = goalData["currentWeight"] ?? 0.0;
      progress = goalData["progress"] ?? 0.0;
      startingDay = DateTime.parse(goalData["startingDay"] ?? DateTime.now().toString());
      achievedStatus = goalData["achievedStatus"] ?? false;
      goalPerWeek = goalData["goalPerWeek"] ?? 0.0;
      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching goal: $e");
      throw Exception("Failed to fetch goal data");
    }
  }
}