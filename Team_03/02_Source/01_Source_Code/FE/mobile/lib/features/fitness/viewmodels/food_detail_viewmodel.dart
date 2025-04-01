import 'package:flutter/cupertino.dart';

import '../models/food.dart';
import '../services/food_repository.dart';

class FoodDetailViewModel extends ChangeNotifier {
  final FoodRepository _repository;
  Food? food;
  int servings = 1;
  DateTime selectedDate = DateTime.now();

  FoodDetailViewModel(this._repository);

  Future<void> loadFood(int id) async {
    food = await _repository.getFoodById(id);
    notifyListeners();
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
}