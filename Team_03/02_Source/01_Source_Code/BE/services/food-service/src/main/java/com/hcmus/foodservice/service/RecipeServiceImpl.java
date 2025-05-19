package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.RecipeRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.RecipeResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.mapper.RecipeMapper;
import com.hcmus.foodservice.model.Recipe;
import com.hcmus.foodservice.repository.RecipeEntryRepository;
import com.hcmus.foodservice.repository.RecipeRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RecipeServiceImpl implements RecipeService {
    private final RecipeRepository recipeRepository;

    private final RecipeEntryRepository recipeEntryRepository;

    private final RecipeEntryService recipeEntryService;

    private final RecipeMapper recipeMapper;

    // Create Recipe
    @Override
    public ApiResponse<RecipeResponse> createRecipe(RecipeRequest recipeRequest, UUID userId) {
        Recipe recipe = new Recipe();
        recipe.setRecipeName(recipeRequest.getName());
        recipe.setDirection(recipeRequest.getDirection());
        recipe.setUserId(userId);

        // Save and get the recipe
        Recipe savedRecipe = recipeRepository.save(recipe);
        UUID savedRecipeId = savedRecipe.getRecipeId();

        // Create Recipe entries
        List<FoodEntryResponse> foodEntryResponses = recipeRequest.getRecipeEntries().stream()
                .map(foodEntryRequest -> recipeEntryService.createRecipeEntry(savedRecipeId, foodEntryRequest))
                .toList();

        // Create RecipeResponse
        RecipeResponse recipeResponse = new RecipeResponse(
                savedRecipeId,
                savedRecipe.getRecipeName(),
                savedRecipe.getDirection(),
                foodEntryResponses
        );

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(201)
                .generalMessage("Recipe created successfully")
                .data(recipeResponse)
                .build();
    }

    // Get all Recipes
    @Override
    public ApiResponse<List<RecipeResponse>> getRecipesByUserId(Pageable pageable, UUID userId) {
        Page<Recipe> recipePage = recipeRepository.findAllByUserId(userId, pageable);

        return buildRecipeListResponse(recipePage);
    }

    // Search Recipes by name
    @Override
    public ApiResponse<List<RecipeResponse>> searchRecipesByUserIdAndName(String query, Pageable pageable, UUID userId) {
        Page<Recipe> recipePage = recipeRepository.findByUserIdAndRecipeNameContainingIgnoreCase(userId, query, pageable);

        return buildRecipeListResponse(recipePage);
    }

    // Helper method to build ApiResponse for recipe list
    private ApiResponse<List<RecipeResponse>> buildRecipeListResponse(Page<Recipe> recipePage) {
        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", recipePage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", recipePage.getTotalPages());
        pagination.put("totalItems", recipePage.getTotalElements());
        pagination.put("pageSize", recipePage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        // Convert to Dto
        Page<RecipeResponse> recipePageDto = recipePage.map(recipeMapper::convertToRecipeResponse);

        // Create response
        return ApiResponse.<List<RecipeResponse>>builder()
                .status(200)
                .generalMessage("Successfully retrieved recipes")
                .data(recipePageDto.getContent())
                .metadata(metadata)
                .build();
    }

    // Get Recipe by ID
    @Override
    public ApiResponse<RecipeResponse> getRecipeByIdAndUserId(UUID recipeId, UUID userId) {
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Convert to Dto
        RecipeResponse recipeResponse = recipeMapper.convertToRecipeResponse(recipe);

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved recipe")
                .data(recipeResponse)
                .build();
    }

    // Update Recipe by ID
    @Override
    @Transactional
    public ApiResponse<RecipeResponse> updateRecipeByIdAndUserId(UUID recipeId, RecipeRequest recipeRequest, UUID userId) {
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Update Recipe info
        recipe.setRecipeName(recipeRequest.getName());
        recipe.setDirection(recipeRequest.getDirection());

        // Update Recipe entries
        // Delete old entries
        recipeEntryRepository.deleteAllByRecipe(recipe);

        // Create new entries
        List<FoodEntryResponse> foodEntryResponses = recipeRequest.getRecipeEntries().stream()
                .map(foodEntryRequest -> recipeEntryService.createRecipeEntry(recipe.getRecipeId(), foodEntryRequest))
                .toList();

        // Save updated Recipe
        recipeRepository.save(recipe);

        // Create RecipeResponse
        RecipeResponse recipeResponse = new RecipeResponse(
                recipe.getRecipeId(),
                recipe.getRecipeName(),
                recipe.getDirection(),
                foodEntryResponses
        );

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(200)
                .generalMessage("Successfully updated recipe")
                .data(recipeResponse)
                .build();
    }

    // Delete Recipe by ID
    @Transactional
    @Override
    public ApiResponse<?> deleteRecipeByIdAndUserId(UUID recipeId, UUID userId) {
        // Check Recipe exists
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Delete Recipe
        recipeRepository.delete(recipe);

        // Return response
        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted recipe")
                .build();
    }
}
