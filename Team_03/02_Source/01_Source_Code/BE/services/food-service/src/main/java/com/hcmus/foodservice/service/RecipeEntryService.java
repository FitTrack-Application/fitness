package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.request.FoodEntryRequest;

import java.util.UUID;

public interface RecipeEntryService {
    FoodEntryResponse createRecipeEntry(UUID recipeId, FoodEntryRequest foodEntryRequest);

//    FoodEntryDto updateRecipeEntry(UUID recipeEntryId, FoodEntryRequest foodEntryRequest);
}
