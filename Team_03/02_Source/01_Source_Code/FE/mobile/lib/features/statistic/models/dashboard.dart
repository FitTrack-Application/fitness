class MealLog {
  final int id;
  final String name;
  final int calories;

  MealLog({required this.id, required this.name, required this.calories});

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
    );
  }
}

class ActivityLog {
  final int id;
  final String name;
  final int caloriesBurned;

  ActivityLog({required this.id, required this.name, required this.caloriesBurned});

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'],
      name: json['name'],
      caloriesBurned: json['caloriesBurned'],
    );
  }
}

class Macronutrients {
  final int carbs;
  final int protein;
  final int fat;

  Macronutrients({required this.carbs, required this.protein, required this.fat});

  factory Macronutrients.fromJson(Map<String, dynamic> json) {
    return Macronutrients(
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
    );
  }
}

class DashboardLogModel {
  final int caloriesGoal;
  final int totalCaloriesConsumed;
  final int totalCaloriesBurned;
  final Macronutrients macronutrients;
  final List<MealLog> meals;
  final List<ActivityLog> activities;

  DashboardLogModel({
    required this.caloriesGoal,
    required this.totalCaloriesConsumed,
    required this.totalCaloriesBurned,
    required this.macronutrients,
    required this.meals,
    required this.activities,
  });

  factory DashboardLogModel.fromJson(Map<String, dynamic> json) {
    return DashboardLogModel(
      caloriesGoal: json['caloriesGoal'],
      totalCaloriesConsumed: json['totalCaloriesConsumed'],
      totalCaloriesBurned: json['totalCaloriesBurned'],
      macronutrients: Macronutrients.fromJson(json['macronutrients']),
      meals: (json['meals'] as List)
          .map((mealJson) => MealLog.fromJson(mealJson))
          .toList(),
      activities: (json['activities'] as List)
          .map((actJson) => ActivityLog.fromJson(actJson))
          .toList(),
    );
  }
}
