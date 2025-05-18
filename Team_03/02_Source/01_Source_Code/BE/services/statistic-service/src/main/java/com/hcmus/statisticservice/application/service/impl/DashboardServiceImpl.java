package com.hcmus.statisticservice.application.service.impl;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.hcmus.statisticservice.infrastructure.client.ExerciseServiceClient;
import com.hcmus.statisticservice.infrastructure.client.FoodServiceClient;

import lombok.AllArgsConstructor;

import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.DashboardResponse;
import com.hcmus.statisticservice.application.service.DashboardService;
import com.hcmus.statisticservice.domain.repository.NutritionGoalRepository;
import com.hcmus.statisticservice.application.dto.response.TotalCaloriesBurnedResponse;

import java.util.UUID;

@Service
@AllArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final ExerciseServiceClient exerciseServiceClient;
    private final NutritionGoalRepository nutritionGoalRepository;
    private final FoodServiceClient foodServiceClient;
    
    @Override
    public ApiResponse<DashboardResponse> getDashboard(UUID userId) {
        int totalCaloriesBurned = exerciseServiceClient.getTotalCaloriesBurnedByUserId(userId).getData().getTotalCaloriesBurned();      
        DashboardResponse dashboardResponse = new DashboardResponse();

        int caloriesGoal = nutritionGoalRepository.findByUserId(userId)
            .orElseThrow(() -> new IllegalArgumentException("Nutrition goal not found for user: " + userId))
            .getCalories();

        double totalCaloriesConsumed = foodServiceClient.getTotalCaloriesConsumedByUserId(userId).getData().getTotalCaloriesConsumed();

        dashboardResponse.setTotalCaloriesBurned(totalCaloriesBurned);
        dashboardResponse.setCaloriesGoal(caloriesGoal);
        dashboardResponse.setTotalCaloriesConsumed(totalCaloriesConsumed);
        
        return ApiResponse.<DashboardResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get dashboard successfully")
                .data(dashboardResponse)
                .build();
    
    }
}
