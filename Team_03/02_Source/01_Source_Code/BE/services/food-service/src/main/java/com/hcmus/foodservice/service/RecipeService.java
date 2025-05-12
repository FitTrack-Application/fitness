package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.RecipeRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.RecipeResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface RecipeService {
    ApiResponse<RecipeResponse> createRecipe(RecipeRequest recipeRequest, UUID userId);

    ApiResponse<List<RecipeResponse>> getAllRecipes(Pageable pageable, UUID userId);

    ApiResponse<List<RecipeResponse>> searchRecipesByName(String name, Pageable pageable, UUID userId);

    ApiResponse<RecipeResponse> getRecipeById (UUID recipeId, UUID userId);

    ApiResponse<RecipeResponse> updateRecipeById(UUID recipeId, RecipeRequest recipeRequest, UUID userId);

    ApiResponse<?> deleteRecipeById(UUID recipeId, UUID userId);

}
