import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../models/meal_log.dart' show MealLogFitness, mealTypeFromString;

class MealLogRepository {
  final String baseUrl = "http://192.168.1.11:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYzNDY3NzAsImlhdCI6MTc0NjM0MzE3MCwianRpIjoib25ydHJvOjBjZDk4NDc2LTM0YmYtNDc2MC1hMmFlLTY4MGViYWVlMzc0YyIsImlzcyI6Imh0dHA6Ly8xMC4wLjIuMjo4ODg4L3JlYWxtcy9teS1maXRuZXNzIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImYxY2U1ZTYyLTFmMzctNGM0Ni05MDhjLTkzNWM5MWZlZWM3ZSIsInR5cCI6IkJlYXJlciIsImF6cCI6InRlc3Qtd2l0aC11aSIsInNpZCI6IjE1ZTE4OWM2LTk5NWMtNGRkNS04NGRlLTYyZmY1NTViOGEyYSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDozMDAwIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLW15LWZpdG5lc3MiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiVVNFUiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6ImRlbW9AZ21haWwuY29tIiwiZW1haWwiOiJkZW1vQGdtYWlsLmNvbSJ9.A6nHpUu4NB0nYjP4E7SSOGxvGF9NIMtasdO0vfqdS8f7TLG09J32JZfKBdImrQWtS-JsYZO96aesG-iBxiXulmOh-vqRaJpvqklmkNQCe1-WrJCt8WJ9g6f_EG3B1d6rIYjohUKBWiLGQzl57ANUc-niG8y0chyzMdZ1WHqb3j40BDXcMwDzWbxciJOQeboeU249W-WAymoOX7lZHdJcMyz5kPDV8-53LwkXLjldBinWkKnhK_qvHDEjFjKwSO4hJ5X9CbBfxYmOqdRT129AQ3xXMF3hQXb013DwH3X2hJ1qUVtSTqNpyzbY5lttIUk4glhnoOC_RqDp5dnTMkxiMA";
  final FoodRepository foodRepository = FoodRepository();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<List<MealLogFitness>> fetchMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    final uri = Uri.parse("$baseUrl/api/meal-logs?date=$formattedDate");
    print('🌐 [fetchMealLogsForDate] URL: $uri');

    try {
      final response = await http.get(uri, headers: _headers);
      print('📩 Response Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'];
        print('📊 Total Meal Logs Found: ${data.length}');

        final futures = data.map((mealLogJson) async {
          try {
            print('🔍 Processing Meal Log: ${mealLogJson['mealType']}');
            final mealType = mealTypeFromString(mealLogJson['mealType']);
            final entriesJson = mealLogJson['mealEntries'] as List<dynamic>;

            print('📦 Found ${entriesJson.length} entries for $mealType');

            final entries = await Future.wait(
              entriesJson.map((entryJson) async {
                print('📦 Fetching food by ID: ${entryJson['foodId']}');
                final food = await foodRepository.getFoodById(entryJson['foodId']);
                print('🍽️ Food Fetched: ${food.name}');

                return MealEntry(
                  id: entryJson['id'],
                  food: food,
                  servingUnit: entryJson['servingUnit'],
                  numberOfServings: (entryJson['numberOfServings'] as num).toDouble(),
                  calories: (entryJson['calories'] as num).toDouble(),
                  protein: (entryJson['protein'] as num).toDouble(),
                  carbs: (entryJson['carbs'] as num).toDouble(),
                  fat: (entryJson['fat'] as num).toDouble(),
                );
              }),
            );

            return MealLogFitness(
              id: mealLogJson['id'],
              date: DateTime.parse(mealLogJson['date']),
              mealType: mealType,
              mealEntries: entries,
            );
          } catch (e) {
            print("❌ Error while processing meal log: $e");
            return null;
          }
        }).toList();

        final result = await Future.wait(futures);
        final filtered = result.whereType<MealLogFitness>().toList();
        print('✅ Successfully processed ${filtered.length} meal logs.');
        return filtered;
      } else {
        print('❗ Server returned error: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load meal logs: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('🔥 Exception during fetchMealLogsForDate: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<MealEntry> addMealEntryToLog({
    required String mealLogId,
    required String foodId,
    required String servingUnit,
    required double numberOfServings,
  }) async {
    final uri = Uri.parse('$baseUrl/api/meal-logs/$mealLogId/entries');
    print('🔗 [addMealEntryToLog] URL: $uri');
    print('🍽️ Meal Log ID: $mealLogId');
    print('🍔 Food ID: $foodId');
    print('⚖️ Serving Unit: $servingUnit');
    print('🔢 Number of Servings: $numberOfServings');

    final body = jsonEncode({
      'foodId': foodId,
      'servingUnit': servingUnit,
      'numberOfServings': numberOfServings,
    });

    final response = await http.post(uri, headers: _headers, body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      // Gọi tới foodRepository để lấy thông tin chi tiết về món ăn
      final food = await foodRepository.getFoodById(data['foodId']);
      return MealEntry(
        id: data['id'],
        food: food,
        servingUnit: data['servingUnit'],
        numberOfServings: (data['numberOfServings'] as num).toDouble(),
        calories: (data['calories'] as num).toDouble(),
        protein: (data['protein'] as num).toDouble(),
        carbs: (data['carbs'] as num).toDouble(),
        fat: (data['fat'] as num).toDouble(),
      );
    } else {
      throw Exception('Failed to add meal entry: ${response.body}');
    }
  }

  // Future<void> createMealLogsForDate(DateTime date) async {
  //   final formattedDate = _formatDate(date);
  //   final uri = Uri.parse('$baseUrl/api/meal-logs');
  //   final mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER'];
  //
  //   print('🔗 [createMealLogsForDate] URL: $uri');
  //   print('📅 Formatted Date: $formattedDate');
  //
  //   for (final type in mealTypes) {
  //     final body = jsonEncode({
  //       'date': formattedDate,
  //       'mealType': type,
  //     });
  //
  //     print('\n➡️ Creating meal log...');
  //     print('🍽️ Meal Type: $type');
  //     print('📤 Request Body: $body');
  //     print('📨 Headers: $_headers');
  //
  //     final response = await http.post(uri, headers: _headers, body: body);
  //
  //     print('✅ Status Code: ${response.statusCode}');
  //     print('📥 Response Body: ${response.body}');
  //
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       print('❌ Failed to create meal log for $type');
  //       throw Exception('Failed to create meal log for $type');
  //     } else {
  //       print('✔️ Successfully created meal log for $type');
  //     }
  //   }
  // }

  Future<void> createMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    final uri = Uri.parse('$baseUrl/api/meal-logs/daily');

    final body = jsonEncode({
      'date': formattedDate,
    });

    print('🔗 [createMealLogsForDate] URL: $uri');
    print('📅 Formatted Date: $formattedDate');
    print('📤 Request Body: $body');
    print('📨 Headers: $_headers');

    final response = await http.post(uri, headers: _headers, body: body);

    print('✅ Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('❌ Failed to create meal logs');
      throw Exception('Failed to create meal logs');
    } else {
      print('✔️ Successfully created meal logs');
    }
  }


  Future<void> deleteMealEntry(String mealEntryId) async {
    final uri = Uri.parse('$baseUrl/api/meal-entries/$mealEntryId');

    final response = await http.delete(uri, headers: _headers);

    print('🗑️ [deleteMealEntry] Deleting entry with ID: $mealEntryId');
    print('🔗 URL: $uri');
    print('📨 Headers: $_headers');
    print('✅ Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('✔️ Successfully deleted meal entry.');
    } else {
      print('❌ Failed to delete meal entry.');
      throw Exception('Failed to delete meal entry: ${response.body}');
    }
  }

  Future<MealEntry> editMealEntry({
    required String mealEntryId,
    required String foodId,
    required String servingUnit,
    required double numberOfServings,
  }) async {
    final uri = Uri.parse('$baseUrl/api/meal-entries/$mealEntryId');
    print('✏️ [editMealEntry] URL: $uri');
    print('foodId: $foodId');
    print('servingUnit: $servingUnit');
    print('numberOfServings: $numberOfServings');

    final body = jsonEncode({
      'foodId': foodId,
      'servingUnit': servingUnit,
      'numberOfServings': numberOfServings,
    });

    final response = await http.put(uri, headers: _headers, body: body);

    print('✅ Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];

      final food = await foodRepository.getFoodById(data['foodId']);
      return MealEntry(
        id: data['id'],
        food: food,
        servingUnit: data['servingUnit'],
        numberOfServings: (data['numberOfServings'] as num).toDouble(),
        calories: (data['calories'] as num).toDouble(),
        protein: (data['protein'] as num).toDouble(),
        carbs: (data['carbs'] as num).toDouble(),
        fat: (data['fat'] as num).toDouble(),
      );
    } else {
      print('❌ Failed to edit meal entry: ${response.body}');
      throw Exception('Failed to edit meal entry: ${response.body}');
    }
  }

  Future<int> fetchCaloriesGoal() async {
    final uri = Uri.parse('http://192.168.1.11:8088/api/nutrition-goals/me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final calories = decoded['data']['calories'];
      print('🔥 Calories goal: $calories');
      return calories;
    } else {
      throw Exception('Failed to load nutrition goal');
    }
  }

}
