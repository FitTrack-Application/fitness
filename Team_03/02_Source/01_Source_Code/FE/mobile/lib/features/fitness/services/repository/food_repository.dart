import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../common/model/pagination.dart';
import '../../models/food.dart';

class FoodRepository {
  String baseUrl = "http://192.168.1.8:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYyNjM4NzYsImlhdCI6MTc0NjI2MDI3NiwianRpIjoib25ydHJvOjEwZDFkNjI3LTY1YTMtNDQ1Zi04NDk4LTk3ZWE0MmUyNjk4MyIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODg4OC9yZWFsbXMvbXktZml0bmVzcyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJmMWNlNWU2Mi0xZjM3LTRjNDYtOTA4Yy05MzVjOTFmZWVjN2UiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ0ZXN0LXdpdGgtdWkiLCJzaWQiOiJjYmFkNjkyYi1iZTYzLTQwZGUtODAyZi1iMDEyOTllMTAzMDciLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1teS1maXRuZXNzIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsIlVTRVIiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkZW1vQGdtYWlsLmNvbSIsImVtYWlsIjoiZGVtb0BnbWFpbC5jb20ifQ.Omd5Gcf6LjlEaVP9nSxE5qXdltbVGDbGkWg8x451qaFF3CRezYZr22spSZ7J2TjPvo_Jmp-X5S4xs27XgaWZNL5h256so4t4kO0s8SpQuXnPU3wYaXaNsrgX7MRfkfowFB7KoR0cVpx27Mow_3khqJp3eWEHqAdoipt_kE0y2lREx7KkNUzVwR8CQiyaDOUx45qViPUK4JobpS0T4ZpxlPLXUvFcEj7PCoxhzSyIfqJ8fJjbAsqkOsntpjdjl6e50KBlyAut049NUBV2y__RGr0NgB3C_HhuMrKmVxL3Vv5XOtN5nfw5WUgeJH7Fze90YsOWkNtGV5RXiRvbcZzKOA";

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  Future<Food> getFoodById(String foodId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/foods/$foodId'), headers: _headers);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'];
      return Food.fromJson(data);
    } else {
      throw Exception('Failed to load food data');
    }
  }

  Future<PaginatedResponse<Food>> searchFoods(String name,
      {int page = 1, int size = 10}) async {
    final url = Uri.parse(
        '$baseUrl/api/foods?query=$name&page=$page&size=$size');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> foodListJson = jsonBody['data'] ?? [];
      final Map<String, dynamic> paginationJson =
          jsonBody['metadata']?['pagination'] ?? {};

      final List<Food> foods =
      foodListJson.map((item) => Food.fromJson(item)).toList();

      return PaginatedResponse<Food>(
        message: jsonBody['generalMessage'] ?? 'Success',
        data: foods,
        pagination: Pagination(
          currentPage: paginationJson['currentPage'] ?? 1,
          pageSize: paginationJson['pageSize'] ?? size,
          totalItems: paginationJson['totalItems'] ?? foods.length,
          totalPages: paginationJson['totalPages'] ?? 1,
        ),
      );
    } else {
      throw Exception('Failed to fetch foods');
    }
  }

  Future<PaginatedResponse<Food>> searchMyFoods(String name,
      {int page = 1, int size = 10}) async {
    // Return an empty list for "My Food"
    return PaginatedResponse<Food>(
      message: 'No data available for My Food',
      data: [],
      pagination: Pagination(
        currentPage: page,
        pageSize: size,
        totalItems: 0,
        totalPages: 1,
      ),
    );
  }

 // Future<void> searchMyRecipes(String query, {required int page, required int size}) {}
}
