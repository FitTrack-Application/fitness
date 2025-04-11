package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealEntryRequestDto;
import com.hcmus.fitservice.service.MealEntryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("api/meal-entries")
public class MealEntryController {
    private final MealEntryService mealEntryService;

    @Autowired
    public MealEntryController(MealEntryService mealEntryService) {
        this.mealEntryService = mealEntryService;
    }

    // Delete Meal Entry
    @DeleteMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<Void>> deleteMealEntry(@PathVariable UUID mealEntryId) {
        try {
            mealEntryService.deleteMealEntry(mealEntryId);

            ApiResponse<Void> response = ApiResponse.<Void>builder()
                    .status(200)
                    .generalMessage("Successfully deleted meal entry")
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            ApiResponse<Void> response = ApiResponse.<Void>builder()
                    .status(404)
                    .generalMessage("Failed to delete meal entry")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }

    // Update Meal Entry
    @PutMapping("/{mealEntryId}")
    public ResponseEntity<ApiResponse<MealEntryDto>> updateMealEntry(
            @PathVariable UUID mealEntryId,
            @RequestBody MealEntryRequestDto mealEntryRequestDto
    ) {
        try {
            MealEntryDto updatedMealEntry = mealEntryService.updateMealEntry(
                    mealEntryId,
                    mealEntryRequestDto.getFoodId(),
                    mealEntryRequestDto.getServingUnit(),
                    mealEntryRequestDto.getNumberOfServings()
            );

            ApiResponse<MealEntryDto> response = ApiResponse.<MealEntryDto>builder()
                    .status(200)
                    .generalMessage("Successfully updated meal entry")
                    .data(updatedMealEntry)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            ApiResponse<MealEntryDto> response = ApiResponse.<MealEntryDto>builder()
                    .status(400)
                    .generalMessage("Failed to update meal entry")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.badRequest().body(response);
        }
    }
}
