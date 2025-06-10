import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/food.dart';
import '../models/recipe.dart';
import '../services/repository/food_repository.dart';
import '../services/repository/recipe_repository.dart';

enum TabType { all, myRecipes, myFoods }

class SearchFoodViewModel extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final RecipeRepository _recipeRepository;


  final List<Food> _foods = [];
  final List<Recipe> _recipes = [];
  final List<Food> _myFoods = [];

  final Duration _timeout = const Duration(seconds: 15);

  SearchFoodViewModel({
    FoodRepository? foodRepository,
    RecipeRepository? recipeRepository,
  })  : _foodRepository = foodRepository ?? FoodRepository(),
        _recipeRepository = recipeRepository ?? RecipeRepository();

  List<Food> get foods => _foods;
  List<Recipe> get recipes => _recipes;
  List<Food> get myFoods => _myFoods;

  bool isLoading = false;
  bool isFetchingMore = false;
  String searchQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;
  String _errorMessage = '';
  String _loadMoreError = '';

  bool get hasMoreData => _hasMoreData;
  String get errorMessage => _errorMessage;
  String get loadMoreError => _loadMoreError;

  /// Main search function for all three tabs
  Future<void> searchFoods({
    String query = '',
    required TabType tabType,
  }) async {
    if (isLoading) return;

    _errorMessage = '';
    isLoading = true;
    searchQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();

    try {
      switch (tabType) {
        case TabType.all:
          final response = await _fetchWithTimeout(() =>
              _foodRepository.searchFoods(query, page: _currentPage, size: 10));
          _foods.clear();
          _foods.addAll(response.data);
          _totalPages = response.pagination.totalPages;
          break;

        case TabType.myRecipes:
          final response = await _fetchWithTimeout(() =>
              _recipeRepository.searchRecipes(query, page: _currentPage, size: 10));
          _recipes.clear();
          _recipes.addAll(response.data);
          _totalPages = response.pagination.totalPages;
          break;

        case TabType.myFoods:
          final response = await _fetchWithTimeout(() =>
              _foodRepository.searchMyFoods(query, page: _currentPage, size: 10));
          _myFoods.clear();
          _myFoods.addAll(response.data);
          _totalPages = response.pagination.totalPages;
          break;
      }

      _hasMoreData = _currentPage < _totalPages;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      debugPrint('Error searching ($tabType): $e');
    }

    isLoading = false;
    notifyListeners();
  }

  /// Load more for pagination
  Future<void> loadMoreFoods({
    required TabType tabType,
    int size = 10,
  }) async {
    if (isFetchingMore || !_hasMoreData) return;

    _loadMoreError = '';
    isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;

      switch (tabType) {
        case TabType.all:
          final response = await _fetchWithTimeout(() =>
              _foodRepository.searchFoods(searchQuery, page: _currentPage, size: size));
          if (response.data.isEmpty) {
            _hasMoreData = false;
          } else {
            _foods.addAll(response.data);
            _totalPages = response.pagination.totalPages;
            _hasMoreData = _currentPage < _totalPages;
          }
          break;

        case TabType.myRecipes:
          final response = await _fetchWithTimeout(() =>
              _recipeRepository.searchRecipes(searchQuery, page: _currentPage, size: size));
          if (response.data.isEmpty) {
            _hasMoreData = false;
          } else {
            _recipes.addAll(response.data);
            _totalPages = response.pagination.totalPages;
            _hasMoreData = _currentPage < _totalPages;
          }
          break;

        case TabType.myFoods:
          final response = await _fetchWithTimeout(() =>
              _foodRepository.searchMyFoods(searchQuery, page: _currentPage, size: size));
          if (response.data.isEmpty) {
            _hasMoreData = false;
          } else {
            _myFoods.addAll(response.data);
            _totalPages = response.pagination.totalPages;
            _hasMoreData = _currentPage < _totalPages;
          }
          break;
      }
    } catch (e) {
      _loadMoreError = _getErrorMessage(e);
      _currentPage--;
      debugPrint('Error loading more ($tabType): $e');
    }

    isFetchingMore = false;
    notifyListeners();
  }

  /// Timeout wrapper
  Future<T> _fetchWithTimeout<T>(Future<T> Function() fetchFunction) async {
    try {
      return await fetchFunction().timeout(_timeout);
    } on TimeoutException {
      throw TimeoutException('Request timed out. Please check your connection and try again.');
    }
  }

  /// Friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    } else if (error.toString().contains('HttpException')) {
      return 'Server error occurred. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  void addRecipeToList(Recipe recipe) {
    _recipes.insert(0, recipe);
    notifyListeners();
  }

  void addMyFoodToList(Food food) {
    _myFoods.insert(0, food);
    notifyListeners();
  }

  Future<bool> removeFood(Food food) async {
    try {
      await _foodRepository.deleteFood(food.id);
      _myFoods.removeWhere((item) => item.id == food.id); // Remove from local list
      notifyListeners();
      return true; // Deletion successful
    } catch (e) {
      debugPrint('Error deleting food: $e');
      return false; // Deletion failed
    }
  }

  Future<bool> addRecipeToDiary(Recipe recipe) async {
    try {
      await _recipeRepository.addRecipeToLog(recipe,'');
      _myFoods.removeWhere((item) => item.id == recipe.id); // Remove from local list
      notifyListeners();
      return true; // Deletion successful
    } catch (e) {
      debugPrint('Error deleting food: $e');
      return false; // Deletion failed
    }
  }

  Future<void> loadInitialData() async {
    await searchFoods(query: '', tabType: TabType.all);
    await searchFoods(query: '', tabType: TabType.myRecipes);
    await searchFoods(query: '', tabType: TabType.myFoods);
  }
}
