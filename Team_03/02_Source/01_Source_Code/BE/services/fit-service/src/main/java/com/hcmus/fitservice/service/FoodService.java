package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.UUID;

import java.util.List;

public interface FoodService {
    Page<FoodDto> getAllFoods(Pageable pageable);

    FoodDto getFoodById(UUID foodId);

    Page<FoodDto> searchFoodsByName(String query, Pageable pageable);
}
