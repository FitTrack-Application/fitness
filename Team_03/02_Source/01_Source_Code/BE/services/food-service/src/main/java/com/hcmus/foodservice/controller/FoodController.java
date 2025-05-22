package com.hcmus.foodservice.controller;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.foodservice.service.FoodService;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import jakarta.validation.Valid;
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
@RequestMapping("/api/foods")
public class FoodController {

    private final FoodService foodService;

    /**
     * Retrieves a food detail by its id
     *
     * @param foodId the id of the food
     * @return a ResponseEntity containing an ApiResponse with a FoodDto object
     */
    @GetMapping("/{foodId}")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable UUID foodId) {
        ApiResponse<FoodDto> response = foodService.getFoodById(foodId);
        return ResponseEntity.ok(response);
    }

    /**
     * Retrieves the macros details of food by its id, serving unit id, and number of servings
     *
     * @param foodId the id of the food
     * @return a ResponseEntity containing an ApiResponse with a FoodMacrosDetailsResponse object
     */
    @GetMapping("/{foodId}/macros-details")
    public ResponseEntity<ApiResponse<FoodMacrosDetailsResponse>> getFoodMacrosDetails(
            @PathVariable UUID foodId,
            @RequestParam UUID servingUnitId,
            @RequestParam double numberOfServings
    ) {
        // Check if numberOfServings is valid
        if (numberOfServings <= 0) {
            throw new IllegalArgumentException("Number of servings must be greater than 0");
        }

        ApiResponse<FoodMacrosDetailsResponse> response = foodService.getFoodMacrosDetailsById(foodId, servingUnitId, numberOfServings);
        return ResponseEntity.ok(response);
    }

    /**
     * Retrieves a paginated list of foods. If a query is provided, it searches for
     * foods
     * by name. Otherwise, it returns all foods.
     *
     * @param query the search query for food names (optional)
     * @param page  the page number to retrieve (default is 1)
     * @param size  the number of items per page (default is 10)
     * @return a ResponseEntity containing an ApiResponse with a list of FoodDto
     * objects
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<FoodDto>>> getFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        // Check if page and size are valid
        if (page < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Size must be greater than 0");
        }

        Pageable pageable = PageRequest.of(page - 1, size);
        ApiResponse<List<FoodDto>> response;
        if (query == null || query.isEmpty()) {
            response = foodService.getSystemFoods(pageable);
        } else {
            response = foodService.searchSystemFoodsByName(query, pageable);
        }
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('USER')")
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<List<FoodDto>>> getMyFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        // Check if page and size are valid
        if (page < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Size must be greater than 0");
        }
        Pageable pageable = PageRequest.of(page - 1, size);
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();

        ApiResponse<List<FoodDto>> response;
        if (query == null || query.isEmpty()) {
            response = foodService.getFoodsByUserId(userId, pageable);
        } else {
            response = foodService.searchFoodsByUserIdAndName(userId, query, pageable);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/scan")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodFromBarcode(@RequestParam String barcode) {
        ApiResponse<FoodDto> response = foodService.scanFood(barcode);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<?>> addFood(@Valid @RequestBody FoodRequest foodRequest) {
        if (CustomSecurityContextHolder.hasRole("ADMIN")) {
            ApiResponse<?> response = foodService.createFood(foodRequest, null);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        }

        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<?> response = foodService.createFood(foodRequest, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @DeleteMapping("/{foodId}")
    public ResponseEntity<ApiResponse<?>> deleteFood(@PathVariable UUID foodId) {
        if (CustomSecurityContextHolder.hasRole("ADMIN")) {
            ApiResponse<?> response = foodService.deleteFoodByIdAndUserId(foodId, null);
            return ResponseEntity.ok(response);
        }

        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<?> response = foodService.deleteFoodByIdAndUserId(foodId, userId);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{foodId}")
    public ResponseEntity<ApiResponse<?>> updateFood(@PathVariable UUID foodId, @Valid @RequestBody FoodRequest foodRequest) {
        if (CustomSecurityContextHolder.hasRole("ADMIN")) {
            ApiResponse<?> response = foodService.updateFoodByIdAndUserId(foodId, foodRequest, null);
            return ResponseEntity.ok(response);
        }

        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<?> response = foodService.updateFoodByIdAndUserId(foodId, foodRequest, userId);
        return ResponseEntity.ok(response);
    }
}
