import 'package:dio/dio.dart';
import 'package:mobile/features/fitness/models/ai_food.dart';
import '../../../../common/model/pagination.dart';
import '../../../../cores/utils/dio/dio_client.dart';
import '../../models/food.dart';
import '../../models/serving_unit.dart';

class AiRepository {
  final Dio _dio = DioClient().dio;

  Future<List<AiFood>> searchFoods(
      String prompt) async {
    try {
      print('📤 AI Requesting searchFoods with prompt="$prompt"');

      final response = await _dio.post(
        '/api/ai/get-food-entries',
        data: {
          "meal_description": prompt,
        },
      );

      final data = response.data;
      print('✅ Response received for searchFoods');
      print('📦 Total items fetched: ${data['data']?.length ?? 0}');

      final List<dynamic> foodListJson = data['data'] ?? [];
      final Map<String, dynamic> paginationJson =
          data['metadata']?['pagination'] ?? {};

      final foods = foodListJson.map((item) => AiFood.fromJson(item)).toList();
      return foods;
    } catch (e, stack) {
      print('🔥 Exception during searchFoods: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }
}
