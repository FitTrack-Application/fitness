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
  DashboardLogModel({
    required this.caloriesGoal,
    required this.totalCaloriesConsumed,
    required this.totalCaloriesBurned,
  });

  factory DashboardLogModel.fromJson(Map<String, dynamic> json) {
    return DashboardLogModel(
      caloriesGoal: (json['caloriesGoal'] as num).toInt(),
      totalCaloriesConsumed: (json['totalCaloriesConsumed'] as num).toInt(),
      totalCaloriesBurned: (json['totalCaloriesBurned'] as num).toInt(),
    );
  }
}