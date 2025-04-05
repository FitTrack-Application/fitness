import '../../../../common/model/oagination.dart';
import '../../models/food.dart';
import '../api_client.dart';

// Cập nhật FoodRepository để sử dụng class mới
class FoodRepository {
  final ApiClient _apiClient;

  FoodRepository(
      {String baseUrl =
      "https://54efe02a-ae6e-4055-9391-3a9bd9cac8f1.mock.pstmn.io/api/foods"})
      : _apiClient = ApiClient(baseUrl);

  Food _mapToFood(dynamic data) {
    return Food(
      id: data['foodId'],
      name: data['foodName'],
      servingSize: (data['servingSize'] as num).toDouble(),
      calories: (data['calories'] as num).toDouble(),
      protein: (data['protein'] as num).toDouble(),
      carbs: (data['carbs'] as num).toDouble(),
      fat: (data['fat'] as num).toDouble(),
      unit: data['unit'] ?? 'g',
      description: data['description'] ?? '',
    );
  }

  Future<Food> getFoodById(String foodId) async {
    try {
      final response = await _apiClient.get(foodId);
      final foodData = response['data'];
      return _mapToFood(foodData);
    } catch (e) {
      throw Exception('Failed to load food: $e');
    }
  }

  Future<PaginatedResponse<Food>> searchFoods(String name, {int page = 1, int size = 10}) async {
    try {
      final response = await _apiClient.get('search', queryParams: {
        'name': name,
        'page': page.toString(),
        'size': size.toString(),
      });

      final List<dynamic> foodList = (response['data'] as List<dynamic>);
      final List<Food> foods = foodList.map((item) => _mapToFood(item)).toList();

      final pagination = Pagination.fromJson(response['pagination']);

      return PaginatedResponse<Food>(
        message: response['message'],
        data: foods,
        pagination: pagination,
      );
    } catch (e) {
      throw Exception('Failed to search foods: $e');
    }
  }
}