package com.hcmus.statisticserivce.service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface FoodLogService {
    List<FoodLogDto> getAllFoodLogs();

    FoodLogDto getFoodLogById(UUID id);

    List<FoodLogDto> getFoodLogsByUserId(UUID userId);

    List<FoodLogDto> getFoodLogsByUserIdAndDate(UUID userId, LocalDate date);

    List<FoodLogDto> getFoodLogsByUserIdAndDateRange(UUID userId, LocalDate startDate, LocalDate endDate);

    FoodLogDto createFoodLog(FoodLogDto foodLogDto);

    FoodLogDto updateFoodLog(UUID id, FoodLogDto foodLogDto);

    void deleteFoodLog(UUID id);
}