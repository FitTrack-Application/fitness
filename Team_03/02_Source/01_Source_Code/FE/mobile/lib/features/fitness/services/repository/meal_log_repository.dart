// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:mobile/features/fitness/models/meal_entry.dart';
// import 'package:mobile/features/fitness/services/repository/food_repository.dart';
//
// import '../../models/meal_log.dart' show MealLogFitness, mealTypeFromString;
//
// class MealLogRepository {
//   final String baseUrl = "http://192.168.1.11:8088";
//   final String jwtToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYzNzM1NTcsImlhdCI6MTc0NjM2OTk1NywianRpIjoib25ydHJvOmIwNTFjM2Q2LTU2ZGItNDVlZi1iZGQ1LWFiMDFkZTgxNTU3YyIsImlzcyI6Imh0dHA6Ly8xMC4wLjIuMjo4ODg4L3JlYWxtcy9teS1maXRuZXNzIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImYxY2U1ZTYyLTFmMzctNGM0Ni05MDhjLTkzNWM5MWZlZWM3ZSIsInR5cCI6IkJlYXJlciIsImF6cCI6InRlc3Qtd2l0aC11aSIsInNpZCI6IjI1NDM2YzNhLTQ1ZDEtNDRjYy04MTFhLTIzYWY2YmI1MGVlOSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDozMDAwIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLW15LWZpdG5lc3MiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiVVNFUiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6ImRlbW9AZ21haWwuY29tIiwiZW1haWwiOiJkZW1vQGdtYWlsLmNvbSJ9.GlnuEOk5x3Ds4e8ZVDbH-VKJBW4TEzamcRsQV1CdBR58dWCHp6Ybq7PLEhZMhKePaaARnLkW_cRhaJMBLAhqa75BCm8FTkxqNEB7R5sVrh_gCERWczvYmb0AYsApOnZuc9QyqHZhHyf_1QPvDoKo_5Qaw-HSxAm990OpyP1qd35ngc0x09TLRy77TUMVKJMOq4iPYEEM_2dSxISZfg_Z_g-5_JCpm1YL2F9HgRgo-JPsZ0wvseiEbhOkUHenehqZZOrGlRNp3XBqgkqQDUI2_kDzjGswTd1oARZLX2rqpN2QqydlJRegmnu1fGk2ViSKjMwevm77x9rC5dcDi0CGvw";
//   final FoodRepository foodRepository = FoodRepository();
//
//   Map<String, String> get _headers => {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $jwtToken',
//       };
//
//   String _formatDate(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }
//
//   Future<List<MealLogFitness>> fetchMealLogsForDate(DateTime date) async {
//     final formattedDate = _formatDate(date);
//     final uri = Uri.parse("$baseUrl/api/meal-logs?date=$formattedDate");
//     print('🌐 [fetchMealLogsForDate] URL: $uri');
//
//     try {
//       final response = await http.get(uri, headers: _headers);
//       print('📩 Response Status Code: ${response.statusCode}');
//       print('📩 Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = json.decode(response.body);
//         final List<dynamic> data = decoded['data'];
//         print('📊 Total Meal Logs Found: ${data.length}');
//
//         final futures = data.map((mealLogJson) async {
//           try {
//             print('🔍 Processing Meal Log: ${mealLogJson['mealType']}');
//             final mealType = mealTypeFromString(mealLogJson['mealType']);
//             final entriesJson = mealLogJson['mealEntries'] as List<dynamic>;
//
//             print('📦 Found ${entriesJson.length} entries for $mealType');
//
//             final entries = await Future.wait(
//               entriesJson.map((entryJson) async {
//                 print('📦 Fetching food by ID: ${entryJson['foodId']}');
//                 final food = await foodRepository.getFoodById(
//                     entryJson['foodId'],
//                     servingUnitId: entryJson['servingUnit']['id'],
//                     numberOfServings: entryJson['numberOfServings']);
//                 print('🍽️ Food Fetched: ${food.name}');
//
//                 return MealEntry.fromJsonWithFood(entryJson, food);
//               }),
//             );
//
//             return MealLogFitness(
//               id: mealLogJson['id'],
//               date: DateTime.parse(mealLogJson['date']),
//               mealType: mealType,
//               mealEntries: entries,
//             );
//           } catch (e) {
//             print("❌ Error while processing meal log: $e");
//             return null;
//           }
//         }).toList();
//
//         final result = await Future.wait(futures);
//         final filtered = result.whereType<MealLogFitness>().toList();
//         print('✅ Successfully processed ${filtered.length} meal logs.');
//         return filtered;
//       } else {
//         print(
//             '❗ Server returned error: ${response.statusCode} ${response.reasonPhrase}');
//         throw Exception('Failed to load meal logs: ${response.statusCode}');
//       }
//     } catch (e, stack) {
//       print('🔥 Exception during fetchMealLogsForDate: $e');
//       print('📉 Stacktrace:\n$stack');
//       rethrow;
//     }
//   }
//
//   Future<MealEntry> addMealEntryToLog({
//     required String mealLogId,
//     required String foodId,
//     required String servingUnitId,
//     required double numberOfServings,
//   }) async {
//     final uri = Uri.parse('$baseUrl/api/meal-logs/$mealLogId/entries');
//     print('🔗 [addMealEntryToLog] URL: $uri');
//     print('🍽️ Meal Log ID: $mealLogId');
//     print('🍔 Food ID: $foodId');
//     print('⚖️ Serving Unit ID: $servingUnitId');
//     print('🔢 Number of Servings: $numberOfServings');
//
//     final body = jsonEncode({
//       'foodId': foodId,
//       'servingUnitId': servingUnitId,
//       'numberOfServings': numberOfServings,
//     });
//
//     final response = await http.post(uri, headers: _headers, body: body);
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       final data = decoded['data'];
//       // Gọi tới foodRepository để lấy thông tin chi tiết về món ăn
//       final food = await foodRepository.getFoodById(data['foodId'],
//           servingUnitId: servingUnitId, numberOfServings: numberOfServings);
//       return MealEntry.fromJsonWithFood(data, food);
//     } else {
//       throw Exception('Failed to add meal entry: ${response.body}');
//     }
//   }
//
//   Future<void> createMealLogsForDate(DateTime date) async {
//     final formattedDate = _formatDate(date);
//     final uri = Uri.parse('$baseUrl/api/meal-logs/daily');
//
//     final body = jsonEncode({
//       'date': formattedDate,
//     });
//
//     print('🔗 [createMealLogsForDate] URL: $uri');
//     print('📅 Formatted Date: $formattedDate');
//     print('📤 Request Body: $body');
//     print('📨 Headers: $_headers');
//
//     final response = await http.post(uri, headers: _headers, body: body);
//
//     print('✅ Status Code: ${response.statusCode}');
//     print('📥 Response Body: ${response.body}');
//
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       print('❌ Failed to create meal logs');
//       throw Exception('Failed to create meal logs');
//     } else {
//       print('✔️ Successfully created meal logs');
//     }
//   }
//
//   Future<void> deleteMealEntry(String mealEntryId) async {
//     final uri = Uri.parse('$baseUrl/api/meal-entries/$mealEntryId');
//
//     final response = await http.delete(uri, headers: _headers);
//
//     print('🗑️ [deleteMealEntry] Deleting entry with ID: $mealEntryId');
//     print('🔗 URL: $uri');
//     print('📨 Headers: $_headers');
//     print('✅ Status Code: ${response.statusCode}');
//     print('📥 Response Body: ${response.body}');
//
//     if (response.statusCode == 200 || response.statusCode == 204) {
//       print('✔️ Successfully deleted meal entry.');
//     } else {
//       print('❌ Failed to delete meal entry.');
//       throw Exception('Failed to delete meal entry: ${response.body}');
//     }
//   }
//
//   Future<MealEntry> editMealEntry({
//     required String mealEntryId,
//     required String foodId,
//     required String servingUnitId,
//     required double numberOfServings,
//   }) async {
//     final uri = Uri.parse('$baseUrl/api/meal-entries/$mealEntryId');
//     print('✏️ [editMealEntry] URL: $uri');
//     print('foodId: $foodId');
//     print('servingUnitId: $servingUnitId');
//     print('numberOfServings: $numberOfServings');
//
//     final body = jsonEncode({
//       'foodId': foodId,
//       'servingUnitId': servingUnitId,
//       'numberOfServings': numberOfServings,
//     });
//
//     final response = await http.put(uri, headers: _headers, body: body);
//
//     print('✅ Status Code: ${response.statusCode}');
//     print('📥 Response Body: ${response.body}');
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final decoded = json.decode(response.body);
//       final data = decoded['data'];
//
//       final food = await foodRepository.getFoodById(data['foodId'],
//           servingUnitId: servingUnitId, numberOfServings: numberOfServings);
//       return MealEntry.fromJsonWithFood(data, food);
//     } else {
//       print('❌ Failed to edit meal entry: ${response.body}');
//       throw Exception('Failed to edit meal entry: ${response.body}');
//     }
//   }
//
//   Future<int> fetchCaloriesGoal() async {
//     final uri = Uri.parse('http://192.168.1.11:8088/api/nutrition-goals/me');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $jwtToken',
//     };
//
//     final response = await http.get(uri, headers: headers);
//
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       final calories = decoded['data']['calories'];
//       print('🔥 Calories goal: $calories');
//       return calories;
//     } else {
//       throw Exception('Failed to load nutrition goal');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:mobile/features/fitness/models/meal_entry.dart';
import 'package:mobile/features/fitness/services/repository/food_repository.dart';

import '../../../../cores/utils/dio/dio_client.dart';
import '../../models/meal_log.dart';

class MealLogRepository {
  final Dio _dio = DioClient().dio;
  final FoodRepository foodRepository = FoodRepository();

  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// 1. Fetch danh sách MealLog theo ngày
  Future<List<MealLogFitness>> fetchMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    print('📅 Fetching meal logs for date: $formattedDate');
    try {
      final response = await _dio.get(
        '/api/meal-logs',
        queryParameters: {'date': formattedDate},
      );
      final data = response.data['data'] as List<dynamic>;
      print('📦 Received ${data.length} meal logs');

      final logs = await Future.wait(data.map((mealLogJson) async {
        final mealType = mealTypeFromString(mealLogJson['mealType']);
        final entriesJson = mealLogJson['mealEntries'] as List<dynamic>;
        print('🍽️ Meal type: $mealType with ${entriesJson.length} entries');

        final entries = await Future.wait(entriesJson.map((entryJson) async {
          print('🔍 Fetching food info for foodId: ${entryJson['foodId']}');
          final food = await foodRepository.getFoodById(
            entryJson['foodId'],
            servingUnitId: entryJson['servingUnit']['id'],
            numberOfServings: entryJson['numberOfServings'],
          );
          return MealEntry.fromJsonWithFood(entryJson, food);
        }));
        return MealLogFitness(
          id: mealLogJson['id'],
          date: DateTime.parse(mealLogJson['date']),
          mealType: mealType,
          mealEntries: entries,
        );
      }));

      return logs;
    } on DioException catch (e) {
      print('🔥 Error fetchMealLogsForDate: ${e.response?.statusCode} ${e.message}');
      // Kiểm tra lỗi 400 - meal log chưa tồn tại
      if (e.response?.statusCode == 400) {
        throw Exception('Failed to load meal logs: 400');
      }
      rethrow;
    }
  }

  /// 2. Thêm 1 entrée vào MealLog
  Future<MealEntry> addMealEntryToLog({
    required String mealLogId,
    required String foodId,
    required String servingUnitId,
    required double numberOfServings,
  }) async {
    final path = '/api/meal-logs/$mealLogId/entries';
    final body = {
      'foodId': foodId,
      'servingUnitId': servingUnitId,
      'numberOfServings': numberOfServings,
    };

    print('➕ Adding meal entry to log $mealLogId: $body');
    try {
      final response = await _dio.post(path, data: body);
      final data = response.data['data'];
      print('✅ Meal entry added: ${data['id']}');

      final food = await foodRepository.getFoodById(
        data['foodId'],
        servingUnitId: servingUnitId,
        numberOfServings: numberOfServings,
      );
      return MealEntry.fromJsonWithFood(data, food);
    } on DioException catch (e) {
      print('🔥 Error addMealEntryToLog: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 3. Tạo mới các MealLog cho ngày
  Future<void> createMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    print('🆕 Creating meal logs for date: $formattedDate');
    try {
      await _dio.post(
        '/api/meal-logs/daily',
        data: {'date': formattedDate},
      );
      print('✅ Meal logs created for $formattedDate');
    } on DioException catch (e) {
      print('🔥 Error createMealLogsForDate: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 4. Xóa 1 MealEntry
  Future<void> deleteMealEntry(String mealEntryId) async {
    final path = '/api/meal-entries/$mealEntryId';
    print('❌ Deleting meal entry: $mealEntryId');
    try {
      await _dio.delete(path);
      print('✅ Deleted meal entry: $mealEntryId');
    } on DioException catch (e) {
      print('🔥 Error deleteMealEntry: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 5. Chỉnh sửa 1 MealEntry
  Future<MealEntry> editMealEntry({
    required String mealEntryId,
    required String foodId,
    required String servingUnitId,
    required double numberOfServings,
  }) async {
    final path = '/api/meal-entries/$mealEntryId';
    final body = {
      'foodId': foodId,
      'servingUnitId': servingUnitId,
      'numberOfServings': numberOfServings,
    };

    print('✏️ Editing meal entry $mealEntryId: $body');
    try {
      final response = await _dio.put(path, data: body);
      final data = response.data['data'];
      print('✅ Edited meal entry: ${data['id']}');

      final food = await foodRepository.getFoodById(
        data['foodId'],
        servingUnitId: servingUnitId,
        numberOfServings: numberOfServings,
      );
      return MealEntry.fromJsonWithFood(data, food);
    } on DioException catch (e) {
      print('🔥 Error editMealEntry: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 6. Lấy calories goal của user
  Future<int> fetchCaloriesGoal() async {
    print('🎯 Fetching user calories goal...');
    try {
      final response = await _dio.get('/api/nutrition-goals/me');
      final calories = response.data['data']['calories'] as int;
      print('✅ Calories goal: $calories');
      return calories;
    } on DioException catch (e) {
      print('🔥 Error fetchCaloriesGoal: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }
}
