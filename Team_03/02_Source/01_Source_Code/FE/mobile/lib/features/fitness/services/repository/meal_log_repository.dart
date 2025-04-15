import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/meal_log.dart' show MealLog;

class MealLogRepository {
  final String baseUrl = "http://192.168.1.8:8088/api/meal-logs";
  final String jwtToken;

  MealLogRepository({required this.jwtToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<List<MealLog>> fetchMealLogsForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    final uri = Uri.parse("$baseUrl?date=$formattedDate");

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((e) => MealLog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meal logs: ${response.statusCode}');
    }
  }
}
