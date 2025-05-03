import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../common/model/pagination.dart';
import '../../models/food.dart';

class FoodRepository {
  String baseUrl = "http://192.168.1.8:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYyNjc1NDAsImlhdCI6MTc0NjI2Mzk0MCwianRpIjoib25ydHJvOmE4MTJkY2Q4LTBkNmUtNDUzNS04YThiLWY2MGYzMzEzMTgwYyIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODg4OC9yZWFsbXMvbXktZml0bmVzcyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJmMWNlNWU2Mi0xZjM3LTRjNDYtOTA4Yy05MzVjOTFmZWVjN2UiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ0ZXN0LXdpdGgtdWkiLCJzaWQiOiJlMjQ2OWJiNC0yM2IzLTQ3MTItOTM3MC03MmJmNGI0ZGFhYmIiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1teS1maXRuZXNzIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsIlVTRVIiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkZW1vQGdtYWlsLmNvbSIsImVtYWlsIjoiZGVtb0BnbWFpbC5jb20ifQ.PjN7YC9b3X-SXTm-0dnj_dUJgu7Z0roJth5gpZP6TRQJXavQ2ENqhzSOpqGxTIXMBKi4hnY8k6THPlYLUWMqWZPXCQtubQcNZ-2D5gv7dnTH-S-JsERcM19zJImIMQuUNS9vsy6v7AN7gkOjPjJj5haYHiQmqvJrC_U5ZVMB0RqseGNEbmWQQC4sxmmj_UVfOX1GX9VGdDyPnmvSjg8bm2hPZzUmIv0zMeI4wuFYiWpZhEev_aX6urdzzO-9hUVKyChFA-xdyTotG8cIlmUq42Z_f7vZ6ixImcvawwt20HiYir7GVaCgEg7M9ITuYKzY0fRexIuCqY0yowo87mHhBA";

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
    final url = Uri.parse('$baseUrl/api/foods?query=$name&page=$page&size=$size');
    print('🌐 [searchFoods] URL: $url');
    print('🔎 Search Query: "$name", Page: $page, Size: $size');

    try {
      final response = await http.get(url, headers: _headers);
      print('📩 Response Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> foodListJson = jsonBody['data'] ?? [];
        final Map<String, dynamic> paginationJson =
            jsonBody['metadata']?['pagination'] ?? {};

        print('📊 Total Foods Found: ${foodListJson.length}');
        print('📄 Pagination Info: $paginationJson');

        final List<Food> foods =
        foodListJson.map((item) {
          print('🍽️ Parsing food item: ${item['name'] ?? 'Unknown'}');
          return Food.fromJson(item);
        }).toList();

        final result = PaginatedResponse<Food>(
          message: jsonBody['generalMessage'] ?? 'Success',
          data: foods,
          pagination: Pagination(
            currentPage: paginationJson['currentPage'] ?? 1,
            pageSize: paginationJson['pageSize'] ?? size,
            totalItems: paginationJson['totalItems'] ?? foods.length,
            totalPages: paginationJson['totalPages'] ?? 1,
          ),
        );

        print('✅ Successfully fetched ${foods.length} foods.');
        return result;
      } else {
        print('❗ Server returned error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to fetch foods. Status code: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('🔥 Exception during searchFoods: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
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
