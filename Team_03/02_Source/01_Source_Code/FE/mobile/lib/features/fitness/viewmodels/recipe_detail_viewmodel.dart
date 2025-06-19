import 'package:flutter/material.dart';
import 'package:mobile/features/fitness/services/repository/recipe_repository.dart';
import '../models/recipe.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  final Recipe recipe;
  final String mealLogId;
  RecipeRepository repository;
  bool isLoading = false;
  String? errorMessage;

  RecipeDetailViewModel({required this.recipe,required this.repository,required this.mealLogId});

  Future<bool> deleteRecipe(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository.deleteRecipe(recipe.id);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addTodiary(Recipe recipe) async {
    try {
      isLoading = true;
      notifyListeners();
      await repository.addRecipeToLog(recipe,mealLogId);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
