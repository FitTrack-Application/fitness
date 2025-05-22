import 'package:flutter/material.dart';
import 'package:mobile/features/auth/services/api_service.dart';

class SurveyViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Fields for survey data
  String name = 'Nguyễn Văn A';
  int age = 28;
  String gender = 'MALE';
  double height = 175.0;
  double weight = 70.5;
  String goal = "Gain weight";
  double weightGoal = 75;
  double goalPerWeek = 0.2;
  String activityLevel = 'MODERATE';

  // Calculate daily net calorie goal
  double calculateCalorieGoal() {
    double calorieGoal;

    // Base calorie calculation using Mifflin-St Jeor Equation
    if (gender == 'MALE') {
      calorieGoal = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      calorieGoal = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Adjust for activity level
    double activityFactor;
    switch (activityLevel) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly active':
        activityFactor = 1.375;
        break;
      case 'Moderately active':
        activityFactor = 1.55;
        break;
      case 'Very active':
        activityFactor = 1.725;
        break;
      case 'Extra active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.0;
    }
    calorieGoal *= activityFactor;

    // Adjust for goal type
    switch (goal) {
      case 'Lose weight':
        calorieGoal -= 500 * goalPerWeek; // Subtract calories for weight loss
        break;
      case 'Gain weight':
        calorieGoal += 500 * goalPerWeek; // Add calories for weight gain
        break;
      case 'Maintain weight':
        break; // No adjustment for maintenance
      default:
        break;
    }

    return calorieGoal;
  }

  // Send survey data to the API
  Future<bool> sendSurveyData() async {
    final userInfo = {
      "name": name,
      "age": age,
      "gender": gender,
      "height": height,
      "weight": weight,
      "goalWeight": weightGoal,
      "weeklyGoal": goalPerWeek,
      "activityLevel": activityLevel,
      "imageUrl": null,
      "startingDate":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
    };

    try {
      await _apiService.userSurvey(userInfo);
      debugPrint("Survey data submitted successfully!");
      return true; // Indicate success
    } catch (e) {
      debugPrint("Error submitting survey: $e");
      return false; // Indicate failure
    }
  }
}
