import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/food.dart';
import '../models/recipe.dart';
import '../services/repository/food_repository.dart';
import '../services/repository/recipe_repository.dart';

class SearchFoodViewModel extends ChangeNotifier {
  final FoodRepository _foodRepository;
  final RecipeRepository _recipeRepository;

  final List<Food> _foods = [];
  final List<Recipe> _recipes = [];

  final Duration _timeout = const Duration(seconds: 15);

  SearchFoodViewModel({
    FoodRepository? foodRepository,
    RecipeRepository? recipeRepository,
  })  : _foodRepository = foodRepository ?? FoodRepository(),
        _recipeRepository = recipeRepository ?? RecipeRepository();

  List<Food> get foods => _foods;

  List<Recipe> get recipes => _recipes;

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

  /// Main search function supporting All Foods and My Recipes
  Future<void> searchFoods({
    String query = '',
    bool isInMyRecipesTab = true,
  }) async {
    if (isLoading) return;

    _errorMessage = '';
    isLoading = true;
    searchQuery = query;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();

    try {
      if (isInMyRecipesTab) {
        final paginatedResponse = await _fetchWithTimeout(() =>
            _recipeRepository.searchRecipes(query, page: _currentPage, size: 10));

        _recipes.clear();
        _recipes.addAll(paginatedResponse.data);
        _totalPages = paginatedResponse.pagination.totalPages;

      } else {
        final paginatedResponse = await _fetchWithTimeout(() =>
            _foodRepository.searchFoods(query, page: _currentPage, size: 10));

        _foods.clear();
        _foods.addAll(paginatedResponse.data);
        _totalPages = paginatedResponse.pagination.totalPages;
      }

      _currentPage = 1;

      _hasMoreData = _currentPage < _totalPages;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      debugPrint('Error searching: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  /// Load more items for pagination
  Future<void> loadMoreFoods({
    int size = 10,
    bool isMyFood = true,
  }) async {
    if (isFetchingMore || !_hasMoreData) return;

    _loadMoreError = '';
    isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      if (isMyFood) {
        final paginatedResponse = await _fetchWithTimeout(() =>
            _recipeRepository.searchRecipes(searchQuery, page: _currentPage, size: size));

        if (paginatedResponse.data.isEmpty) {
          _hasMoreData = false;
        } else {
          _recipes.addAll(paginatedResponse.data);
          _totalPages = paginatedResponse.pagination.totalPages;
          _hasMoreData = _currentPage < _totalPages;
        }

      } else {
        final paginatedResponse = await _fetchWithTimeout(() => _foodRepository
            .searchFoods(searchQuery, page: _currentPage, size: size));

        if (paginatedResponse.data.isEmpty) {
          _hasMoreData = false;
        } else {
          _foods.addAll(paginatedResponse.data);
          _totalPages = paginatedResponse.pagination.totalPages;
          _hasMoreData = _currentPage < _totalPages;
        }
      }
    } catch (e) {
      _loadMoreError = _getErrorMessage(e);
      _currentPage--;
      debugPrint('Error loading more: $e');
    }

    isFetchingMore = false;
    notifyListeners();
  }

  /// Add timeout wrapper
  Future<T> _fetchWithTimeout<T>(Future<T> Function() fetchFunction) async {
    try {
      return await fetchFunction().timeout(_timeout);
    } on TimeoutException {
      throw TimeoutException(
          'Request timed out. Please check your connection and try again.');
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
    recipes.insert(0, recipe); // Add it to the beginning of the list
    notifyListeners();
  }
}