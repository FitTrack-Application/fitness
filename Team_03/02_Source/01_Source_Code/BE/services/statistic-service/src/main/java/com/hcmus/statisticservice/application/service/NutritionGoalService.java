package com.hcmus.statisticservice.application.service;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.NutritionData;
import com.hcmus.statisticservice.domain.model.NutritionGoal;
import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public interface NutritionGoalService {
    NutritionGoal updateNutritionGoal(UUID userId);

    NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile);

    NutritionGoal updateNutritionGoal(UUID userId, WeightGoal weightGoal, Double currentWeight,
                                      ActivityLevel activityLevel);

    NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile, WeightGoal weightGoal, Double currentWeight);

    NutritionData calculateNutritionData(String gender, double curWeight, int curHeight, int curAge,
                                         String activityLevel, double weeklyGoal, double goalWeight);

    ApiResponse<GetNutritionGoalResponse> getNutritionGoal(UUID userId);
}