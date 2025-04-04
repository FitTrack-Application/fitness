package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.repository.FoodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class FoodServiceImpl implements FoodService {
    private final FoodRepository foodRepository;

    @Autowired
    public FoodServiceImpl(FoodRepository foodRepository) {
        this.foodRepository = foodRepository;
    }

    @Override
    public List<FoodDto> getAllFoods() {
        return foodRepository.findAll().stream().map(food -> new FoodDto(food.getId(),
                        food.getName(), food.getCaloriesPer100g(), food.getProteinPer100g(),
                        food.getCarbsPer100g(), food.getFatPer100g(), food.getImageUrl()))
                .collect(Collectors.toList());
    }

    @Override
    public FoodDto getFoodById(String foodId) {
        Food food = foodRepository.findById(UUID.fromString(foodId))
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with id: " + foodId));

        return new FoodDto(food.getId(), food.getName(), food.getCaloriesPer100g(),
                food.getProteinPer100g(), food.getCarbsPer100g(),
                food.getFatPer100g(), food.getImageUrl());
    }
}
