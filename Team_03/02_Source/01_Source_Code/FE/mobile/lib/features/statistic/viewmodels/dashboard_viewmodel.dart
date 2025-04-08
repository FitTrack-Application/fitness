import 'package:flutter/material.dart';

import '../models/dashboard.dart';
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

  int get caloriesRemaining => caloriesGoal - totalCaloriesConsumed; //+ totalCaloriesBurned;

  int get carbsPercent => _calculateMacroPercent(macronutrients.carbs);
  int get proteinPercent => _calculateMacroPercent(macronutrients.protein);
  int get fatPercent => _calculateMacroPercent(macronutrients.fat);

  Future<void> fetchDashboardData({required String token}) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await apiService.fetchDashboardData(token);
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

  int _calculateMacroPercent(int macroValue) {
    final total = macronutrients.carbs + macronutrients.protein + macronutrients.fat;
    if (total == 0) return 0;
    return ((macroValue / total) * 100).toInt();
  }
}
