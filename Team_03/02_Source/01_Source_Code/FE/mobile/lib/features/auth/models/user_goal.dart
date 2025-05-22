class UserGoal {
  double startingWeight;
  double currentWeight;
  double goalWeight;
  double weeklyGoal;
  DateTime startingDate;
  String activityLevel;

  UserGoal({
    required this.startingWeight,
    required this.currentWeight,
    required this.goalWeight,
    required this.weeklyGoal,
    required this.startingDate,
    required this.activityLevel,
  });

  // Factory constructor to create a UserGoal from a JSON map
  factory UserGoal.fromJson(Map<String, dynamic> json) {
    final startingWeight = json['startingWeight']?.toDouble() ?? 0.0;
    final goalWeight = json['goalWeight']?.toDouble() ?? 0.0;

    return UserGoal(
      startingWeight: startingWeight,
      currentWeight: json['currentWeight']?.toDouble() ?? 0.0,
      goalWeight: json['goalWeight']?.toDouble() ?? 0.0,
      weeklyGoal: json['weeklyGoal']?.toDouble() ?? 0.0,
      startingDate: DateTime.parse(json['startingDate']),
      activityLevel: json['activityLevel'] ?? '',
    );
  }

  // Convert UserGoal to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'startingWeight': startingWeight,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'weeklyGoal': weeklyGoal,
      'startingDate': startingDate.toIso8601String(),
      'activityLevel': activityLevel,
    };
  }
}
