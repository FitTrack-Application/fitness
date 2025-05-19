package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.RecipeRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.RecipeResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface RecipeService {
    ApiResponse<RecipeResponse> createRecipe(RecipeRequest recipeRequest, UUID userId);

    ApiResponse<List<RecipeResponse>> getRecipesByUserId(Pageable pageable, UUID userId);

    ApiResponse<List<RecipeResponse>> searchRecipesByUserIdAndName(String name, Pageable pageable, UUID userId);

    ApiResponse<RecipeResponse> getRecipeByIdAndUserId(UUID recipeId, UUID userId);

    ApiResponse<RecipeResponse> updateRecipeByIdAndUserId(UUID recipeId, RecipeRequest recipeRequest, UUID userId);

    ApiResponse<?> deleteRecipeByIdAndUserId(UUID recipeId, UUID userId);

}
