import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../models/meal_log.dart' show MealLogFitness, mealTypeFromString;

class MealLogRepository {
  final String baseUrl = "http://172.20.224.1:8088";
  final String jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsIm5hbWUiOiJOZ3V54buFbiBWxINuIEEiLCJ1c2VySWQiOiI0ZmY5NzM2MS04NzA3LTQzZWItYmYzYi03YmZmYWIyNzI4ZTgiLCJzdWIiOiJ0ZXN0MTRAZ21haWwuY29tIiwiaWF0IjoxNzQ0OTA0OTQ2LCJleHAiOjE3NDU1MDk3NDZ9.Lt_ESphHMq4PHVUIgF8g6_rmUJDlp2hpYh8egR9PUds";
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
    print('📦 Response body: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('1');
      final decoded = json.decode(response.body);
      print('2');
      final data = decoded['data'];
      print('3');
      print(data);
      // Gọi tới foodRepository để lấy thông tin chi tiết về món ăn
      final food = await foodRepository.getFoodById(data['foodId']);
      print('4');
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
}
