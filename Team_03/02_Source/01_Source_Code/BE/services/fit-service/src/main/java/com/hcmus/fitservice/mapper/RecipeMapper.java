package com.hcmus.fitservice.mapper;


import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.response.RecipeResponse;
import com.hcmus.fitservice.model.Recipe;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class RecipeMapper {
    private final FoodEntryMapper foodEntryMapper;


    // From Recipe to RecipeResponse
    public RecipeResponse convertToRecipeResponse(Recipe recipe) {
//        if (recipe.getRecipeEntries() == null || recipe.getRecipeEntries().isEmpty()) {
//            return RecipeResponse.builder()
//                    .id(recipe.getRecipeId())
//                    .name(recipe.getRecipeName())
//                    .direction(recipe.getDirection())
//                    .recipeEntries(List.of())
//                    .build();
//        }
        List<FoodEntryResponse> foodEntryResponses = recipe.getRecipeEntries().stream()
                .map(foodEntryMapper::convertToFoodEntryDto)
                .toList();

        return RecipeResponse.builder()
                .id(recipe.getRecipeId())
                .name(recipe.getRecipeName())
                .direction(recipe.getDirection())
                .recipeEntries(foodEntryResponses)
                .build();
    }

}
