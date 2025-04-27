package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.model.Food;
import org.springframework.stereotype.Component;

@Component
public class FoodMapper {

    public FoodDto convertToFoodDto(Food food) {
        return FoodDto.builder()
                .id(food.getFoodId())
                .name(food.getFoodName())
                .fat(food.getFatPer100g())
                .carbs(food.getCarbsPer100g())
                .protein(food.getProteinPer100g())
                .calories(food.getCaloriesPer100g())
                .build();
    }
}