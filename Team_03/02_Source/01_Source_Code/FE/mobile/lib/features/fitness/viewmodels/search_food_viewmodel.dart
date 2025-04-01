import 'package:flutter/cupertino.dart';

import '../models/food.dart';
import '../services/food_repository.dart';

class SearchFoodViewModel extends ChangeNotifier {
  final FoodRepository _repository = FoodRepository();
  final List<Food> _foods = [];

  List<Food> get foods => _foods;

  bool isLoading = false;
  bool isFetchingMore = false;
  String _searchQuery = '';

  Future<void> loadFoods({int offset = 0}) async {
    if (isFetchingMore) return;
    isFetchingMore = true;
    notifyListeners();

    final newFoods = await _repository.fetchFoods(offset: offset);
    _foods.addAll(newFoods);

    isFetchingMore = false;
    filterFoods();
  }

  List<Food> _filteredFoods = [];

  List<Food> get filteredFoods => _filteredFoods;

  void filterFoods({String query = ''}) {
    _searchQuery = query;
    _filteredFoods = _foods
        .where((food) =>
        food.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    notifyListeners();
  }
}