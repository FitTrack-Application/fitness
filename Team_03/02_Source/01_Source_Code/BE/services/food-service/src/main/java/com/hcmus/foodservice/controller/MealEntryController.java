package com.hcmus.foodservice.controller;

import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.service.MealEntryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/meal-entries")
public class MealEntryController {

    private final MealEntryService mealEntryService;

    /**
     * Delete a meal entry by its id
     *
     * @param mealEntryId the id of the meal entry
     * @return a ResponseEntity containing an ApiResponse with info message
     */
    @DeleteMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<Void>> deleteMealEntry(@PathVariable UUID mealEntryId) {
        ApiResponse<Void> response = mealEntryService.deleteMealEntry(mealEntryId);
        return ResponseEntity.ok(response);
    }

    /**
     * Update a meal entry by its id
     *
     * @param mealEntryId      the id of the meal entry
     * @param foodEntryRequest the request body containing the updated meal entry details
     * @return a ResponseEntity containing an ApiResponse with the updated MealEntryDto object
     */
    @PutMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<FoodEntryResponse>> updateMealEntry(
            @PathVariable UUID mealEntryId,
            @RequestBody FoodEntryRequest foodEntryRequest
    ) {
        ApiResponse<FoodEntryResponse> response = mealEntryService.updateMealEntry(
                mealEntryId,
                foodEntryRequest
        );
        return ResponseEntity.ok(response);
    }
}
