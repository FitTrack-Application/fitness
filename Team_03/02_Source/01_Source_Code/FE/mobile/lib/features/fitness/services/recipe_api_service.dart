import 'package:mobile/features/fitness/services/repository/recipe_repository.dart';
import '../models/recipe.dart';
import '../../../../common/model/pagination.dart';

class RecipeApiService {
  final RecipeRepository _recipeRepository;

  RecipeApiService({RecipeRepository? repository})
      : _recipeRepository = repository ?? RecipeRepository();

  /// Fetch a recipe by ID
  Future<Recipe> fetchRecipeById(String recipeId) async {
    try {
      return await _recipeRepository.getRecipeById(recipeId);
    } catch (e) {
      throw Exception("Failed to fetch recipe: $e");
    }
  }

  /// Search public recipes
  Future<PaginatedResponse<Recipe>> searchRecipes(
      String query, {
        int page = 1,
        int size = 10,
      }) async {
    try {
      return await _recipeRepository.searchRecipes(query, page: page, size: size);
    } catch (e) {
      throw Exception("Failed to search recipes: $e");
    }
  }

  /// Search user-created recipes
  Future<PaginatedResponse<Recipe>> searchMyRecipes(
      String query, {
        int page = 1,
        int size = 10,
      }) async {
    try {
      return await _recipeRepository.searchMyRecipes(query, page: page, size: size);
    } catch (e) {
      throw Exception("Failed to search my recipes: $e");
    }
  }

  /// Create a new recipe
  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      return await _recipeRepository.createRecipe(recipe);
    } catch (e) {
      throw Exception("Failed to create recipe: $e");
    }
  }

  /// Update an existing recipe
  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    try {
      return await _recipeRepository.updateRecipe(id, recipe);
    } catch (e) {
      throw Exception("Failed to update recipe: $e");
    }
  }

  /// Get all recipes without filtering or pagination
  Future<List<Recipe>> getAllRecipes() async {
    try {
      return await _recipeRepository.getAllRecipes();
    } catch (e) {
      throw Exception("Failed to get all recipes: $e");
    }
  }


  /// Delete a recipe by ID
  Future<void> deleteRecipe(String id) async {
    try {
      return await _recipeRepository.deleteRecipe(id);
    } catch (e) {
      throw Exception("Failed to delete recipe: $e");
    }
  }
}
