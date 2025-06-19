package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.AddRecipeToMealLogRequest;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.MealLogResponse;
import com.hcmus.foodservice.dto.response.ApiResponse;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogService {

    ApiResponse<?> createDailyMealLogs(UUID userId, Date date);

    ApiResponse<FoodEntryResponse> addFoodToMealLog(UUID mealLogId, FoodEntryRequest foodEntryRequest);

    ApiResponse<List<FoodEntryResponse>> addRecipeToMealLog(UUID mealLogId, AddRecipeToMealLogRequest addRecipeToMealLogRequest);

    ApiResponse<List<MealLogResponse>> getMealLogsByUserIdAndDate(UUID userId, Date date);
}
