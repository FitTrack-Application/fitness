package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.model.NutritionData;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.model.FitProfile;
import com.hcmus.statisticservice.model.NutritionGoal;
import com.hcmus.statisticservice.model.WeightGoal;
import com.hcmus.statisticservice.model.type.ActivityLevel;

import java.util.UUID;

public interface NutritionGoalService {

    NutritionGoal updateNutritionGoal(UUID userId);

    NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile);

    NutritionGoal updateNutritionGoal(UUID userId, WeightGoal weightGoal, Double currentWeight, ActivityLevel activityLevel);

    NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile, WeightGoal weightGoal, Double currentWeight);

    NutritionData calculateNutritionData(String gender, double curWeight, int curHeight, int curAge,
                                         String activityLevel, double weeklyGoal, double goalWeight);

    ApiResponse<GetNutritionGoalResponse> getNutritionGoal(UUID userId);
}
