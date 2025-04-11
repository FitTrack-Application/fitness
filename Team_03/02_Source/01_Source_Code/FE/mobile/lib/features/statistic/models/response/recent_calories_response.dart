class RecentCaloriesData {
  final String userId;
  final List<DailyCalories> days;
  final double goal;

  RecentCaloriesData({
    required this.userId,
    required this.days,
    required this.goal,
  });

  factory RecentCaloriesData.fromJson(Map<String, dynamic> json) {
    return RecentCaloriesData(
      userId: json['user_id'],
      days: (json['days'] as List)
          .map((item) => DailyCalories.fromJson(item))
          .toList(),
      goal: (json['goal'] as num).toDouble(),
    );
  }
}

class DailyCalories {
  final String date;
  final double consumedCalories;
  final double burnedCalories;

  DailyCalories({
    required this.date,
    required this.consumedCalories,
    required this.burnedCalories,
  });

  double get netCalories => consumedCalories - burnedCalories;

  factory DailyCalories.fromJson(Map<String, dynamic> json) {
    return DailyCalories(
      date: json['date'],
      consumedCalories: (json['consumed_calories'] as num).toDouble(),
      burnedCalories: (json['burned_calories'] as num).toDouble(),
    );
  }
}