import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';
import 'package:mobile/features/auth/models/user_profile.dart';
import 'package:dio/dio.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // UserProfile instance
  UserProfile userProfile = UserProfile(
    imageUrl: "",
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
  Future<void> fetchProfile(BuildContext context) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final profileData = await _apiService.getProfile(context);
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

  Future<void> updateProfile(BuildContext context, {File? imageFile}) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      // Convert the existing `userProfile` instance to a JSON map
      final profileData = userProfile.toJson();

      // Call the API to update the profile
      await _apiService.editProfile(profileData,
          imageFile: imageFile, context: context);

      // Notify listeners to refresh the UI
      notifyListeners();
    } catch (e) {
      hasError = true;

      // Handle DioException specifically
      if (e is DioError) {
        errorMessage =
            "Failed to update profile: ${e.response?.data ?? e.message}";
      } else {
        errorMessage = "An unexpected error occurred: ${e.toString()}";
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // Update individual fields in the UserProfile
}
