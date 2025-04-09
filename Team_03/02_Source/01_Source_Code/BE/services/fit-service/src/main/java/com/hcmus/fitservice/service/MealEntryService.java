package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;

import java.util.UUID;

public interface MealEntryService {
    void deleteMealEntry(UUID mealEntryId);

    MealEntryDto updateMealEntry(UUID mealEntryId, UUID foodId, String servingUnit, Integer numberOfServings);
}
