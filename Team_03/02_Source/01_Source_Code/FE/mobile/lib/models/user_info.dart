class UserInfo {
  final String name;
  final String goal;
  final String gender;
  final int age;
  final double height;
  final double weight;
  final double weightGoal;
  final double goalPerWeek;
  final String activityLevel;
  final double bmr;

  UserInfo({
    required this.name,
    required this.goal,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.weightGoal,
    required this.goalPerWeek,
    required this.activityLevel,
    required this.bmr,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      goal: json['goal'],
      gender: json['gender'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      weightGoal: json['weightGoal'],
      goalPerWeek: json['goalPerWeek'],
      activityLevel: json['activityLevel'],
      bmr: json['bmr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'goal': goal,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'weightGoal': weightGoal,
      'goalPerWeek': goalPerWeek,
      'activityLevel': activityLevel,
      'bmr': bmr,
    };
  }


}
