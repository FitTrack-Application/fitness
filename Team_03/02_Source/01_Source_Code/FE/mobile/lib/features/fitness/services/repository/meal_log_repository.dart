import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../models/meal_log.dart' show MealLogFitness, mealTypeFromString;

class MealLogRepository {
  final String baseUrl = "http://localhost:8088";
  final String jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsIm5hbWUiOiJOZ3V54buFbiBWxINuIEEiLCJ1c2VySWQiOiI0ZmY5NzM2MS04NzA3LTQzZWItYmYzYi03YmZmYWIyNzI4ZTgiLCJzdWIiOiJ0ZXN0MTRAZ21haWwuY29tIiwiaWF0IjoxNzQ1MDcxMzgwLCJleHAiOjE3NDU2NzYxODB9.R4w-7-t8hqsgOj1uKdvtEkQQcMwCmnnNm94ZHX3BSvM";
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
    print('url fetch meal logs: $uri');

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];

      final futures = data.map((mealLogJson) async {
        try {
          final mealType = mealTypeFromString(mealLogJson['mealType']);

          final entries = await Future.wait(
            (mealLogJson['mealEntries'] as List<dynamic>).map((entryJson) async {
              final food = await foodRepository.getFoodById(entryJson['foodId']);
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
          print("❌ Skipping ${mealLogJson['mealType']} due to error: $e");
          return null;
        }
      }).toList();

      final result = await Future.wait(futures);
      return result.whereType<MealLogFitness>().toList();
    } else {
      throw Exception('Failed to load meal logs: ${response.statusCode}');
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
    print('  "foodId": $foodId,');
    print('  "servingUnit": $servingUnit,');
    print('  "numberOfServings": $numberOfServings');

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

  Future<void> createMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    final uri = Uri.parse('$baseUrl/api/meal-logs');
    final mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER'];

    print('🔗 [createMealLogsForDate] URL: $uri');
    print('📅 Formatted Date: $formattedDate');

    for (final type in mealTypes) {
      final body = jsonEncode({
        'date': formattedDate,
        'mealType': type,
      });

      print('\n➡️ Creating meal log...');
      print('🍽️ Meal Type: $type');
      print('📤 Request Body: $body');
      print('📨 Headers: $_headers');

      final response = await http.post(uri, headers: _headers, body: body);

      print('✅ Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('❌ Failed to create meal log for $type');
        throw Exception('Failed to create meal log for $type');
      } else {
        print('✔️ Successfully created meal log for $type');
      }
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
