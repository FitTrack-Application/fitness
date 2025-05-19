package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.GetNutritionGoalResponse;
import com.hcmus.statisticservice.application.service.NutritionGoalService;
import com.hcmus.statisticservice.domain.exception.NutritionException;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.NutritionData;
import com.hcmus.statisticservice.domain.model.NutritionGoal;
import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import com.hcmus.statisticservice.domain.repository.NutritionGoalRepository;
import com.hcmus.statisticservice.domain.repository.WeightGoalRepository;
import com.hcmus.statisticservice.domain.repository.WeightLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NutritionGoalServiceImpl implements NutritionGoalService {

    final private NutritionGoalRepository nutritionGoalRepository;
    final private FitProfileRepository fitProfileRepository;
    final private WeightLogRepository weightLogRepository;
    final private WeightGoalRepository weightGoalRepository;

    @Override
    public NutritionGoal updateNutritionGoal(UUID userId) {
        FitProfile profile = fitProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new NutritionException("Fit profile not found!"));
        return updateNutritionGoal(userId, profile);
    }

    @Override
    public NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile) {
        WeightGoal weightGoal = weightGoalRepository.findByUserId(userId)
                .orElseThrow(() -> new NutritionException("Weight goal not found!"));

        Double currentWeight = weightLogRepository.findFirstByUserIdOrderByDateDesc(userId)
                .orElseThrow(() -> new NutritionException("Current weight not found!")).getWeight();
        try {
            return updateNutritionGoal(userId, profile, weightGoal, currentWeight);
        } catch (Exception e) {
            throw new NutritionException("Failed to update nutrition goal: " + e.getMessage());
        }
    }

    @Override
    public NutritionGoal updateNutritionGoal(UUID userId, WeightGoal weightGoal, Double currentWeight,
                                             ActivityLevel activityLevel) {
        FitProfile profile = fitProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new NutritionException("Fit profile not found!"));
        profile.setActivityLevel(activityLevel);
        try {
            return updateNutritionGoal(userId, profile, weightGoal, currentWeight);
        } catch (Exception e) {
            throw new NutritionException("Failed to update nutrition goal: " + e.getMessage());
        }
    }

    @Override
    public NutritionGoal updateNutritionGoal(UUID userId, FitProfile profile, WeightGoal weightGoal,
                                             Double currentWeight) {
        NutritionData nutritionData = calculateNutritionData(
                profile.getGender().name(),
                currentWeight,
                profile.getHeight(),
                profile.getAge(),
                profile.getActivityLevel().name(),
                weightGoal.getWeeklyGoal(),
                weightGoal.getGoalWeight());

        NutritionGoal nutritionGoal = nutritionGoalRepository.findByUserId(userId).orElse(null);

        if (nutritionGoal != null) {
            nutritionGoal.setCalories(nutritionData.getCalories());
            nutritionGoal.setProtein(nutritionData.getProtein());
            nutritionGoal.setFat(nutritionData.getFat());
            nutritionGoal.setCarbs(nutritionData.getCarbs());
        } else {
            nutritionGoal = NutritionGoal.builder()
                    .userId(userId)
                    .calories(nutritionData.getCalories())
                    .protein(nutritionData.getProtein())
                    .fat(nutritionData.getFat())
                    .carbs(nutritionData.getCarbs())
                    .build();
        }
        return nutritionGoalRepository.save(nutritionGoal);
    }

    public NutritionData calculateNutritionData(String gender, double curWeight, int curHeight, int curAge,
                                                String activityLevel, double weeklyGoal, double goalWeight) {
        double bmrNumber = 10 * curWeight + 6.25 * curHeight - 5 * curAge;

        if ("MALE".equalsIgnoreCase(gender)) {
            bmrNumber += 5;
        } else {
            bmrNumber -= 161;
        }

        double activityMultiplier = switch (activityLevel.toUpperCase()) {
            case "SEDENTARY" -> 1.2;
            case "LIGHT" -> 1.375;
            case "MODERATE" -> 1.55;
            case "ACTIVE" -> 1.725;
            case "VERY_ACTIVE" -> 1.9;
            default -> 1.0;
        };
        double caloriesGoal = bmrNumber * activityMultiplier;

        if (goalWeight < curWeight) {
            caloriesGoal -= 1100 * weeklyGoal;
        } else {
            caloriesGoal += 1100 * weeklyGoal;
        }

        int roundedCalories = (int) Math.round(caloriesGoal);
        double protein = caloriesGoal * 0.3 / 4;
        double fat = caloriesGoal * 0.25 / 9;
        double carb = caloriesGoal * 0.45 / 4;

        return new NutritionData(roundedCalories, protein, fat, carb);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ApiResponse<GetNutritionGoalResponse> getNutritionGoal(UUID userId) {
        NutritionGoal nutritionGoal = updateNutritionGoal(userId);

        GetNutritionGoalResponse getNutritionGoalResponse = GetNutritionGoalResponse.builder()
                .calories(nutritionGoal.getCalories())
                .macronutrients(
                        GetNutritionGoalResponse.Macronutrients.builder()
                                .protein(nutritionGoal.getProtein())
                                .fat(nutritionGoal.getFat())
                                .carbs(nutritionGoal.getCarbs())
                                .build())
                .build();

        return ApiResponse.<GetNutritionGoalResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved nutrition goal!")
                .data(getNutritionGoalResponse)
                .build();
    }
}