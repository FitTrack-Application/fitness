class UserProfile {
  String imageUrl;
  String name;
  double height;
  String gender;
  int age;
  String activityLevel;

  UserProfile({
    required this.imageUrl,
    required this.name,
    required this.height,
    required this.gender,
    required this.age,
    required this.activityLevel,
  });

  // Factory constructor to create a UserProfile from a JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      imageUrl: json["imageUrl"] ?? "https://example.com/avatar.jpg",
      name: json["name"] ?? "",
      height: json["height"]?.toDouble() ?? 0.0,
      gender: json["gender"] ?? "",
      age: json["age"] ?? 0,
      activityLevel: json["activityLevel"] ?? "LIGHT",
    );
  }

  // Convert UserProfile to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "name": name,
      "height": height,
      "gender": gender,
      "age": age,
      "activityLevel": activityLevel,
    };
  }
}
