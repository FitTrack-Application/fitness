import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Fields for profile data
  String imageURL = "";
  String name = "";
  double height = 0.0;
  String gender = "";
  int age = 0;
  String email = "";

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

      // Update fields with API response
      imageURL = profileData["imageUrl"] ??
          "https://example.com/avatar.jpg"; // Handle null imageUrl
      name = profileData["name"] ?? "";
      height = profileData["height"]?.toDouble() ?? 0.0;
      gender = profileData["gender"] ?? "";
      age = profileData["age"] ?? 0;
      email = profileData["email"] ?? "";

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
