package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.*;
import com.hcmus.fitservice.service.MealLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/meal-logs")
public class MealLogController {
    private final MealLogService mealLogService;

    @Autowired
    public MealLogController(MealLogService mealLogService) {
        this.mealLogService = mealLogService;
    }

    // Create Meal Log (User Id sẽ sửa thành lấy từ JWT)
    @PostMapping
    public ResponseEntity<ApiResponse<Void>> createMealLog(@RequestBody MealLogRequestDto mealLogRequestDto) {
        try {
            mealLogService.createMealLog(mealLogRequestDto.getUserId(), mealLogRequestDto.getDate(), mealLogRequestDto.getMealType());

            ApiResponse<Void> response = ApiResponse.<Void>builder()
                    .status(201)
                    .generalMessage("Successfully created meal log")
                    .timestamp(LocalDateTime.now())
                    .build();
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            ApiResponse<Void> response = ApiResponse.<Void>builder()
                    .status(400)
                    .generalMessage("Failed to create meal log")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Add Meal Entry (sẽ thêm User Id lấy từ JWT)
    @PostMapping("/{mealLogId}/entries")
    public ResponseEntity<ApiResponse<MealEntryDto>> addMealEntry(
            @PathVariable UUID mealLogId,
            @RequestBody MealEntryRequestDto mealEntryRequestDto
            ) {
        try {
            MealEntryDto mealEntryDto = mealLogService.addMealEntry(
                    mealLogId,
                    mealEntryRequestDto.getFoodId(),
                    mealEntryRequestDto.getServingUnit(),
                    mealEntryRequestDto.getNumberOfServings()
            );

            ApiResponse<MealEntryDto> response = ApiResponse.<MealEntryDto>builder()
                    .status(201)
                    .generalMessage("Successfully added meal entry")
                    .data(mealEntryDto)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (IllegalArgumentException e) {
            ApiResponse<MealEntryDto> response = ApiResponse.<MealEntryDto>builder()
                    .status(400)
                    .generalMessage("Failed to add meal entry")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.badRequest().body(response);
        }
    }

    // Get Meal Log by User Id and Date (User Id sẽ sửa thành lấy từ JWT)
    @GetMapping
    public ResponseEntity<ApiResponse<MealLogDto>> getMealLogByUserIdAndDate(
            @RequestParam UUID userId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {
        try {
            MealLogDto mealLogDto = mealLogService.getMealLogByUserIdAndDate(userId, date);

            ApiResponse<MealLogDto> response = ApiResponse.<MealLogDto>builder()
                    .status(200)
                    .generalMessage("Successfully retrieved meal log")
                    .data(mealLogDto)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            ApiResponse<MealLogDto> response = ApiResponse.<MealLogDto>builder()
                    .status(404)
                    .generalMessage("Failed to get meal log")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }
    }
}
