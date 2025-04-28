package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.response.MealLogResponse;
import com.hcmus.fitservice.dto.response.ApiResponse;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogService {

    ApiResponse<?> createDailyMealLogs(UUID userId, Date date);

    ApiResponse<FoodEntryDto> addMealEntry(UUID mealLogId, UUID foodId, String servingUnit, Double numberOfServings);

    ApiResponse<List<MealLogResponse>> getMealLogsByUserIdAndDate(UUID userId, Date date);
}
