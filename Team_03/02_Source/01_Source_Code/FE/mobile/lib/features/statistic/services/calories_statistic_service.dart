import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/features/statistic/models/response/recent_calories_response.dart';

class CaloriesApiService {
  static const String baseUrl = 'http://your-api-url.com/api'; // Thay bằng URL của bạn

  Future<RecentCaloriesData> getRecentCalories({
    required String userId,
    int days = 7,
  }) async {
    final url = Uri.parse('$baseUrl/calories/recent?user_id=$userId&days=$days');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'success') {
        return RecentCaloriesData.fromJson(json['data']);
      } else {
        throw Exception(json['message']);
      }
    } else {
      throw Exception('Failed to load recent calories: ${response.statusCode}');
    }
  }
}