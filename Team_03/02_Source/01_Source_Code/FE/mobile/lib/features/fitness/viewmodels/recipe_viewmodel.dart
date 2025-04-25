import 'package:flutter/material.dart';
import '../models/meal_log.dart';
import '../models/recipe.dart';
import '../models/food.dart';
import '../services/recipe_api_service.dart'; // Replace with your actual API service

class RecipeViewModel extends ChangeNotifier {
  final RecipeApiService _apiService = RecipeApiService();

  List<Recipe> _recipes = [];
  Recipe? _selectedRecipe;
  bool _isLoading = false;
  String? _errorMessage;

  List<Recipe> get recipes => _recipes;
  Recipe? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all recipes
  Future<void> fetchRecipes() async {
    _setLoading(true);
    try {
      _recipes = await _apiService.getAllRecipes();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  // Load recipe by ID
  Future<void> fetchRecipeById(String id) async {
    _setLoading(true);
    try {
      _selectedRecipe = await _apiService.fetchRecipeById(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  // Create a new recipe
  Future<bool> createRecipe(Recipe recipe) async {
    _setLoading(true);
    try {
      final created = await _apiService.createRecipe(recipe);
      _recipes.add(created);
      notifyListeners();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update existing recipe
  Future<bool> updateRecipe(Recipe updatedRecipe) async {
    _setLoading(true);
    try {
      final result = await _apiService.updateRecipe(updatedRecipe.id, updatedRecipe);
      final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
      if (index != -1) {
        _recipes[index] = result;
      }
      if (_selectedRecipe?.id == updatedRecipe.id) {
        _selectedRecipe = result;
      }
      notifyListeners();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete recipe
  Future<bool> deleteRecipe(String id) async {
    _setLoading(true);
    try {
      await _apiService.deleteRecipe(id);
      _recipes.removeWhere((r) => r.id == id);
      if (_selectedRecipe?.id == id) _selectedRecipe = null;
      notifyListeners();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearSelectedRecipe() {
    _selectedRecipe = null;
    notifyListeners();
  }

  void addFoodToSelectedRecipe(Food food) {
    _selectedRecipe?.foodList.add(food);
    notifyListeners();
  }

  void removeFoodFromSelectedRecipe(Food food) {
    _selectedRecipe?.foodList.remove(food);
    notifyListeners();
  }

  void updateServingSize(double newSize) {
    if (_selectedRecipe != null) {
      _selectedRecipe = Recipe(
        id: _selectedRecipe!.id,
        name: _selectedRecipe!.name,
        description: _selectedRecipe!.description,
        servingSize: newSize,
        calories: _selectedRecipe!.calories,
        carbs: _selectedRecipe!.carbs,
        fat: _selectedRecipe!.fat,
        protein: _selectedRecipe!.protein,
        unit: _selectedRecipe!.unit,
        foodList: _selectedRecipe!.foodList,
      );
      notifyListeners();
    }
  }
}


