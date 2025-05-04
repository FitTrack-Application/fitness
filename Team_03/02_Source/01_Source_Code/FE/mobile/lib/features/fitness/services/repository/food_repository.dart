import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../common/model/pagination.dart';
import '../../models/food.dart';
import '../../models/serving_unit.dart';

class FoodRepository {
  String baseUrl = "http://192.168.1.11:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYzNTQwNDEsImlhdCI6MTc0NjM1MDQ0MSwianRpIjoib25ydHJvOmVhMGFkNzViLWExNTEtNDMwZC05YTQzLTU0MDBhMTZmZGQ4NiIsImlzcyI6Imh0dHA6Ly8xMC4wLjIuMjo4ODg4L3JlYWxtcy9teS1maXRuZXNzIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImYxY2U1ZTYyLTFmMzctNGM0Ni05MDhjLTkzNWM5MWZlZWM3ZSIsInR5cCI6IkJlYXJlciIsImF6cCI6InRlc3Qtd2l0aC11aSIsInNpZCI6IjBlMWNhZmFiLTU1MWMtNGQ2Zi1iY2U1LTUwNTRlNTc5MjA5ZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDozMDAwIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLW15LWZpdG5lc3MiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiVVNFUiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6ImRlbW9AZ21haWwuY29tIiwiZW1haWwiOiJkZW1vQGdtYWlsLmNvbSJ9.Pp9j53nsJsXAuTLKfiFUoGiEQzSzOKO5y9UGnpyrUE_qAtG9dJwkkjDow7m9NrjBti00fjuUSGFRwcshawLwzxyjymiSzWSMI27IWhm1_Ha1SHujNrGoOXlA4ZxjV7YHwXyZOg25VxnYUPWktq_tDtOlr4-XVz4Eqn75PPY80giVHbPNZMIDJd5yd2KgoFzhXVGHAnCZHI9SQ1q-aIQCDZ-o-u7LSJPHNEU2tCSrQPMcaxYzg2e2A96Vi6rTUqeHTOD8lu_LF8a5JgnxOCIlN2yGicBFGzAX8tp4-Dcbka8LVl32UWrLxRsZXT7mq1g4SdF5NZLy54xgzXdZP-UXsQ";

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  Future<Food> getFoodById(
      String foodId, {
        String servingUnitId = "9b0f9cf0-1c6e-4c1e-a3a1-8a9fddc20a0b",
        double numberOfServings = 100,
      }) async {
    final url = Uri.parse(
      '$baseUrl/api/foods/$foodId/macros-details'
          '?servingUnitId=$servingUnitId&numberOfServings=$numberOfServings',
    );

    print('🌐 [getFoodById] URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
      );

      print('📩 Response Status: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final data = jsonBody['data'];
        print('🥗 Fetched Food: ${data['name']} (${data['calories']} kcal)');
        return Food.fromJson(data);
      } else {
        print('❗ Server error: ${response.statusCode}');
        throw Exception('Failed to load food macros details');
      }
    } catch (e, stack) {
      print('🔥 Exception during getFoodById: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
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
