package com.hcmus.statisticserivce.controller;

import com.hcmus.statisticserivce.service.FoodLogService;
import com.hcmus.statisticserivce.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/food-logs")
@RequiredArgsConstructor
public class FoodLogController {

    private final FoodLogService foodLogService;

    private final JwtUtil jwtUtil;

    @GetMapping
    public ResponseEntity<List<FoodLogDto>> getAllFoodLogs() {
        return ResponseEntity.ok(foodLogService.getAllFoodLogs());
    }

    @GetMapping("/{id}")
    public ResponseEntity<FoodLogDto> getFoodLogById(@PathVariable UUID id) {
        return ResponseEntity.ok(foodLogService.getFoodLogById(id));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<FoodLogDto>> getFoodLogsByUserId(@RequestHeader("authorization") String authorization) {
        UUID userId = extractUserId(authorization);
        return ResponseEntity.ok(foodLogService.getFoodLogsByUserId(userId));
    }

    @GetMapping("/user/{userId}/date/{date}")
    public ResponseEntity<List<FoodLogDto>> getFoodLogsByUserIdAndDate(
            @PathVariable UUID userId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(foodLogService.getFoodLogsByUserIdAndDate(userId, date));
    }

    @GetMapping("/user/{userId}/range")
    public ResponseEntity<List<FoodLogDto>> getFoodLogsByUserIdAndDateRange(
            @PathVariable UUID userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(foodLogService.getFoodLogsByUserIdAndDateRange(userId, startDate, endDate));
    }

    @PostMapping
    public ResponseEntity<FoodLogDto> createFoodLog(@Valid @RequestBody FoodLogDto foodLogDto) {
        return new ResponseEntity<>(foodLogService.createFoodLog(foodLogDto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FoodLogDto> updateFoodLog(@PathVariable UUID id, @Valid @RequestBody FoodLogDto foodLogDto) {
        return ResponseEntity.ok(foodLogService.updateFoodLog(id, foodLogDto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFoodLog(@PathVariable UUID id) {
        foodLogService.deleteFoodLog(id);
        return ResponseEntity.noContent().build();
    }
}