package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.request.FoodRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.fitservice.service.FoodService;
import com.hcmus.fitservice.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/foods")
public class FoodController {

    private final FoodService foodService;
    private final JwtUtil jwtUtil;

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
     * Retrieves the macros details of food by its id, serving unit id, and number
     * of servings
     *
     * @param foodId the id of the food
     * @return a ResponseEntity containing an ApiResponse with a
     *         FoodMacrosDetailsResponse object
     */
    @GetMapping("/{foodId}/macros-details")
    public ResponseEntity<ApiResponse<FoodMacrosDetailsResponse>> getFoodMacrosDetails(
            @PathVariable UUID foodId,
            @RequestBody FoodMacrosDetailsRequest foodMacrosDetailsRequest
    ) {
        ApiResponse<FoodMacrosDetailsResponse> response = foodService.getFoodMacrosDetailsById(foodId, foodMacrosDetailsRequest);
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
     *         objects
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
            response = foodService.getAllFoods(pageable);
        } else {
            response = foodService.searchFoodsByName(query, pageable);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/scan")
    public ResponseEntity<ApiResponse<FoodDto>> getMethodName(@RequestParam String barcode) {
        ApiResponse<FoodDto> response = foodService.scanFood(barcode);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<?>> addFood(@Valid @RequestBody FoodRequest foodRequest) {
        UUID userId = jwtUtil.getCurrentUserId();
        ApiResponse<?> response = foodService.createFood(foodRequest, userId);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{foodId}")
    public ResponseEntity<ApiResponse<?>> deleteFood(@PathVariable UUID foodId) {
        UUID userId = jwtUtil.getCurrentUserId();
        ApiResponse<?> response = foodService.deleteFood(foodId, userId);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{foodId}")
    public ResponseEntity<ApiResponse<?>> updateFood(@PathVariable UUID foodId, @Valid @RequestBody FoodRequest foodRequest) {
        UUID userId = jwtUtil.getCurrentUserId();
        ApiResponse<?> response = foodService.updateFood(foodId, foodRequest, userId);
        return ResponseEntity.ok(response);
    }
}
