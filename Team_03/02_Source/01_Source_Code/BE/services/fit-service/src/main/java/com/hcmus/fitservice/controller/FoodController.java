package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.ApiResponse;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    // Get all foods
    @GetMapping
    public ApiResponse<List<FoodDto>> getAllFoods() {
        List<FoodDto> foods = foodService.getAllFoods();

        return ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Sucessfully retrieved all foods")
                .data(foods)
                .build();
    }

    // Get food by id
    @GetMapping("/{foodId}")
    public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable String foodId) {
        FoodDto food = foodService.getFoodById(UUID.fromString(foodId));

        if (food == null) {
            ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                    .status(404)
                    .generalMessage("Food not found with ID: " + foodId)
                    .build();
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Successfully retrieved food with ID: " + foodId)
                .data(food)
                .build();
        return ResponseEntity.ok(response);
    }

    // Search food by name (chưa có tìm kiếm không dấu và gần đúng)
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<FoodDto>>> searchFoodsByName(
            @RequestParam String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page - 1, size);
        Page<FoodDto> foodPage = foodService.searchFoodsByName(query, pageable);

        if (foodPage.isEmpty()) {
            ApiResponse<List<FoodDto>> response =  ApiResponse.<List<FoodDto>>builder()
                    .status(404)
                    .generalMessage("No foods found with name: " + query)
                    .build();
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
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
                .generalMessage("Successfully retrieved foods with name: " + query)
                .data(foodPage.getContent())
                .metadata(metadata)
                .build();
        return ResponseEntity.ok(response);
    }
}
