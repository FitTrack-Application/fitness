class UserProfile {
  String imageUrl;
  String name;
  double height;
  String gender; // Stored as "Male", "Female", etc.
  int age;
  String activityLevel; // Stored as "Light", "Moderate", etc.

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
    // Map gender and activityLevel from uppercase to readable format
    final genderMapping = {
      "MALE": "Male",
      "FEMALE": "Female",
      "OTHER": "Other",
    };

    final activityLevelMapping = {
      "SEDENTARY": "Sedentary",
      "LIGHT": "Light",
      "MODERATE": "Moderate",
      "ACTIVE": "Active",
      "VERY_ACTIVE": "Very Active",
    };

    return UserProfile(
      imageUrl: json["imageUrl"] ?? "https://example.com/avatar.jpg",
      name: json["name"] ?? "",
      height: json["height"]?.toDouble() ?? 0.0,
      gender: genderMapping[json["gender"]] ?? json["gender"] ?? "",
      age: json["age"] ?? 0,
      activityLevel: activityLevelMapping[json["activityLevel"]] ??
          json["activityLevel"] ??
          "",
    );
  }

  // Convert UserProfile to a JSON map
  Map<String, dynamic> toJson() {
    // Map gender and activityLevel back to uppercase format
    final genderMapping = {
      "Male": "MALE",
      "Female": "FEMALE",
      "Other": "OTHER",
    };

    final activityLevelMapping = {
      "Sedentary": "SEDENTARY",
      "Light": "LIGHT",
      "Moderate": "MODERATE",
      "Active": "ACTIVE",
      "Very Active": "VERY_ACTIVE",
    };

    return {
      "imageUrl": imageUrl,
      "name": name,
      "height": height,
      "gender": genderMapping[gender] ?? gender,
      "age": age,
      "activityLevel": activityLevelMapping[activityLevel] ?? activityLevel,
    };
  }
}
