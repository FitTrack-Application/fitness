package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.request.MealEntryRequest;
import com.hcmus.fitservice.service.MealEntryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("api/meal-entries")
public class MealEntryController {
    private final MealEntryService mealEntryService;

    // Delete Meal Entry
    @DeleteMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<Void>> deleteMealEntry(@PathVariable UUID mealEntryId) {

        ApiResponse<Void> response = mealEntryService.deleteMealEntry(mealEntryId);

        return ResponseEntity.ok(response);
    }

    // Update Meal Entry
    @PutMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<MealEntryDto>> updateMealEntry(
            @PathVariable UUID mealEntryId,
            @RequestBody MealEntryRequest mealEntryRequest
    ) {

        ApiResponse<MealEntryDto> response = mealEntryService.updateMealEntry(
                mealEntryId,
                mealEntryRequest.getFoodId(),
                mealEntryRequest.getServingUnit(),
                mealEntryRequest.getNumberOfServings()
        );

        return ResponseEntity.ok(response);
    }
}
