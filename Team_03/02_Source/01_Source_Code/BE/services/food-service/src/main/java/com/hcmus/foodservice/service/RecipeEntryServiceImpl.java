package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.mapper.FoodEntryMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.Recipe;
import com.hcmus.foodservice.model.RecipeEntry;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.RecipeEntryRepository;
import com.hcmus.foodservice.repository.RecipeRepository;
import com.hcmus.foodservice.repository.ServingUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RecipeEntryServiceImpl implements RecipeEntryService {
    private final RecipeEntryRepository recipeEntryRepository;

    private final RecipeRepository recipeRepository;

    private final FoodRepository foodRepository;

    private final ServingUnitRepository servingUnitRepository;

    private final FoodEntryMapper foodEntryMapper;

    // Create Recipe entry
    @Override
    public FoodEntryResponse createRecipeEntry(UUID recipeId, FoodEntryRequest foodEntryRequest) {
        // Check if Recipe exists
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId));

        // Check if Food exists
        Food food = foodRepository.findById(foodEntryRequest.getFoodId())
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodEntryRequest.getFoodId()));

        // Check if Serving Unit is valid
        ServingUnit servingUnit = servingUnitRepository.findById(foodEntryRequest.getServingUnitId())
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found with ID: " + foodEntryRequest.getServingUnitId()));

        // Create Recipe entry
        RecipeEntry recipeEntry = new RecipeEntry();
        recipeEntry.setRecipe(recipe);
        recipeEntry.setFood(food);
        recipeEntry.setNumberOfServings(foodEntryRequest.getNumberOfServings());
        recipeEntry.setServingUnit(servingUnit);

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
