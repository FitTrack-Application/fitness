package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodEntryDto;
import com.hcmus.fitservice.dto.request.RecipeRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.RecipeResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.mapper.RecipeMapper;
import com.hcmus.fitservice.model.Recipe;
import com.hcmus.fitservice.repository.RecipeEntryRepository;
import com.hcmus.fitservice.repository.RecipeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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

        // Create Recipe entries
        List<FoodEntryDto> foodEntryDtos = recipeRequest.getRecipeEntries().stream()
                .map(foodEntryRequest -> recipeEntryService.createRecipeEntry(savedRecipe.getRecipeId(), foodEntryRequest))
                .toList();

        // Convert to RecipeResponse
        RecipeResponse recipeResponse = recipeMapper.convertToRecipeResponse(recipe);

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(201)
                .generalMessage("Recipe created successfully")
                .data(recipeResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    // Get all Recipes
    @Override
    public ApiResponse<List<RecipeResponse>> getAllRecipes(Pageable pageable, UUID userId) {
        Page<Recipe> recipePage = recipeRepository.findAllByUserId(userId, pageable);

        return buildRecipeListResponse(recipePage);
    }

    // Search Recipes by name
    @Override
    public ApiResponse<List<RecipeResponse>> searchRecipesByName(String query, Pageable pageable, UUID userId) {
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
                .timestamp(LocalDateTime.now())
                .build();
    }

    // Get Recipe by ID
    @Override
    public ApiResponse<RecipeResponse> getRecipeById(UUID recipeId, UUID userId) {
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Convert to Dto
        RecipeResponse recipeResponse = recipeMapper.convertToRecipeResponse(recipe);

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved recipe")
                .data(recipeResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    // Update Recipe by ID
    @Override
    public ApiResponse<RecipeResponse> updateRecipeById(UUID recipeId, RecipeRequest recipeRequest, UUID userId) {
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Update Recipe info
        recipe.setRecipeName(recipeRequest.getName());
        recipe.setDirection(recipeRequest.getDirection());

        // Update Recipe entries
        // Delete old entries
        recipeEntryRepository.deleteAllByRecipe(recipe);

        // Create new entries
        List<FoodEntryDto> foodEntryDtos = recipeRequest.getRecipeEntries().stream()
                .map(foodEntryRequest -> recipeEntryService.createRecipeEntry(recipe.getRecipeId(), foodEntryRequest))
                .toList();

        // Save updated Recipe
        recipeRepository.save(recipe);

        // Convert to RecipeResponse
        RecipeResponse recipeResponse = recipeMapper.convertToRecipeResponse(recipe);

        // Return response
        return ApiResponse.<RecipeResponse>builder()
                .status(200)
                .generalMessage("Successfully updated recipe")
                .data(recipeResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    // Delete Recipe by ID
    @Override
    public ApiResponse<?> deleteRecipeById(UUID recipeId, UUID userId) {
        // Check Recipe exists
        Recipe recipe = recipeRepository.findByRecipeIdAndUserId(recipeId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + recipeId + "and user ID: " + userId));

        // Delete Recipe
        recipeRepository.delete(recipe);

        // Return response
        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted recipe")
                .timestamp(LocalDateTime.now())
                .build();
    }
}
