package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealLogDto;
import com.hcmus.fitservice.dto.response.ApiResponse;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface MealLogService {
    ApiResponse<Void> createMealLog(UUID userId, Date date, String mealType);

    ApiResponse<MealEntryDto> addMealEntry(UUID mealLogId, UUID foodId, String servingUnit, Double numberOfServings);

    // Get meal log by user id and date
    ApiResponse<List<MealLogDto>> getMealLogsByUserIdAndDate(UUID userId, Date date);
}
