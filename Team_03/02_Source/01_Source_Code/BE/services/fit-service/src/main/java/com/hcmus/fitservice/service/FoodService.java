package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FoodService {

    ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable);

    ApiResponse<FoodDto> getFoodById(UUID foodId);

    ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable);


    ApiResponse<FoodDto> scanFood(String barcode);

    ApiResponse<?> addFood(FoodDto foodDto, UUID userId);
    ApiResponse<?> deleteFood(UUID foodId, UUID userId);
    ApiResponse<?> updateFood(UUID foodId, FoodDto foodDto, UUID userId);
}
