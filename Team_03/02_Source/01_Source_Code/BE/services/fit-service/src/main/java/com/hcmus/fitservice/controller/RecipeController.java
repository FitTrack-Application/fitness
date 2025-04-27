package com.hcmus.fitservice.controller;


import com.hcmus.fitservice.dto.request.RecipeRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.RecipeResponse;
import com.hcmus.fitservice.service.RecipeService;
import com.hcmus.fitservice.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/recipes")
public class RecipeController {
    private final RecipeService recipeService;

    private final JwtUtil jwtUtil;

    // Create Recipe
    @PostMapping
    public ResponseEntity<ApiResponse<RecipeResponse>> createRecipe(
            @RequestBody RecipeRequest recipeRequest
    ) {
        // Extract User ID from JWT token
        UUID userId = jwtUtil.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.createRecipe(recipeRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // Get recipes with pagination
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<RecipeResponse>>> getAllRecipes (
            @RequestParam(required = false) String query,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size
    ) {
        // Check if page and size are valid
        if (page < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Size must be greater than 0");
        }

        // Extract User ID from JWT token
        UUID userId = jwtUtil.getCurrentUserId();

        Pageable pageable = PageRequest.of(page - 1, size);

        ApiResponse<List<RecipeResponse>> response;

        // If query is not provided or empty, return all user's recipes
        if(query == null || query.isEmpty()) {
            response = recipeService.getAllRecipes(pageable, userId);
        } else {
            // If query is provided, search recipes by name
            response = recipeService.searchRecipesByName(query, pageable, userId);
        }

        return ResponseEntity.ok(response);
    }


    // Get recipe by ID
    @GetMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<RecipeResponse>> getRecipeById(
            @PathVariable UUID recipeId
    ) {
        // Extract User ID from JWT token
        UUID userId = jwtUtil.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.getRecipeById(recipeId, userId);
        return ResponseEntity.ok(response);
    }

    // Update recipe by ID
    @PutMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<RecipeResponse>> updateRecipeById(
            @PathVariable UUID recipeId,
            @RequestBody RecipeRequest recipeRequest
    ) {
        // Extract User ID from JWT token
        UUID userId = jwtUtil.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.updateRecipeById(recipeId, recipeRequest, userId);
        return ResponseEntity.ok(response);
    }

    // Delete recipe by ID
    @DeleteMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<?>> deleteRecipeById(
            @PathVariable UUID recipeId
    ) {
        // Extract User ID from JWT token
        UUID userId = jwtUtil.getCurrentUserId();

        ApiResponse<?> response = recipeService.deleteRecipeById(recipeId, userId);
        return ResponseEntity.ok(response);
    }
}
