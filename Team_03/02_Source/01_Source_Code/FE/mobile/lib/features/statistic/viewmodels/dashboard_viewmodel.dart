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
  Macronutrients macronutrients = Macronutrients(carbs: 0, protein: 0, fat: 0);
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

  int get carbsPercent => _calculateMacroPercent(macronutrients.carbs);
  int get proteinPercent => _calculateMacroPercent(macronutrients.protein);
  int get fatPercent => _calculateMacroPercent(macronutrients.fat);

  Future<void> fetchDashboardData({required String token}) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = createMockData();
      //final result = await apiService.fetchDashboardData(token);
      meals = result.meals;
      activities = result.activities;
      caloriesGoal = result.caloriesGoal;
      totalCaloriesConsumed = result.totalCaloriesConsumed;
      totalCaloriesBurned = result.totalCaloriesBurned;
      macronutrients = result.macronutrients;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeightStatistics(BuildContext context) async {
    try {
      final result = await apiService.fetchWeightStatistics(context);
      weightEntries = result;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchStepStatistics(BuildContext context) async {
    try {
      final result = await apiService.fetchStepStatistics(context);
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
      await fetchWeightStatistics(context);

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

      await fetchStepStatistics(context);

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

  Future<void> fetchWeightGoal(BuildContext context) async {
    try {
      final response = await _apiGoalService.getGoal(context);

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

  int _calculateMacroPercent(int macroValue) {
    final total =
        macronutrients.carbs + macronutrients.protein + macronutrients.fat;
    if (total == 0) return 0;
    return ((macroValue / total) * 100).toInt();
  }
}

DashboardLogModel createMockData() {
  return DashboardLogModel(
    caloriesGoal: 2000,
    totalCaloriesConsumed: 1200,
    totalCaloriesBurned: 400,
    macronutrients: Macronutrients(
      carbs: 150,
      protein: 100,
      fat: 50,
    ),
    meals: [
      MealLog(id: 1, name: "Breakfast", calories: 350),
      MealLog(id: 2, name: "Lunch", calories: 450),
      MealLog(id: 3, name: "Dinner", calories: 400),
    ],
    activities: [
      ActivityLog(id: 1, name: "Running", caloriesBurned: 300),
      ActivityLog(id: 2, name: "Cycling", caloriesBurned: 100),
    ],
  );
}
