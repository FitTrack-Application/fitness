import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/food.dart';
import '../models/meal_log.dart';
import '../models/recipe.dart';
import '../models/serving_unit.dart';
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
        // final paginatedResponse = await _fetchWithTimeout(() =>
        //     _recipeRepository.searchMyRecipes(query, page: _currentPage, size: 10));
        //
        // _recipes.clear();
        // _recipes.addAll(paginatedResponse.data);
        // _totalPages = paginatedResponse.pagination.totalPages;

        //Mock data
        _recipes.clear();
        _recipes.addAll(_getMockRecipes);
        _totalPages = 1;
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
        // final paginatedResponse = await _fetchWithTimeout(() =>
        //     _recipeRepository.searchMyRecipes(searchQuery, page: _currentPage, size: size));
        //
        // if (paginatedResponse.data.isEmpty) {
        //   _hasMoreData = false;
        // } else {
        //   _recipes.addAll(paginatedResponse.data);
        //   _totalPages = paginatedResponse.pagination.totalPages;
        //   _hasMoreData = _currentPage < _totalPages;
        // }

        //Mock data

        _hasMoreData = false; // Simulate no pagination for mock
        _recipes.addAll(_getMockRecipes);
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

final List<Recipe> _getMockRecipes = [
  Recipe(
    id: 'r001',
    name: 'Grilled Chicken Salad',
    description: 'A healthy salad packed with protein.',
    servingSize: 250,
    calories: 320,
    carbs: 12,
    fat: 15,
    protein: 35,
    unit: 'grams',
    foodList: [
      Food(
          id: 'f001',
          name: 'Grilled Chicken Breast',
          calories: 220,
          carbs: 0,
          fat: 6,
          protein: 32,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.lunch,
          ),
      Food(
          id: 'f002',
          name: 'Mixed Greens',
          calories: 20,
          carbs: 4,
          fat: 0.5,
          protein: 2,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.lunch,
          ),
      Food(
          id: 'f003',
          name: 'Olive Oil',
          calories: 80,
          carbs: 0,
          fat: 9,
          protein: 0,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.lunch,
          ),
    ],
  ),
  Recipe(
    id: 'r002',
    name: 'Oatmeal Banana Bowl',
    description: 'A fiber-rich breakfast bowl.',
    servingSize: 200,
    calories: 290,
    carbs: 45,
    fat: 6,
    protein: 8,
    unit: 'grams',
    foodList: [
      Food(
          id: 'f004',
          name: 'Rolled Oats',
          calories: 190,
          carbs: 33,
          fat: 3.5,
          protein: 5,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.breakfast,
          ),
      Food(
          id: 'f005',
          name: 'Banana',
          calories: 89,
          carbs: 23,
          fat: 0.3,
          protein: 1.1,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.breakfast,
          ),
    ],
  ),
  Recipe(
    id: 'r003',
    name: 'Protein Pancakes',
    description: 'Low-carb pancakes with whey protein.',
    servingSize: 180,
    calories: 310,
    carbs: 18,
    fat: 10,
    protein: 30,
    unit: 'grams',
    foodList: [
      Food(
          id: 'f006',
          name: 'Whey Protein',
          calories: 120,
          carbs: 3,
          fat: 2,
          protein: 24,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.breakfast,
          ),
      Food(
          id: 'f007',
          name: 'Eggs',
          calories: 140,
          carbs: 1,
          fat: 10,
          protein: 12,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.breakfast,
          ),
    ],
  ),
  Recipe(
    id: 'r004',
    name: 'Beef Stir Fry',
    description: 'High-protein stir-fried beef with vegetables.',
    servingSize: 300,
    calories: 400,
    carbs: 20,
    fat: 22,
    protein: 35,
    unit: 'grams',
    foodList: [
      Food(
          id: 'f008',
          name: 'Beef Strips',
          calories: 300,
          carbs: 0,
          fat: 20,
          protein: 30,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.dinner,
          ),
      Food(
          id: 'f009',
          name: 'Bell Peppers',
          calories: 40,
          carbs: 9,
          fat: 0.5,
          protein: 1,
          imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
          // mealType: MealType.dinner,
          ),
    ],
  ),
  Recipe(
    id: 'r005',
    name: 'Tuna Sandwich',
    description: 'Simple tuna sandwich for lunch.',
    servingSize: 220,
    calories: 350,
    carbs: 30,
    fat: 12,
    protein: 25,
    unit: 'grams',
    foodList: [
      Food(
        id: 'f010',
        name: 'Whole Grain Bread',
        calories: 230,
        carbs: 28,
        fat: 4,
        protein: 9,
        imageUrl: '',
        servingUnit: ServingUnit(
          id: '1',
          unitName: 'Slice',
          unitSymbol: 's',
        ),
        numberOfServings: 1,
        // mealType: MealType.lunch,
      ),
      Food(
          id: 'f011',
          name: 'Canned Tuna',
          calories: 120,
          carbs: 2,
          fat: 8,
          protein: 16,
          servingUnit: ServingUnit(
            id: '1',
            unitName: 'Slice',
            unitSymbol: 's',
          ),
          numberOfServings: 1,
          imageUrl: ''
          // mealType: MealType.lunch,
          ),
    ],
  ),
];
