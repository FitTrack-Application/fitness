package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.response.MealLogResponse;
import com.hcmus.fitservice.model.MealLog;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class MealLogMapper {

    private final FoodEntryMapper foodEntryMapper;

    public MealLogResponse converToMealLogResponse (MealLog mealLog) {
        List<FoodEntryResponse> foodEntryResponses = mealLog.getMealEntries().stream().map(foodEntryMapper::convertToFoodEntryDto).toList();

        return MealLogResponse.builder()
                .id(mealLog.getMealLogId())
                .date(mealLog.getDate())
                .mealType(mealLog.getMealType().name())
                .mealEntries(foodEntryResponses)
                .build();
    }
}
