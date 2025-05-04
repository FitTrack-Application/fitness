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
  double servingSize = 100;

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
    notifyListeners();
  }

  void updateServingUnitByName(String name) {
    print('🔍 Tìm đơn vị với tên: $name');
    try {
      final matchedUnit = _servingUnits.firstWhere(
            (unit) => unit.unitName.toLowerCase() == name.toLowerCase(),
      );
      selectedServingUnit = matchedUnit;
      print('✅ Tìm thấy đơn vị: ${matchedUnit.unitName}');
    } catch (e) {
      print('❗ Không tìm thấy đơn vị "$name", lỗi: $e');
      if (_servingUnits.isNotEmpty) {
        selectedServingUnit = _servingUnits.first;
        print('➡️ Sử dụng đơn vị mặc định: ${selectedServingUnit!.unitName}');
      } else {
        print('🚫 Không có đơn vị nào trong danh sách.');
      }
    }

    print('selectedServingUnit: ${selectedServingUnit?.unitName}');
    notifyListeners();
  }

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

  void updateServings(double newServings) {
    if (newServings >= 1 && newServings <= 10000) {
      servingSize = newServings;
      notifyListeners();
    }
  }

  void updateMealType(MealType mealType) {
    selectedMealType = mealType;
    notifyListeners();
  }

  Future<void> fetchAllServingUnits(String? servingUnit) async {
    loadState = LoadState.loading;
    notifyListeners();

    try {
      _servingUnits = await _repository.getAllServingUnits();
      updateServingUnitByName(servingUnit ?? 'Gram');
      // if (_servingUnits.isNotEmpty && selectedServingUnit == null) {
      //   selectedServingUnit = _servingUnits[0];
      // }
      loadState = LoadState.loaded;
    } catch (e) {
      errorMessage = e.toString();
      loadState = LoadState.error;
    }

    notifyListeners();
  }
}