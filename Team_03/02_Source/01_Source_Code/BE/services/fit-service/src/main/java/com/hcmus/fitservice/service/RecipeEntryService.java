package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;

import java.util.UUID;

public interface RecipeEntryService {
    FoodEntryResponse createRecipeEntry(UUID recipeId, FoodEntryRequest foodEntryRequest);

//    FoodEntryDto updateRecipeEntry(UUID recipeEntryId, FoodEntryRequest foodEntryRequest);
}
