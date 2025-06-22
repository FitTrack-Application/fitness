package com.hcmus.foodservice.event.command;

import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;

import java.util.UUID;


public interface FoodCommandService {
    ApiResponse<FoodDto> createFood(FoodRequest foodDto, UUID userId);
    ApiResponse<?> deleteFoodByIdAndUserId(UUID foodId, UUID userId);
    ApiResponse<FoodDto> updateFoodByIdAndUserId(UUID foodId, FoodRequest foodRequest, UUID userId);
}
