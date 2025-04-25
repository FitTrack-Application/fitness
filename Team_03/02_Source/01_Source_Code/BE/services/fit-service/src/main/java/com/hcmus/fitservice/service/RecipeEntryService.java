package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;

import java.util.UUID;

public interface RecipeEntryService {
    FoodEntryDto createRecipeEntry(UUID recipeId, FoodEntryRequest foodEntryRequest);

//    FoodEntryDto updateRecipeEntry(UUID recipeEntryId, FoodEntryRequest foodEntryRequest);
}
