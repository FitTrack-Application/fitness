import '../../models/food.dart';
import '../api_client.dart';

class FoodRepository {
  final ApiClient _apiClient;

  FoodRepository({String baseUrl = "http://192.168.1.12:8080/api/foods"})
      : _apiClient = ApiClient(baseUrl);

  Food _mapToFood(dynamic data) {
    return Food(
      id: data['foodId'],
      name: data['foodName'],
      servingSize: 1.0, // API không trả về servingSize, tạm để 1.0
      calories: (data['calories'] as num).toInt(),
      protein: (data['protein'] as num).toInt(),
      carbs: (data['carbs'] as num).toInt(),
      fat: (data['fat'] as num).toInt(),
      unit: 'g', // API không trả về đơn vị, tạm để 'g'
    );
  }

  Future<Food> getFoodById(String foodId) async {
    try {
      final data = await _apiClient.get(foodId);
      return _mapToFood(data);
    } catch (e) {
      throw Exception('Failed to load food: $e');
    }
  }

  Future<List<Food>> searchFoods(String name, {int page = 1, int size = 10}) async {
    try {
      final data = await _apiClient.get('search', queryParams: {
        'name': name,
        'page': page.toString(),
        'size': size.toString(),
      });

      return (data as List<dynamic>).map((item) => _mapToFood(item)).toList();
    } catch (e) {
      throw Exception('Failed to search foods: $e');
    }
  }
}