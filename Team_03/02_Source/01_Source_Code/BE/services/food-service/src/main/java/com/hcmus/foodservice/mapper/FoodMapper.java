package com.hcmus.foodservice.mapper;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.foodservice.mapper.helper.Macros;
import com.hcmus.foodservice.mapper.helper.MacrosCalculatorHelper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.ServingUnit;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class FoodMapper {

    private final ServingUnitMapper servingUnitMapper;

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
                .servingUnit(servingUnitMapper.convertToServingUnitResponse(servingUnit))
                .numberOfServings(numberOfServings)
                .calories(macros.getCalories())
                .protein(macros.getProtein())
                .carbs(macros.getCarbs())
                .fat(macros.getFat())
                .build();
    }
}