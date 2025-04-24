package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.Recipe;
import com.hcmus.fitservice.model.RecipeEntry;
import com.hcmus.fitservice.model.type.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.RecipeEntryRepository;
import com.hcmus.fitservice.repository.RecipeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RecipeEntryServiceImpl implements RecipeEntryService {
    private final RecipeEntryRepository recipeEntryRepository;

    private final RecipeRepository recipeRepository;

    private final FoodRepository foodRepository;

    // Create Recipe entry
    @Override
    public FoodEntryDto createRecipeEntry(UUID recipeId, FoodEntryRequest foodEntryRequest) {
        // Find the Recipe by ID
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId));

        // Find the Food by ID
        Food food = foodRepository.findById(foodEntryRequest.getFoodId())
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodEntryRequest.getFoodId()));

        // Create Recipe entry
        RecipeEntry recipeEntry = new RecipeEntry();
        recipeEntry.setRecipe(recipe);
        recipeEntry.setFood(food);
        recipeEntry.setNumberOfServings(foodEntryRequest.getNumberOfServings());
        recipeEntry.setServingUnit(ServingUnit.valueOf(foodEntryRequest.getServingUnit()));

        recipeEntryRepository.save(recipeEntry);

        // Return FoodEntryDto
        return new FoodEntryDto(recipe.getRecipeId(),
                food.getFoodId(),
                foodEntryRequest.getServingUnit(),
                foodEntryRequest.getNumberOfServings());
    }
}
