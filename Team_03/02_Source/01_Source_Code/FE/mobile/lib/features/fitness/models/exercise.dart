class Exercise {
  final String exerciseId;
  final String exerciseName;
  final int calories;
  final int duration;
  final String description;

  Exercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.calories,
    required this.duration,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exerciseId'] ?? '',
      exerciseName: json['exerciseName'] ?? '',
      calories: (json['calories'] ?? 0).toInt(),
      duration: (json['duration'] ?? 0).toInt(),
      description: json['description'] ?? '',
    );
  }
}