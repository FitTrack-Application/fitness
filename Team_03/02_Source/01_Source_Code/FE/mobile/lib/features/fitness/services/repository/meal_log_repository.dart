import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../models/meal_log.dart' show MealLogFitness, mealTypeFromString;

class MealLogRepository {
  final String baseUrl = "http://192.168.1.8:8088";
  final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYyNjM4NzYsImlhdCI6MTc0NjI2MDI3NiwianRpIjoib25ydHJvOjEwZDFkNjI3LTY1YTMtNDQ1Zi04NDk4LTk3ZWE0MmUyNjk4MyIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODg4OC9yZWFsbXMvbXktZml0bmVzcyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJmMWNlNWU2Mi0xZjM3LTRjNDYtOTA4Yy05MzVjOTFmZWVjN2UiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ0ZXN0LXdpdGgtdWkiLCJzaWQiOiJjYmFkNjkyYi1iZTYzLTQwZGUtODAyZi1iMDEyOTllMTAzMDciLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1teS1maXRuZXNzIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsIlVTRVIiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkZW1vQGdtYWlsLmNvbSIsImVtYWlsIjoiZGVtb0BnbWFpbC5jb20ifQ.Omd5Gcf6LjlEaVP9nSxE5qXdltbVGDbGkWg8x451qaFF3CRezYZr22spSZ7J2TjPvo_Jmp-X5S4xs27XgaWZNL5h256so4t4kO0s8SpQuXnPU3wYaXaNsrgX7MRfkfowFB7KoR0cVpx27Mow_3khqJp3eWEHqAdoipt_kE0y2lREx7KkNUzVwR8CQiyaDOUx45qViPUK4JobpS0T4ZpxlPLXUvFcEj7PCoxhzSyIfqJ8fJjbAsqkOsntpjdjl6e50KBlyAut049NUBV2y__RGr0NgB3C_HhuMrKmVxL3Vv5XOtN5nfw5WUgeJH7Fze90YsOWkNtGV5RXiRvbcZzKOA";
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
      );
    } else {
      print('❌ Failed to edit meal entry: ${response.body}');
      throw Exception('Failed to edit meal entry: ${response.body}');
    }
  }
}
