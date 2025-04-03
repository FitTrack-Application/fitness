package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface FoodService {
    List<FoodDto> getAllFoods();

    FoodDto getFoodById(UUID foodId);

    Page<FoodDto> searchFoodsByName(String query, Pageable pageable);
}
