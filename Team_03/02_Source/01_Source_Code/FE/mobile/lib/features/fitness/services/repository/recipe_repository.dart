import 'package:dio/dio.dart';
import '../../../../common/model/pagination.dart';
import '../../../../cores/utils/dio/dio_client.dart';
import '../../models/recipe.dart';
import '../../models/serving_unit.dart';

class RecipeRepository {
  final Dio _dio = DioClient().dio;

  Future<Recipe> getRecipeById(String id) async {
    try {
      print('📤 Requesting getRecipeById with id: $id');

      final response = await _dio.get('/api/recipes/$id');
      final data = response.data['data'];

      print('✅ Response received for getRecipeById: ${data['name']}');
      return Recipe.fromJson(data);
    } catch (e, stack) {
      print('🔥 Exception during getRecipeById: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<PaginatedResponse<Recipe>> searchRecipes(
      String name, {
        int page = 1,
        int size = 10,
      }) async {
    try {
      print('📤 Requesting searchRecipes with name="$name", page=$page, size=$size');

      final response = await _dio.get(
        '/api/recipes/',
        queryParameters: {
          'query': name,
          'page': page,
          'size': size,
        },
      );

      final data = response.data;
      final List<dynamic> recipeListJson = data['data'] ?? [];
      final Map<String, dynamic> paginationJson = data['metadata']?['pagination'] ?? {};

      print('✅ Response received for searchRecipes, total: ${recipeListJson.length}');

      final recipes = recipeListJson.map((item) => Recipe.fromJson(item)).toList();

      return PaginatedResponse<Recipe>(
        message: data['generalMessage'] ?? 'Success',
        data: recipes,
        pagination: Pagination(
          currentPage: paginationJson['currentPage'] ?? page,
          pageSize: paginationJson['pageSize'] ?? size,
          totalItems: paginationJson['totalItems'] ?? recipes.length,
          totalPages: paginationJson['totalPages'] ?? 1,
        ),
      );
    } catch (e, stack) {
      print('🔥 Exception during searchRecipes: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      print('📤 Creating recipe: ${recipe.name}');

      final response = await _dio.post(
        '/api/recipes/',
        data: recipe.toJson(), // You'll need to implement toJson in Recipe
      );

      final data = response.data['data'];
      print('✅ Recipe created: ${data['name']}');
      return Recipe.fromJson(data);
    } catch (e, stack) {
      print('🔥 Exception during createRecipe: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      print('🗑️ Deleting recipe with id: $id');
      await _dio.delete('/api/recipes/$id');
      print('✅ Recipe deleted');
    } catch (e, stack) {
      print('🔥 Exception during deleteRecipe: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<Recipe> updateRecipe(String id, Recipe recipe) async {
    try {
      print('📤 Updating recipe with id: $id');

      final response = await _dio.put(
        '/api/recipes/$id',
        data: recipe.toJson(), // You need to define toJson in Recipe
      );

      final data = response.data['data'];
      print('✅ Recipe updated: ${data['name']}');
      return Recipe.fromJson(data);
    } catch (e, stack) {
      print('🔥 Exception during updateRecipe: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<List<ServingUnit>> getAllServingUnits() async {
    try {
      print('📤 Requesting getAllServingUnits');

      final response = await _dio.get('/api/serving-units');
      final List<dynamic> list = response.data['data'] ?? [];

      print('✅ Total serving units fetched: ${list.length}');
      return list.map((item) => ServingUnit.fromJson(item)).toList();
    } catch (e, stack) {
      print('🔥 Error in getAllServingUnits: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }
}
