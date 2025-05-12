package com.hcmus.foodservice.controller;

import com.hcmus.foodservice.dto.request.DailyMealLogRequest;
import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.MealLogResponse;
import com.hcmus.foodservice.service.MealLogService;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/meal-logs")
public class MealLogController {

    private final MealLogService mealLogService;

    /**
     * Create a meal log for the current user
     *
     * @param dailyMealLogRequest the request body containing the meal log details
     * @return a ResponseEntity containing an ApiResponse with the created MealLogDto object
     */
    @PostMapping("/daily")
    public ResponseEntity<ApiResponse<?>> createDailyMealLogs(@RequestBody DailyMealLogRequest dailyMealLogRequest) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<?>
                response = mealLogService.createDailyMealLogs(
                userId,
                dailyMealLogRequest.getDate());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Add a meal entry to a meal log
     *
     * @param mealLogId        the id of the meal log
     * @param foodEntryRequest the request body containing the meal entry details
     * @return a ResponseEntity containing an ApiResponse with the created MealEntryDto object
     */
    @PostMapping("/{mealLogId}/entries")
    public ResponseEntity<ApiResponse<FoodEntryResponse>> addMealEntry(
            @PathVariable UUID mealLogId,
            @RequestBody FoodEntryRequest foodEntryRequest
    ) {
        ApiResponse<FoodEntryResponse> response = mealLogService.addMealEntry(
                mealLogId,
                foodEntryRequest
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Get all meal logs for the current user on a specific date
     *
     * @param date the date to filter meal logs
     * @return a ResponseEntity containing an ApiResponse with a list of MealLogDto objects
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<MealLogResponse>>> getMealLogsByUserIdAndDate(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {
        UUID userId = CustomSecurityContextHolder.getCurrentUserId();
        ApiResponse<List<MealLogResponse>> response = mealLogService.getMealLogsByUserIdAndDate(userId, date);
        return ResponseEntity.ok(response);
    }
}
