import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';
import 'package:mobile/features/auth/models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // UserProfile instance
  UserProfile userProfile = UserProfile(
    imageUrl: "https://example.com/avatar.jpg",
    name: "",
    height: 0.0,
    gender: "",
    age: 0,
    activityLevel: "",
  );

  // Loading and error states
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = "";

  // Fetch profile data
  Future<void> fetchProfile() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final profileData = await _apiService.getProfile();
      debugPrint("API Response: $profileData"); // Log the API response

      userProfile = UserProfile.fromJson(profileData);
      debugPrint(
          "Updated UserProfile: ${userProfile.toJson()}"); // Log the updated userProfile

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      debugPrint("Error fetching profile: $e"); // Log the error
      notifyListeners();
    }
  }

  // Update individual fields in the UserProfile
  void updateHeight(double newHeight) {
    userProfile.height = newHeight;
    notifyListeners();
  }

  void updateGender(String newGender) {
    userProfile.gender = newGender;
    notifyListeners();
  }

  void updateAge(int newAge) {
    userProfile.age = newAge;
    notifyListeners();
  }
}
