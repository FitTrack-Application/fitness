import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';
import 'package:mobile/features/auth/models/user_goal.dart';

class GoalViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // UserGoal instance
  UserGoal userGoal = UserGoal(
    startingWeight: 0.0,
    currentWeight: 0.0,
    goalWeight: 0.0,
    startingDate: DateTime.now(),
    weeklyGoal: 0.0,
    activityLevel: "",
  ); // Initialize with a default instance

  bool isLoading = false;
  String? errorMessage;

  // Fetch goal data from the API
  Future<void> fetchGoal() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getGoal();

      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        final goalData = response['data'];
        userGoal = UserGoal.fromJson(goalData);
      } else {
        throw Exception(
            "Invalid response format: 'data' field is missing or invalid");
      }
    } catch (e) {
      errorMessage = "Failed to fetch goal data";
      debugPrint("Error fetching goal: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editGoal(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final goalData = userGoal.toJson();

      await _apiService.editGoal(goalData);

      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to edit goal";
      debugPrint("Error editing goal: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Determine the type of goal based on current and goal weight
  String determineGoalType() {
    if (userGoal.currentWeight > userGoal.goalWeight) {
      return "Weight Loss";
    } else if (userGoal.currentWeight < userGoal.goalWeight) {
      return "Weight Gain";
    } else {
      return "Weight Maintenance";
    }
  }
}
