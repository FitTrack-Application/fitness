package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.service.FoodService;
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

    // Get Food by id
    @GetMapping("/{foodId}")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable UUID foodId) {

        ApiResponse<FoodDto> response = foodService.getFoodById(foodId);

        return ResponseEntity.ok(response);
    }

    // Get Foods with pagination (chưa có tìm kiếm gần đúng và không dấu)
    @GetMapping
    public ResponseEntity<ApiResponse<List<FoodDto>>> getFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page - 1, size);

        ApiResponse<List<FoodDto>> response;
        // If query is not provided or empty, return all foods
        if (query == null || query.isEmpty()) {
            response = foodService.getAllFoods(pageable);
        } else {
            response = foodService.searchFoodsByName(query, pageable);
        }

        return ResponseEntity.ok(response);
    }
}
