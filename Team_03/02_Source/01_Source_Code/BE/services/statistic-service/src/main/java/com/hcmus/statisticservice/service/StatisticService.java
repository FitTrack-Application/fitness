package com.hcmus.statisticservice.service;


import com.hcmus.statisticservice.dto.request.InitWeightGoalRequest;
import com.hcmus.statisticservice.dto.request.AddStepRequest;
import com.hcmus.statisticservice.dto.request.AddWeightRequest;
import com.hcmus.statisticservice.dto.request.InitCaloriesGoalRequest;
import com.hcmus.statisticservice.dto.request.EditGoalRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;

import org.springframework.stereotype.Service;
import java.util.UUID;
import java.util.Map;
import java.lang.Object;

import java.util.List;
import java.lang.String;

@Service
public interface StatisticService {

    ApiResponse<?> addWeight(AddWeightRequest request, UUID userId);

    ApiResponse<List<Map<String, Object>>> getWeightProcess(UUID userId, Integer numDays);

    ApiResponse<?> initWeightGoal(InitWeightGoalRequest initWeightGoalRequest, UUID userId);

    ApiResponse<?> initCaloriesGoal(InitCaloriesGoalRequest initCaloriesGoalRequest, UUID userId);

    ApiResponse<?> getGoal(UUID userId, String authorizationHeader);

    ApiResponse<?> editGoal(EditGoalRequest editGoalRequest, UUID userId, String authorizationHeader);

    ApiResponse<?> getNutritionGoal(UUID userId);

    ApiResponse<?> addStep(AddStepRequest addStepRequest, UUID userId);
    
    ApiResponse<List<Map<String, Object>>> getStepProcess(UUID userId, Integer numDays);
}
