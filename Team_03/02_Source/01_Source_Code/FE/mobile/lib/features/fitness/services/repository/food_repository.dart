import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../common/model/pagination.dart';
import '../../models/food.dart';

class FoodRepository {
  String baseUrl = "http://172.20.224.1:8088";

  Future<Food> getFoodById(String foodId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/foods/$foodId'));

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

    final response = await http.get(url);

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
}
