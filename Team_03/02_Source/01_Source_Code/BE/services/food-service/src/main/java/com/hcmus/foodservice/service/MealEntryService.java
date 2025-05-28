package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.TotalCaloriesConsumedResponse;
import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;

import java.util.UUID;

public interface MealEntryService {

    ApiResponse<Void> deleteMealEntryById(UUID mealEntryId);

    ApiResponse<FoodEntryResponse> updateMealEntryById(UUID mealEntryId, FoodEntryRequest foodEntryRequest);

    ApiResponse<TotalCaloriesConsumedResponse> getTotalCaloriesConsumedByUserId(UUID userId);

}
