package com.hcmus.fitservice.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.hcmus.fitservice.client.OpenFoodFactClient;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.mapper.FoodMapper;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.repository.FoodRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FoodServiceImpl implements FoodService {

    private final FoodRepository foodRepository;

    private final FoodMapper foodMapper;

    private final OpenFoodFactClient openFoodFactClient;

    @Override
    public ApiResponse<FoodDto> getFoodById(UUID foodId) {
        FoodDto foodDto = foodRepository.findById(foodId)
                .map(foodMapper::convertToFoodDto)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Return response
        return ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Successfully retrieved food!")
                .data(foodDto)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable) {
        Page<Food> foodPage = foodRepository.findAll(pageable);
        return buildFoodListResponse(foodPage);
    }


    @Override
    public ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByFoodNameContainingIgnoreCase(query, pageable);
        return buildFoodListResponse(foodPage);
    }

    // Helper method to build ApiResponse for food list
    private ApiResponse<List<FoodDto>> buildFoodListResponse(Page<Food> foodPage) {
        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", foodPage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", foodPage.getTotalPages());
        pagination.put("totalItems", foodPage.getTotalElements());
        pagination.put("pageSize", foodPage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        Page<FoodDto> foodPageDto = foodPage.map(foodMapper::convertToFoodDto);

        // Create response
        return ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved foods")
                .data(foodPageDto.getContent())
                .metadata(metadata)
                .timestamp(LocalDateTime.now())
                .build();
    }


    @Override
    public ApiResponse<FoodDto> scanFood(String barcode)
    {
        JsonNode response = openFoodFactClient.getProductByBarcode(barcode);
        
        JsonNode product = response.get("product");


        FoodDto foodDto = FoodDto.builder()
                .name(product.get("product_name").asText())
                .imageUrl(product.get("image_url").asText())
                .calories(product.get("nutriments").get("energy-kcal_100g").asInt())
                .protein(product.get("nutriments").get("proteins_100g").asDouble())
                .carbs(product.get("nutriments").get("carbohydrates_100g").asDouble())
                .fat(product.get("nutriments").get("fat_100g").asDouble())
                .build();
        return ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Scan Barcode Successfully!")
                .data(foodDto)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<?> addFood(FoodDto foodDto, UUID userId) {
        Food food = new Food();

        food.setFoodName(foodDto.getName());
        food.setCaloriesPer100g(foodDto.getCalories());
        food.setProteinPer100g(foodDto.getProtein());
        food.setCarbsPer100g(foodDto.getCarbs());
        food.setFatPer100g(foodDto.getFat());
        food.setImageUrl(foodDto.getImageUrl());
        food.setUserId(userId); 
        
        foodRepository.save(food);

        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully added food!")
                .timestamp(LocalDateTime.now())
                .build();
    }
}
