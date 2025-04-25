package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.mapper.FoodEntryMapper;
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

    private final FoodEntryMapper foodEntryMapper;

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

        // Save Recipe entry
        RecipeEntry savedRecipeEntry = recipeEntryRepository.save(recipeEntry);

        // Return FoodEntryDto
        return foodEntryMapper.convertToFoodEntryDto(savedRecipeEntry);
    }

//    // Update Recipe entry
//    @Override
//    public FoodEntryDto updateRecipeEntry(UUID recipeEntryId, FoodEntryRequest foodEntryRequest) {
//        // Check if Recipe entry exists
//        RecipeEntry recipeEntry = recipeEntryRepository.findById(recipeEntryId)
//                .orElseThrow(() -> new ResourceNotFoundException("Recipe entry not found with ID: " + recipeEntryId));
//
//        // Check if Recipe exists
//        Recipe recipe = recipeEntry.getRecipe();
//        if (recipe == null) {
//            throw new ResourceNotFoundException("Recipe not found for Recipe entry ID: " + recipeEntryId);
//        }
//
//        // Check if Food exists
//        Food food = foodRepository.findById(foodEntryRequest.getFoodId())
//                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodEntryRequest.getFoodId()));
//
//        // Update Recipe entry
//        recipeEntry.setFood(food);
//        recipeEntry.setNumberOfServings(foodEntryRequest.getNumberOfServings());
//        recipeEntry.setServingUnit(ServingUnit.valueOf(foodEntryRequest.getServingUnit()));
//
//        // Save updated Recipe entry
//        recipeEntryRepository.save(recipeEntry);
//
//        // Return FoodEntryDto
//        return foodEntryMapper.convertToFoodEntryDto(recipeEntry);
//    }
}
