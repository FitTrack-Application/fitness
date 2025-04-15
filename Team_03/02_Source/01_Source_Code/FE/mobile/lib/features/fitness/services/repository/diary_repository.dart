import '../../models/diary.dart';
import '../../models/food.dart';

class DiaryRepository {
  final String jwtToken = "abc";

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $jwtToken',
  };

  String _formatDateForApi(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Future<Diary> getDiaryForDate(DateTime date) async {
  //   final formattedDate = _formatDateForApi(date);
  //
  //   try {
  //     final response = await _apiClient.get("/", queryParams: {
  //       'date': formattedDate,
  //     });
  //
  //     return Diary.fromJson(response['data']);
  //   } catch (e) {
  //     throw Exception('Failed to load diary: $e');
  //   }
  // }

  Future<Diary> getDiaryForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập delay

    return Diary(
      diaryId: 101,
      date: date,
      calorieGoal: 2200,
      foodItems: [
        Food(
          id: 'f1',
          name: 'Phở bò',
          servingSize: 350.0,
          calories: 500,
          protein: 25,
          carbs: 60,
          fat: 15,
          unit: 'g',
          description: 'Một tô phở bò nóng hổi',
          mealType: MealType.breakfast,
        ),
        Food(
          id: 'f2',
          name: 'Trứng luộc',
          servingSize: 100.0,
          calories: 150,
          protein: 13,
          carbs: 1,
          fat: 10,
          unit: 'g',
          description: 'Hai quả trứng gà luộc',
          mealType: MealType.lunch,
        ),
      ],
      exerciseItems: [

      ],
    );
  }

  Future<void> addFoodToDiary(
      int diaryId, String foodId, int servings, DateTime date) async {
    // try {
    //   await _apiClient.post("/add_food", body: {
    //     "diary_id": diaryId,
    //     "food_id": foodId,
    //     "serving_size": servings,
    //     "date": date.toIso8601String()
    //   });
    // } catch (e) {
    //   throw Exception('Failed to add food to diary: $e');
    // }

    // Giả lập thêm thành công
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Xóa món ăn khỏi nhật ký
  Future<void> removeFoodFromDiary(int diaryId, String foodId, DateTime date) async {
    // Trong môi trường thực tế
    // try {
    //   final formattedDate = _formatDateForApi(date);
    //   await _apiClient.delete("/remove_food", queryParams: {
    //     "diary_id": diaryId.toString(),
    //     "food_id": foodId,
    //     "date": formattedDate,
    //   });
    // } catch (e) {
    //   throw Exception('Failed to remove food from diary: $e');
    // }

    // Giả lập xóa thành công
    await Future.delayed(const Duration(milliseconds: 500));
  }
}