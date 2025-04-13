package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.*;
import com.hcmus.fitservice.dto.request.MealEntryRequest;
import com.hcmus.fitservice.dto.request.MealLogRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.service.MealLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/meal-logs")
public class MealLogController {
    private final MealLogService mealLogService;

    // Create Meal Log (User Id sẽ sửa thành lấy từ JWT)
    @PostMapping
    public ResponseEntity<ApiResponse<Void>> createMealLog(@RequestHeader("Authorization") String authorization, @RequestBody MealLogRequest mealLogRequest) {

        ApiResponse<Void> response = mealLogService.createMealLog();

        return ResponseEntity.badRequest().body(response);

    }

    // Add Meal Entry (sẽ thêm User Id lấy từ JWT)
    @PostMapping("/{mealLogId}/entries")
    public ResponseEntity<ApiResponse<MealEntryDto>> addMealEntry(
            @PathVariable UUID mealLogId,
            @RequestBody MealEntryRequest mealEntryRequest
    ) {

        ApiResponse<MealEntryDto> response = mealLogService.addMealEntry(
                mealLogId,
                mealEntryRequest.getFoodId(),
                mealEntryRequest.getServingUnit(),
                mealEntryRequest.getNumberOfServings()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }


    // Get Meal Log by User Id and Date (User Id sẽ sửa thành lấy từ JWT)
    @GetMapping
    public ResponseEntity<ApiResponse<List<MealLogDto>>> getMealLogsByUserIdAndDate(
            @RequestParam UUID userId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {

        ApiResponse<List<MealLogDto>> response = mealLogService.getMealLogsByUserIdAndDate(userId, date);

        return ResponseEntity.ok(response);
    }
}
