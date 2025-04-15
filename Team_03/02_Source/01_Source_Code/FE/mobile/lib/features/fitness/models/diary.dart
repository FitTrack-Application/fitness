import 'exercise.dart';
import 'food.dart';

class Diary {
  final int diaryId;
  final DateTime date;
  final int calorieGoal;
  final List<Food> foodItems;
  final List<Exercise> exerciseItems;

  Diary({
    required this.diaryId,
    required this.date,
    required this.calorieGoal,
    required this.foodItems,
    required this.exerciseItems,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      diaryId: json['diary_id'] ?? 0,
      date: DateTime.parse(json['date']),
      calorieGoal: 2390,
      foodItems: (json['food'] as List? ?? [])
          .map((item) => Food.fromJson(item))
          .toList(),
      exerciseItems: (json['exercise'] as List? ?? [])
          .map((item) => Exercise.fromJson(item))
          .toList(),
    );
  }

  /// Tính tổng lượng calories từ thức ăn
  double get caloriesConsumed {
    return foodItems.fold(0, (sum, item) => sum + item.calories);
  }

  /// Tính tổng lượng calories đã đốt cháy từ tập thể dục
  double get caloriesBurned {
    return exerciseItems.fold(0, (sum, item) => sum + item.calories);
  }

  /// Tính lượng calories còn lại
  double get caloriesRemaining {
    return calorieGoal - caloriesConsumed + caloriesBurned;
  }
}
