package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;

import java.util.List;
import java.util.UUID;

public interface FoodService {
    List<FoodDto> getAllFoods();

    FoodDto getFoodById(UUID foodId);
}
