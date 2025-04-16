import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../models/meal_log.dart' show MealLogFitness, MealType, mealTypeFromString;

class MealLogRepository {
  final String baseUrl = "http://192.168.1.14:8088";
  final String jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsIm5hbWUiOiJKb2huIEFsZXgiLCJ1c2VySWQiOiI4YmQ5MWFhNy0wMWFhLTRmMGYtYWY1Mi04OWRiNjEzMzllYjEiLCJzdWIiOiJ0ZXN0NDRAZ21haWwuY29tIiwiaWF0IjoxNzQ0NzI4MjAzLCJleHAiOjE3NDUzMzMwMDN9.PyUfe4fDKtoZZ82M3Ydl_nYVxoxXelmUsqPAnRubAmc";
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

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];

      // Parse mỗi meal log
      return Future.wait(data.map((mealLogJson) async {
        // Parse từng meal entry
        final List<MealEntry> entries = await Future.wait(
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
          mealType: mealTypeFromString(mealLogJson['mealType']),
          mealEntries: entries,
        );
      }));
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
    final body = jsonEncode({
      'foodId': foodId,
      'servingUnit': servingUnit,
      'numberOfServings': numberOfServings,
    });

    final response = await http.post(uri, headers: _headers, body: body);

    if (response.statusCode == 201) {
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
      throw Exception('Failed to add meal entry: ${response.statusCode}');
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
