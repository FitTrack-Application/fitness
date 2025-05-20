class Exercise {
  final String id;
  final String name;
  final int caloriesBurnedPerMinute;

  Exercise({
    required this.id,
    required this.name,
    required this.caloriesBurnedPerMinute,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      caloriesBurnedPerMinute: (json['caloriesBurnedPerMinute'] ?? 0).toInt(),
    );
  }
}
