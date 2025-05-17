package com.hcmus.foodservice.mapper;

import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.mapper.helper.Macros;
import com.hcmus.foodservice.mapper.helper.MacrosCalculatorHelper;
import com.hcmus.foodservice.model.MealEntry;
import com.hcmus.foodservice.model.RecipeEntry;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class FoodEntryMapper {

    private final ServingUnitMapper servingUnitMapper;

    // From RecipeEntry to FoodEntryDto
    public FoodEntryResponse convertToFoodEntryDto(RecipeEntry recipeEntry) {

        // Calculate macros
        Macros macros = MacrosCalculatorHelper.calculateMacros(recipeEntry.getFood(), recipeEntry.getServingUnit(), recipeEntry.getNumberOfServings());

        return FoodEntryResponse.builder()
                .id(recipeEntry.getRecipeEntryId())
                .foodId(recipeEntry.getFood().getFoodId())
                .servingUnit(servingUnitMapper.convertToServingUnitResponse(recipeEntry.getServingUnit()))
                .numberOfServings(recipeEntry.getNumberOfServings())
                .calories(macros.getCalories())
                .protein(macros.getProtein())
                .carbs(macros.getCarbs())
                .fat(macros.getFat())
                .build();
    }

    // From MealEntry to FoodEntryDto
    public FoodEntryResponse convertToFoodEntryDto(MealEntry mealEntry) {
        // Calculate macros
        Macros macros = MacrosCalculatorHelper.calculateMacros(mealEntry.getFood(), mealEntry.getServingUnit(), mealEntry.getNumberOfServings());

        return FoodEntryResponse.builder()
                .id(mealEntry.getMealEntryId())
                .foodId(mealEntry.getFood().getFoodId())
                .servingUnit(servingUnitMapper.convertToServingUnitResponse(mealEntry.getServingUnit()))
                .numberOfServings(mealEntry.getNumberOfServings())
                .calories(macros.getCalories())
                .protein(macros.getProtein())
                .carbs(macros.getCarbs())
                .fat(macros.getFat())
                .build();
    }
}
