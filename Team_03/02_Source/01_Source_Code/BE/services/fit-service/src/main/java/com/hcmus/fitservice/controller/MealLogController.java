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

    // Create meal log
    @PostMapping
    public ResponseEntity<ApiResponse<Void>> createMealLog(
            @RequestHeader("Authorization") String authorization,
            @RequestBody MealLogRequest mealLogRequest
    ) {
        UUID userId = jwtUtil.extractUserId(authorization.replace("Bearer ", ""));
        ApiResponse<Void> response = mealLogService.createMealLog(
                userId,
                mealLogRequest.getDate(),
                mealLogRequest.getMealType());
        return ResponseEntity.ok(response);
    }

    // Add meal entry
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

    // Get meal log by user id and date
    @GetMapping
    public ResponseEntity<ApiResponse<List<MealLogDto>>> getMealLogsByUserIdAndDate(
            @RequestHeader("Authorization") String authorization,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date
    ) {
        UUID userId = jwtUtil.extractUserId(authorization.replace("Bearer ", ""));
        ApiResponse<List<MealLogDto>> response = mealLogService.getMealLogsByUserIdAndDate(userId, date);
        return ResponseEntity.ok(response);
    }
}
