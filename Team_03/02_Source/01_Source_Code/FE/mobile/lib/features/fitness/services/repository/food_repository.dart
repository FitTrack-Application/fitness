import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../common/model/pagination.dart';
import '../../models/food.dart';
import '../../models/serving_unit.dart';

class FoodRepository {
  String baseUrl = "http://192.168.1.8:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYyODI1MDUsImlhdCI6MTc0NjI3ODkwNSwianRpIjoib25ydHJvOjFjZGI5MDQ0LTgwYjMtNGI4Ni04Njg5LWJkZTQ5NmNkNTM4ZCIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODg4OC9yZWFsbXMvbXktZml0bmVzcyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJmMWNlNWU2Mi0xZjM3LTRjNDYtOTA4Yy05MzVjOTFmZWVjN2UiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ0ZXN0LXdpdGgtdWkiLCJzaWQiOiI3MjcxMzc3OS01N2E0LTQxYmQtYmIwNi1iMjI4ZTcwNTRmMWQiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1teS1maXRuZXNzIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsIlVTRVIiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkZW1vQGdtYWlsLmNvbSIsImVtYWlsIjoiZGVtb0BnbWFpbC5jb20ifQ.Ly6exEthQ3gg-2Ln6smixsvBvO5Yq_3StDam3vDMbe-zYcFDhmhmJl4M5jHi_FjI1_OG4y30LN5RYMufpsKsKQtslVSOTHDH--gLnAeB8cywSmnynwtKGUH_HCboYv8lqYDljMBwYDExk_5XNZLW5Q8QONpCtksrsIIbIBZR4QYwEIJXUiB20wrJDhseAz_gL7ayikjUXQwfsQmbHbiE63hocW0bGBbCL_-K7S9vY9wbKIoTFZ7opdt08htK824rwRS6tazAb6GtgglKiBKQqC7p6Z6kleNILkK4bpDqJcntJBzPsIcq9vJGAWKGnQPuOfmErWbJ-QmBXHftFlMwtw";

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

  // Future<Food> getFoodById(
  //     String foodId
  //     ) async {
  //   final url = Uri.parse('$baseUrl/api/foods/$foodId/macros-details');
  //   print('🌐 [getFoodById] URL: $url');
  //
  //   final body = jsonEncode({
  //     'servingUnitId': "27ccecf3-44e2-4a48-83de-1e7f415b1839",
  //     'numberOfServings': 4.5,
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         ..._headers,
  //         'Content-Type': 'application/json',
  //       },
  //       body: body,
  //     );
  //
  //     print('📩 Response Status: ${response.statusCode}');
  //     print('📩 Response Body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final jsonBody = json.decode(response.body);
  //       final data = jsonBody['data'];
  //       print('🥗 Fetched Food: ${data['name']} (${data['calories']} kcal)');
  //       return Food.fromJson(data);
  //     } else {
  //       print('❗ Server error: ${response.statusCode}');
  //       throw Exception('Failed to load food macros details');
  //     }
  //   } catch (e, stack) {
  //     print('🔥 Exception during getFoodById: $e');
  //     print('📉 Stacktrace:\n$stack');
  //     rethrow;
  //   }
  // }

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

  Future<List<ServingUnit>> getAllServingUnits() async {
    final url = Uri.parse('$baseUrl/api/serving-units');
    print('🌐 [getAllServingUnits] URL: $url');

    try {
      final response = await http.get(url, headers: _headers);
      print('📩 Response Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List<dynamic> dataList = jsonBody['data'] ?? [];

        final servingUnits = dataList.map((e) {
          print('🥄 Parsing serving unit: ${e['unitName']} (${e['unitSymbol']})');
          return ServingUnit.fromJson(e);
        }).toList();

        print('✅ Successfully fetched ${servingUnits.length} serving units.');
        return servingUnits;
      } else {
        print('❗ Server error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load serving units');
      }
    } catch (e, stack) {
      print('🔥 Exception during getAllServingUnits: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<ServingUnit> getServingUnitById(String servingUnitId) async {
    final url = Uri.parse('$baseUrl/api/serving-units/$servingUnitId');
    print('🌐 [getServingUnitById] URL: $url');

    try {
      final response = await http.get(url, headers: _headers);
      print('📩 Response Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        print('🥄 Fetched Serving Unit: ${data['unitName']} (${data['unitSymbol']})');
        return ServingUnit.fromJson(data);
      } else {
        print('❗ Server error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load serving unit');
      }
    } catch (e, stack) {
      print('🔥 Exception during getServingUnitById: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

// Future<void> searchMyRecipes(String query, {required int page, required int size}) {}
}
