package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealLogDto;

import java.util.Date;
import java.util.UUID;

public interface MealLogService {
    void createMealLog(UUID userId, Date date, String mealType);

    MealEntryDto addMealEntry(UUID mealLogId, UUID foodId, String servingUnit, Integer numberOfServings);

    // Get meal log by user id and date
    MealLogDto getMealLogByUserIdAndDate(UUID userId, Date date);
}
