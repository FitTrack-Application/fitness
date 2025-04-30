package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.dto.response.MealLogResponse;
import com.hcmus.fitservice.dto.response.ApiResponse;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogService {

    ApiResponse<?> createDailyMealLogs(UUID userId, Date date);

    ApiResponse<FoodEntryResponse> addMealEntry(UUID mealLogId, FoodEntryRequest foodEntryRequest);

    ApiResponse<List<MealLogResponse>> getMealLogsByUserIdAndDate(UUID userId, Date date);
}
