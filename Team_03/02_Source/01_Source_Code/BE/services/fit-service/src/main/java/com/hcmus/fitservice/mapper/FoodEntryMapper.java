package com.hcmus.fitservice.mapper;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.model.MealEntry;
import com.hcmus.fitservice.model.RecipeEntry;
import org.springframework.stereotype.Component;

@Component
public class FoodEntryMapper {
    // From RecipeEntry to FoodEntryDto
    public FoodEntryDto convertToFoodEntryDto(RecipeEntry recipeEntry) {
        return new FoodEntryDto(
                recipeEntry.getRecipeEntryId(),
                recipeEntry.getFood().getFoodId(),
                recipeEntry.getServingUnit().toString(),
                recipeEntry.getNumberOfServings()
        );
    }

    // From MealEntry to FoodEntryDto
    public FoodEntryDto convertToFoodEntryDto(MealEntry mealEntry) {
        return new FoodEntryDto(
                mealEntry.getMealEntryId(),
                mealEntry.getFood().getFoodId(),
                mealEntry.getServingUnit().toString(),
                mealEntry.getNumberOfServings()
        );
    }
}
