package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.fitservice.mapper.helper.Macros;
import com.hcmus.fitservice.mapper.helper.MacrosCalculatorHelper;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.ServingUnit;
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

    public FoodMacrosDetailsResponse converToFoodMacrosDetailsResponse(Food food, ServingUnit servingUnit, Double numberOfServings) {
        // Calculate macros
        Macros macros = MacrosCalculatorHelper.calculateMacros(food, servingUnit, numberOfServings);

        return FoodMacrosDetailsResponse.builder()
                .id(food.getFoodId())
                .name(food.getFoodName())
                .imageUrl(food.getImageUrl())
                .servingUnit(servingUnit.getUnitName())
                .numberOfServings(numberOfServings)
                .calories(macros.getCalories())
                .protein(macros.getProtein())
                .carbs(macros.getCarbs())
                .fat(macros.getFat())
                .build();
    }
}