package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;

import java.util.UUID;

public interface MealEntryService {

    ApiResponse<Void> deleteMealEntry(UUID mealEntryId);

    ApiResponse<FoodEntryResponse> updateMealEntry(UUID mealEntryId, FoodEntryRequest foodEntryRequest);
}
