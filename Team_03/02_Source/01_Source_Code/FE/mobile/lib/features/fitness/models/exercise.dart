class Exercise {
  final String exerciseId;
  final int calories;

  Exercise({
    required this.exerciseId,
    required this.calories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exerciseId'] ?? '',
      calories: (json['calories'] ?? 0).toInt(),
    );
  }
}
