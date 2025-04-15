import 'dart:async';
import 'package:flutter/material.dart';

import '../models/food.dart';
import '../services/repository/food_repository.dart';

// Define possible loading states
enum LoadState { initial, loading, loaded, error, timeout }

class FoodDetailViewModel extends ChangeNotifier {
  final FoodRepository _repository;
  Food? food;
  int servings = 1;
  DateTime selectedDate = DateTime.now();
  MealType selectedMealType = MealType.Breakfast;

  LoadState loadState = LoadState.initial;
  String? errorMessage;

  // Timeout duration
  static const Duration _timeoutDuration = Duration(seconds: 10);

  FoodDetailViewModel(this._repository);

  Future<void> loadFood(String id) async {
    loadState = LoadState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getFoodById(id).timeout(_timeoutDuration,
          onTimeout: () {
            throw TimeoutException('Connection timed out. Please try again.');
          });

      food = result;

      // If this is an edit and the food has a meal type, use it
      if (food != null) {
        selectedMealType = food!.mealType;
      }

      loadState = LoadState.loaded;
    } on TimeoutException catch (e) {
      loadState = LoadState.timeout;
      errorMessage = e.message;
    } catch (e) {
      loadState = LoadState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void updateServings(int newServings) {
    if (newServings >= 1 && newServings <= 10000) {
      servings = newServings;
      notifyListeners();
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateMealType(MealType mealType) {
    selectedMealType = mealType;
    notifyListeners();
  }
}