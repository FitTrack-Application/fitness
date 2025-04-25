package com.hcmus.fitservice.controller;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.service.FoodService;
import com.hcmus.fitservice.util.JwtUtil;


import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.boot.autoconfigure.security.oauth2.resource.OAuth2ResourceServerProperties.Jwt;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;



@RequiredArgsConstructor
@RestController
@RequestMapping("/api/foods")
public class FoodController {

    private final FoodService foodService;
    private final JwtUtil jwtUtil;

    // Get food by id
    @GetMapping("/{foodId}")
        public ResponseEntity<ApiResponse<FoodDto>> getFoodById(@PathVariable UUID foodId) {
        ApiResponse<FoodDto> response = foodService.getFoodById(foodId);
        return ResponseEntity.ok(response);
    }

    // Get foods with pagination (The search is not perfectly with UTF-8)
    @GetMapping
    public ResponseEntity<ApiResponse<List<FoodDto>>> getFoods(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        // Check if page and size are valid
        if (page < 1) {
            throw new IllegalArgumentException("Page number must be greater than 0");
        }
        if (size < 1) {
            throw new IllegalArgumentException("Size must be greater than 0");
        }

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


    @GetMapping("/scan")
    public ResponseEntity<ApiResponse<FoodDto>> getMethodName(@RequestParam String barcode) {
        ApiResponse<FoodDto> response = foodService.scanFood(barcode);
        
        return ResponseEntity.ok(response); 
    }

    @PutMapping("/add")
    public ResponseEntity<ApiResponse<?>> addFood(@Valid @RequestBody FoodDto foodDto, @RequestHeader("Authorization") String authorizationHeader) {
        
        UUID userId = jwtUtil.extractUserId(authorizationHeader.replace("Bearer ", ""));
        ApiResponse<?> response = foodService.addFood(foodDto, userId);
        return ResponseEntity.ok(response);
    }

}
