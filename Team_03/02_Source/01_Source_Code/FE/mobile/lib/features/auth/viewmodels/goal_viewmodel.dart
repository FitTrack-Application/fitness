import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';

class GoalViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Fields for goal data
  String goalType = '';
  double startingWeight = 0.0;
  double currentWeight = 0.0;
  double targetWeight = 0.0;
  double goalPerWeek = 0.0;
  DateTime startingDay = DateTime.now();
  String activityLevel = '';

  bool isLoading = false;
  String? errorMessage;

  // Fetch goal data from the API
  Future<void> fetchGoal() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getGoal();

      // Extract the "data" field from the response
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        final goalData = response['data'];

        startingWeight = goalData['startingWeight'];
        currentWeight = goalData['currentWeight'];
        targetWeight = goalData['goalWeight'];
        goalPerWeek = goalData['weeklyGoal'];
        startingDay = DateTime.parse(goalData['startingDate']);
        activityLevel = goalData['activityLevel'];
        goalType = _determineGoalType(startingWeight, targetWeight);
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

  // Determine goal type based on starting and target weights
  String _determineGoalType(double startingWeight, double targetWeight) {
    if (startingWeight > targetWeight) {
      return "Lose weight";
    } else if (startingWeight < targetWeight) {
      return "Gain weight";
    } else {
      return "Maintain weight";
    }
  }
}
