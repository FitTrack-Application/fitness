import '../../../../common/model/oagination.dart';
import '../../models/food.dart';
import '../api_client.dart';

class FoodRepository {
  final ApiClient _apiClient;

  FoodRepository(
      {String baseUrl =
          "https://abf1f370-fb74-44fe-a48a-8a4d4b4ecce0.mock.pstmn.io/api/foods"})
      : _apiClient = ApiClient(baseUrl);

  Food _mapToFood(dynamic data) {
    return Food(
      id: data['foodId'],
      name: data['foodName'],
      servingSize: (data['servingSize'] as num).toDouble(),
      calories: (data['calories'] as num).toInt(),
      protein: (data['protein'] as num).toInt(),
      carbs: (data['carbs'] as num).toInt(),
      fat: (data['fat'] as num).toInt(),
      unit: data['unit'] ?? 'g',
      description: data['description'] ?? '',
    );
  }

  // Future<Food> getFoodById(String foodId) async {
  //   try {
  //     final response = await _apiClient.get(foodId);
  //     final foodData = response['data'];
  //     return _mapToFood(foodData);
  //   } catch (e) {
  //     throw Exception('Failed to load food: $e');
  //   }
  // }
  //
  // Future<PaginatedResponse<Food>> searchFoods(String name,
  //     {int page = 1, int size = 10}) async {
  //   try {
  //     final response = await _apiClient.get('search', queryParams: {
  //       'name': name,
  //       'page': page.toString(),
  //       'size': size.toString(),
  //     });
  //
  //     final List<dynamic> foodList = (response['data'] as List<dynamic>);
  //     final List<Food> foods =
  //         foodList.map((item) => _mapToFood(item)).toList();
  //
  //     final pagination = Pagination.fromJson(response['pagination']);
  //
  //     return PaginatedResponse<Food>(
  //       message: response['message'],
  //       data: foods,
  //       pagination: pagination,
  //     );
  //   } catch (e) {
  //     throw Exception('Failed to search foods: $e');
  //   }
  // }

  Future<Food> getFoodById(String foodId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập delay mạng
    return Food(
      id: foodId,
      name: 'Cơm gà',
      servingSize: 150.0,
      calories: 350,
      protein: 25,
      carbs: 40,
      fat: 10,
      unit: 'g',
      description: 'Một phần cơm gà thơm ngon với rau củ.',
    );
  }

  Future<PaginatedResponse<Food>> searchFoods(String name,
      {int page = 1, int size = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập delay mạng

    List<Food> mockFoods = List.generate(size, (index) {
      int number = ((page - 1) * size) + index + 1;
      return Food(
        id: 'food_$number',
        name: '$name món $number',
        servingSize: 100 + number.toDouble(),
        calories: 200 + number,
        protein: 10 + number,
        carbs: 30 + number,
        fat: 5 + number,
        unit: 'g',
        description: 'Món ăn mô phỏng số $number',
      );
    });

    return PaginatedResponse<Food>(
      message: 'Mock data fetched successfully',
      data: mockFoods,
      pagination: Pagination(
        currentPage: page,
        pageSize: size,
        totalItems: 100,
        totalPages: 10,
      ),
    );
  }

  Future<PaginatedResponse<Food>> searchMyFoods(String name,
      {int page = 1, int size = 10}) async {
    // Return an empty list for "My Food"
    return PaginatedResponse<Food>(
      message: 'No data available for My Food',
      data: [],
      pagination: Pagination(
        currentPage: page,
        pageSize: size,
        totalItems: 0,
        totalPages: 1,
      ),
    );
  }
}
