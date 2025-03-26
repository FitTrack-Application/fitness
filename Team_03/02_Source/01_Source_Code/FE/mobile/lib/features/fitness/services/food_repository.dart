import '../models/food.dart';

class FoodRepository {
  Future<List<Food>> fetchFoods({int offset = 0, int limit = 10}) async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
      limit,
          (index) => Food(
        id: offset + index,
        name: 'Food Item ${offset + index}',
        servingSize: 1.0,
        calories: 340,
        carbs: 50,
        fat: 10,
        protein: 20,
      ),
    );
  }

  Future<Food> getFoodById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return Food(
      id: id,
      name: "Fried Chicken (Stouffers fried chicken)",
      servingSize: 1.0,
      calories: 340,
      carbs: 28,
      fat: 16,
      protein: 20,
    );
  }
}