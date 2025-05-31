import 'package:flutter/material.dart';

import '../models/dashboard.dart';
import '../models/weight_entry.dart';
import '../models/step_entry.dart';
import '../services/dashboard_api_service.dart';
import 'package:mobile/features/auth/services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardApiService apiService;
  final ApiService _apiGoalService = ApiService();
  DashboardViewModel(this.apiService);

  bool isLoading = false;
  String? errorMessage;

  List<MealLog> meals = [];
  List<ActivityLog> activities = [];
  int totalCaloriesConsumed = 0;
  int totalCaloriesBurned = 0;
  int caloriesGoal = 0;
  double targetWeight = 70;
  List<WeightEntry> weightEntries = [
    WeightEntry(date: DateTime.now(), weight: 0), // Example default entry
  ];
  List<StepEntry> stepEntries = [
    StepEntry(date: DateTime.now(), steps: 0), // Example default entr
  ];
  int get caloriesRemaining =>
      caloriesGoal - totalCaloriesConsumed; //+ totalCaloriesBurned;

  Future<void> fetchDashboardData({required String token}) async {
    isLoading = true;
    notifyListeners();

    try {
      //final result = createMockData();
      final result = await apiService.fetchDashboardData();

      caloriesGoal = result.caloriesGoal;
      totalCaloriesConsumed = result.totalCaloriesConsumed;
      totalCaloriesBurned = result.totalCaloriesBurned;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeightStatistics() async {
    try {
      final result = await apiService.fetchWeightStatistics();
      weightEntries = result;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchStepStatistics() async {
    try {
      final result = await apiService.fetchStepStatistics();
      stepEntries = result;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Add a new weight log
  Future<void> addWeightLog({
    required BuildContext context,
    required double weight,
    required String date,
    String? progressPhoto,
  }) async {
    if (weight < 20 || weight > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weight must be between 20 and 200 kg'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await apiService.addWeightLog(
        weight: weight,
        date: date,
        progressPhoto: progressPhoto,
      );

      // Update the local list and notify listeners
      await fetchWeightStatistics();

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weight log added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error adding weight log: $e');

      // Show error notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add weight log. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add a new step log
  Future<void> addStepLog({
    required BuildContext context,
    required int steps,
    required String date,
  }) async {
    if (steps < 0 || steps > 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Steps must be between 0 and 10,000'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await apiService.addStepLog(
        steps: steps,
        date: date,
      );

      await fetchStepStatistics();

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Step log added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error adding step log: $e');

      // Show error notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add step log. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchWeightGoal() async {
    try {
      final response = await _apiGoalService.getGoal();

      // Extract the "data" field from the response
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        final goalData = response['data'];

        targetWeight = goalData['goalWeight'];
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

}
