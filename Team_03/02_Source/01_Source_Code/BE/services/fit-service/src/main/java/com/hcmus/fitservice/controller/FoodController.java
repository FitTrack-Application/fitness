package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/foods")
public class FoodController {
    private final FoodService foodService;

    @Autowired
    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    // Get Food by id
    @GetMapping("/{foodId}")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable UUID foodId) {
        try {
            FoodDto food = foodService.getFoodById(foodId);

            ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                    .status(200)
                    .generalMessage("Successfully retrieved food")
                    .data(food)
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                    .status(400)
                    .generalMessage("Failed to get food")
                    .errorDetails(List.of(e.getMessage()))
                    .timestamp(LocalDateTime.now())
                    .build();

            return ResponseEntity.badRequest().body(response);
        }
    }

    // Get Foods with pagination (chưa có tìm kiếm gần đúng và không dấu)
    @GetMapping
    public ResponseEntity<ApiResponse<List<FoodDto>>> getFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page - 1, size);

        Page<FoodDto> foodPage;
        // If query is not provided or empty, return all foods
        if (query == null || query.isEmpty()) {
            foodPage = foodService.getAllFoods(pageable);
        } else {
            foodPage = foodService.searchFoodsByName(query, pageable);
        }

        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", foodPage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", foodPage.getTotalPages());
        pagination.put("totalItems", foodPage.getTotalElements());
        pagination.put("pageSize", foodPage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        ApiResponse<List<FoodDto>> response = ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved foods")
                .data(foodPage.getContent())
                .metadata(metadata)
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.ok(response);
    }
}
