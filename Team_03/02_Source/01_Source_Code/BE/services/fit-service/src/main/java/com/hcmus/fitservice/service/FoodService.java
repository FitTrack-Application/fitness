package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.request.FoodRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.dto.response.FoodMacrosDetailsResponse;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FoodService {

    ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable);

    ApiResponse<FoodDto> getFoodById(UUID foodId);

    ApiResponse<FoodMacrosDetailsResponse> getFoodMacrosDetailsById(UUID foodId, UUID servingUnitId, double numberOfServings);

    ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable);

    ApiResponse<FoodDto> scanFood(String barcode);

    ApiResponse<?> createFood(FoodRequest foodRequest, UUID userId);

    ApiResponse<?> deleteFood(UUID foodId, UUID userId);

    ApiResponse<?> updateFood(UUID foodId, FoodRequest foodRequest, UUID userId);
}
