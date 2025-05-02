import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../common/model/pagination.dart';
import '../../models/recipe.dart';

class RecipeRepository {
  String baseUrl = "http://172.20.224.1:8088";

  Future<Recipe> getRecipeById(String recipeId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/recipes/$recipeId'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      return Recipe.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<PaginatedResponse<Recipe>> searchRecipes(String name,
      {int page = 1, int size = 10}) async {
    final url = Uri.parse('$baseUrl/api/recipes?query=$name&page=$page&size=$size');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> recipeListJson = jsonBody['data'] ?? [];
      final Map<String, dynamic> paginationJson =
          jsonBody['metadata']?['pagination'] ?? {};

      final List<Recipe> recipes =
      recipeListJson.map((item) => Recipe.fromJson(item)).toList();

      return PaginatedResponse<Recipe>(
        message: jsonBody['generalMessage'] ?? 'Success',
        data: recipes,
        pagination: Pagination(
          currentPage: paginationJson['currentPage'] ?? 1,
          pageSize: paginationJson['pageSize'] ?? size,
          totalItems: paginationJson['totalItems'] ?? recipes.length,
          totalPages: paginationJson['totalPages'] ?? 1,
        ),
      );
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  Future<PaginatedResponse<Recipe>> searchMyRecipes(String name,
      {int page = 1, int size = 10}) async {
    // Return an empty list for "My Recipe"
    return PaginatedResponse<Recipe>(
      message: 'No data available for My Recipe',
      data: [],
      pagination: Pagination(
        currentPage: page,
        pageSize: size,
        totalItems: 0,
        totalPages: 1,
      ),
    );
  }

  /// Create a new recipe
  Future<Recipe> createRecipe(Recipe recipe) async {
    final url = Uri.parse('$baseUrl/api/recipes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': recipe.name,
        'description': recipe.description,
        'servingSize': recipe.servingSize,
        'unit': recipe.unit,
        'calories': recipe.calories,
        'carbs': recipe.carbs,
        'fat': recipe.fat,
        'protein': recipe.protein,
        'foodList': recipe.foodList.map((food) => food.toJson()).toList(),
      }),
    );

    if (response.statusCode == 201) {
      final jsonBody = json.decode(response.body);
      return Recipe.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to create recipe');
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/recipes/all'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> recipeListJson = jsonBody['data'] ?? [];

      return recipeListJson.map((item) => Recipe.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch all recipes');
    }
  }

  /// Update an existing recipe
  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    final url = Uri.parse('$baseUrl/api/recipes/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': recipe.name,
        'description': recipe.description,
        'servingSize': recipe.servingSize,
        'unit': recipe.unit,
        'calories': recipe.calories,
        'carbs': recipe.carbs,
        'fat': recipe.fat,
        'protein': recipe.protein,
        'foodList': recipe.foodList.map((food) => food.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Recipe.fromJson(jsonBody['data']);
    } else {
      throw Exception('Failed to update recipe');
    }
  }

  /// Delete a recipe
  Future<void> deleteRecipe(String id) async {
    final url = Uri.parse('$baseUrl/api/recipes/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipe');
    }
  }
}
