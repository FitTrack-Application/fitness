class UserInfo {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String goalType;
  final double weightGoal;
  final double goalPerWeek;
  final String? imageURL;
  final String activityLevel;
  final double calorieGoal;

  UserInfo({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goalType,
    required this.weightGoal,
    required this.goalPerWeek,
    this.imageURL,
    required this.activityLevel,
    required this.calorieGoal,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      goalType: json['goalType'],
      weightGoal: json['weightGoal'],
      goalPerWeek: json['goalPerWeek'],
      imageURL: json['imageURL'],
      activityLevel: json['activityLevel'],
      calorieGoal: json['calorieGoal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'goalType': goalType,
      'weightGoal': weightGoal,
      'goalPerWeek': goalPerWeek,
      'imageURL': imageURL,
      'activityLevel': activityLevel,
      'calorieGoal': calorieGoal,
    };
  }
}
