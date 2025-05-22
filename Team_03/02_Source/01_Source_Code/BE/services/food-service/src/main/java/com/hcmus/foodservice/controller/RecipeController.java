package com.hcmus.foodservice.controller;


import com.hcmus.foodservice.dto.request.RecipeRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.RecipeResponse;
import com.hcmus.foodservice.service.RecipeService;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/recipes")
public class RecipeController {

    private final RecipeService recipeService;

    @PreAuthorize("hasRole('USER')")
    @PostMapping
    public ResponseEntity<ApiResponse<RecipeResponse>> createRecipe(
            @RequestBody RecipeRequest recipeRequest
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.createRecipe(recipeRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PreAuthorize("hasRole('USER')")
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<RecipeResponse>>> getMyRecipes(
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
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        Pageable pageable = PageRequest.of(page - 1, size);

        ApiResponse<List<RecipeResponse>> response;
        if (query == null || query.isEmpty()) {
            response = recipeService.getRecipesByUserId(pageable, userId);
        } else {
            response = recipeService.searchRecipesByUserIdAndName(query, pageable, userId);
        }

        return ResponseEntity.ok(response);
    }


    @PreAuthorize("hasRole('USER')")
    @GetMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<RecipeResponse>> getRecipeById(
            @PathVariable UUID recipeId
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.getRecipeByIdAndUserId(recipeId, userId);
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('USER')")
    @PutMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<RecipeResponse>> updateRecipeById(
            @PathVariable UUID recipeId,
            @RequestBody RecipeRequest recipeRequest
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<RecipeResponse> response = recipeService.updateRecipeByIdAndUserId(recipeId, recipeRequest, userId);
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('USER')")
    @DeleteMapping("/{recipeId}")
    public ResponseEntity<ApiResponse<?>> deleteRecipeById(
            @PathVariable UUID recipeId
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<?> response = recipeService.deleteRecipeByIdAndUserId(recipeId, userId);
        return ResponseEntity.ok(response);
    }
}
