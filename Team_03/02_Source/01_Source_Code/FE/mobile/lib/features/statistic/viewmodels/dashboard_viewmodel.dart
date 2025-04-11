import 'package:flutter/material.dart';

import '../models/dashboard.dart';
import '../models/weight_entry.dart';
import '../services/dashboard_api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardApiService apiService;

  DashboardViewModel(this.apiService);

  bool isLoading = false;
  String? errorMessage;

  List<MealLog> meals = [];
  List<ActivityLog> activities = [];
  int totalCaloriesConsumed = 0;
  int totalCaloriesBurned = 0;
  Macronutrients macronutrients = Macronutrients(carbs: 0, protein: 0, fat: 0);
  int caloriesGoal = 0;

  List<WeightEntry> weightEntries = []; 

  int get caloriesRemaining => caloriesGoal - totalCaloriesConsumed; //+ totalCaloriesBurned;

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

  Future<void> fetchWeightStatistics({required String token}) async {
    try {
      final result = await apiService.fetchWeightStatistics(token);
      weightEntries = result;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
  int _calculateMacroPercent(int macroValue) {
    final total = macronutrients.carbs + macronutrients.protein + macronutrients.fat;
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
