package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.UUID;

import java.util.List;

public interface FoodService {
    ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable);

    ApiResponse<FoodDto> getFoodById(UUID foodId);

    ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable);
}
