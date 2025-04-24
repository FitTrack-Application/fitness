package com.hcmus.fitservice.mapper;


import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.response.RecipeResponse;
import com.hcmus.fitservice.model.Recipe;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class RecipeMapper {
    private final FoodEntryMapper foodEntryMapper;

    public RecipeResponse convertToRecipeResponse(Recipe recipe) {
        List<FoodEntryDto> foodEntryDtos = recipe.getRecipeEntries().stream()
                .map(foodEntryMapper::convertToFoodEntryDto)
                .toList();

        return RecipeResponse.builder()
                .id(recipe.getRecipeId())
                .name(recipe.getRecipeName())
                .direction(recipe.getDirection())
                .recipeEntries(foodEntryDtos)
                .build();
    }
}
