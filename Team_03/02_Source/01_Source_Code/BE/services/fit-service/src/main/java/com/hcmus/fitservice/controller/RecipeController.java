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
@RequestMapping("/recipes")
public class RecipeController {
    private final RecipeService recipeService;

    private final JwtUtil jwtUtil;

    // Create Recipe
    @PostMapping
    public ResponseEntity<ApiResponse<RecipeResponse>> createRecipe(
            @RequestHeader("Authorization") String authorization,
            @RequestBody RecipeRequest recipeRequest
    ) {
        // Extract User ID from JWT token
        String token = authorization.replace("Bearer ", "");
        UUID userId = jwtUtil.extractUserId(token);

        ApiResponse<RecipeResponse> response = recipeService.createRecipe(recipeRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // Get recipes with pagination
    @GetMapping
    public ResponseEntity<ApiResponse<List<RecipeResponse>>> getAllRecipes (
            @RequestHeader("Authorization") String authorization,
            @RequestParam(required = false) String query,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size
    ) {
        // Extract User ID from JWT token
        String token = authorization.replace("Bearer ", "");
        UUID userId = jwtUtil.extractUserId(token);

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
            @RequestHeader("Authorization") String authorization,
            @PathVariable UUID recipeId
    ) {
        // Extract User ID from JWT token
        String token = authorization.replace("Bearer ", "");
        UUID userId = jwtUtil.extractUserId(token);

        ApiResponse<RecipeResponse> response = recipeService.getRecipeById(recipeId, userId);
        return ResponseEntity.ok(response);
    }

}
