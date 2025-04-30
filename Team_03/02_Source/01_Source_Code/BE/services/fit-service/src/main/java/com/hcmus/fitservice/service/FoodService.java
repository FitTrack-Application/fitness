package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.request.AddFoodRequest;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.dto.request.FoodMacrosDetailsRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.FoodMacrosDetailsResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FoodService {

    ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable);

    ApiResponse<FoodDto> getFoodById(UUID foodId);

    ApiResponse<FoodMacrosDetailsResponse> getFoodMacrosDetailsById(UUID foodId, FoodMacrosDetailsRequest foodMacrosDetailsRequest);

    ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable);

    ApiResponse<FoodDto> scanFood(String barcode);

    ApiResponse<?> addFood(AddFoodRequest foodDto, UUID userId);

    ApiResponse<?> deleteFood(UUID foodId, UUID userId);

    ApiResponse<?> updateFood(UUID foodId, FoodDto foodDto, UUID userId);
}
