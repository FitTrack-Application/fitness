package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.response.ApiResponse;

import java.util.UUID;

public interface MealEntryService {

    ApiResponse<Void> deleteMealEntry(UUID mealEntryId);

    ApiResponse<MealEntryDto> updateMealEntry(UUID mealEntryId, UUID foodId, String servingUnit, Double numberOfServings);
}
