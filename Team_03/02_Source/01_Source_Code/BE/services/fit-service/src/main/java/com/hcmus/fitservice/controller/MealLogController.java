package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealLogDto;
import com.hcmus.fitservice.dto.request.MealEntryRequest;
import com.hcmus.fitservice.dto.request.MealLogRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.service.MealLogService;
import com.hcmus.fitservice.util.JwtUtil;
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
    private final JwtUtil jwtUtil;

    /**
     * Create a meal log for the current user
     *
     * @param mealLogRequest the request body containing the meal log details
     * @return a ResponseEntity containing an ApiResponse with the created MealLogDto object
     */
    @PostMapping
    public ResponseEntity<ApiResponse<Void>> createMealLog(@RequestBody MealLogRequest mealLogRequest) {
        UUID userId = jwtUtil.getCurrentUserId();
        ApiResponse<Void> response = mealLogService.createMealLog(
                userId,
                mealLogRequest.getDate(),
                mealLogRequest.getMealType());
        return ResponseEntity.ok(response);
    }

    /**
     * Add a meal entry to a meal log
     *
     * @param mealLogId        the id of the meal log
     * @param mealEntryRequest the request body containing the meal entry details
     * @return a ResponseEntity containing an ApiResponse with the created MealEntryDto object
     */
    @PostMapping("/{mealLogId}/entries")
    public ResponseEntity<ApiResponse<MealEntryDto>> addMealEntry(@PathVariable UUID mealLogId, @RequestBody MealEntryRequest mealEntryRequest) {
        ApiResponse<MealEntryDto> response = mealLogService.addMealEntry(
                mealLogId,
                mealEntryRequest.getFoodId(),
                mealEntryRequest.getServingUnit(),
                mealEntryRequest.getNumberOfServings()
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
    public ResponseEntity<ApiResponse<List<MealLogDto>>> getMealLogsByUserIdAndDate(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {
        UUID userId = jwtUtil.getCurrentUserId();
        ApiResponse<List<MealLogDto>> response = mealLogService.getMealLogsByUserIdAndDate(userId, date);
        return ResponseEntity.ok(response);
    }
}
