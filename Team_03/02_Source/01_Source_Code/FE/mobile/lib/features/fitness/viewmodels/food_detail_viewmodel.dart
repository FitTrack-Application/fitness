import 'dart:async';
import 'package:flutter/material.dart';

import '../models/food.dart';
import '../models/meal_log.dart';
import '../models/serving_unit.dart';
import '../services/repository/food_repository.dart';

// Define possible loading states
enum LoadState { initial, loading, loaded, error, timeout }

class FoodDetailViewModel extends ChangeNotifier {
  final FoodRepository _repository;
  Food? food;
  double _servingSize = 100;
  double get servingSize => _servingSize;

  List<ServingUnit> _servingUnits = [];

  List<ServingUnit> get servingUnits => _servingUnits;

  MealType _selectedMealType = MealType.breakfast;

  MealType get selectedMealType => _selectedMealType;

  set selectedMealType(MealType value) {
    if (_selectedMealType != value) {
      _selectedMealType = value;
      notifyListeners();
    }
  }

  ServingUnit? selectedServingUnit;

  void updateServingUnit(ServingUnit unit) {
    selectedServingUnit = unit;
    print('_servingSize: $_servingSize');
    print('selectedServingUnit.name: ${selectedServingUnit?.unitName}');
    loadFood(food?.id ?? '', servingUnitId: unit.id, numberOfServings: servingSize);
    notifyListeners();
  }

  void updateServingSize(double size) {
    if (size >= 1 && size <= 1000000) {
      _servingSize = size;
      loadFood(food?.id ?? '', servingUnitId: selectedServingUnit?.id ?? '9b0f9cf0-1c6e-4c1e-a3a1-8a9fddc20a0ba', numberOfServings: _servingSize);
      notifyListeners();
    }
  }

  void updateServingUnitById(String name) {
    try {
      final matchedUnit = _servingUnits.firstWhere(
        (unit) => unit.id.toLowerCase() == name.toLowerCase(),
      );
      selectedServingUnit = matchedUnit;
    } catch (e) {
      if (_servingUnits.isNotEmpty) {
        selectedServingUnit = _servingUnits.first;
      } else {
        print('🚫 Không có đơn vị nào trong danh sách.');
      }
    }
    notifyListeners();
  }

  LoadState loadState = LoadState.initial;
  String? errorMessage;

  // Timeout duration
  static const Duration _timeoutDuration = Duration(seconds: 10);

  FoodDetailViewModel(this._repository);

  Future<void> loadFood(
    String foodId, {
    String servingUnitId = "",
    double numberOfServings = 100,
  }) async {
    loadState = LoadState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      // Get default serving unit if not provided
      if (servingUnitId.isEmpty){
        final servingUnitList = await _repository.getAllServingUnits();
        if (servingUnitList.isNotEmpty) {
          servingUnitId = servingUnitList.first.id;
        }
      }

      final result = await _repository
          .getFoodById(foodId,
              servingUnitId: servingUnitId, numberOfServings: numberOfServings)
          .timeout(_timeoutDuration, onTimeout: () {
        throw TimeoutException('Connection timed out. Please try again.');
      });

      food = result;

      loadState = LoadState.loaded;
    } on TimeoutException catch (e) {
      loadState = LoadState.timeout;
      errorMessage = e.message;
    } catch (e) {
      loadState = LoadState.error;
      errorMessage = e.toString();
    } finally {
      print('new calories: ${food?.calories}');
      notifyListeners();
    }
  }

  // void updateMealType(MealType mealType) {
  //   selectedMealType = mealType;
  //   notifyListeners();
  // }

  Future<void> fetchAllServingUnits(String? servingUnitId) async {
    loadState = LoadState.loading;
    notifyListeners();

    try {
      _servingUnits = await _repository.getAllServingUnits();
      updateServingUnitById(servingUnitId ?? _servingUnits.first.id);
      loadState = LoadState.loaded;
    } catch (e) {
      errorMessage = e.toString();
      loadState = LoadState.error;
    }

    notifyListeners();
  }
}
