package com.hcmus.foodservice.event.query;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;

import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.UUID;

public interface FoodQueryService {
    ApiResponse<FoodDto> getFoodById(UUID foodId);
    ApiResponse<FoodMacrosDetailsResponse> getFoodMacrosDetailsById(UUID foodId, UUID servingUnitId, double numberOfServings);
    ApiResponse<List<FoodDto>> getSystemFoods(Pageable pageable);
    ApiResponse<List<FoodDto>> searchSystemFoodsByName(String query, Pageable pageable);
    ApiResponse<List<FoodDto>> getFoodsByUserId(UUID userId, Pageable pageable);
    ApiResponse<List<FoodDto>> searchFoodsByUserIdAndName(UUID userId, String query, Pageable pageable);
    ApiResponse<FoodDto> scanFood(String barcode);
}
