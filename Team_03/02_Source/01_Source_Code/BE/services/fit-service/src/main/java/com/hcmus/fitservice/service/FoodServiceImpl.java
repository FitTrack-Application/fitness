package com.hcmus.fitservice.service;

import com.hcmus.fitservice.db.model.Food;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
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
        return foodRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public FoodDto getFoodById(UUID id) {
        Food food = foodRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Food", "id", id));
        return mapToDto(food);
    }

    @Override
    public List<FoodDto> searchFoodsByName(String name) {
        return foodRepository.findByFoodNameContainingIgnoreCase(name).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public FoodDto createFood(FoodDto foodDto) {
        Food food = mapToEntity(foodDto);
        Food savedFood = foodRepository.save(food);
        return mapToDto(savedFood);
    }

    @Override
    public FoodDto updateFood(UUID id, FoodDto foodDto) {
        Food food = foodRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Food", "id", id));

        food.setFoodName(foodDto.getFoodName());
        food.setCalories(foodDto.getCalories());
        food.setProtein(foodDto.getProtein());
        food.setCarbs(foodDto.getCarbs());
        food.setFat(foodDto.getFat());

        Food updatedFood = foodRepository.save(food);
        return mapToDto(updatedFood);
    }

    @Override
    public void deleteFood(UUID id) {
        Food food = foodRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Food", "id", id));
        foodRepository.delete(food);
    }

    private FoodDto mapToDto(Food food) {
        return FoodDto.builder()
                .foodId(food.getFoodId())
                .foodName(food.getFoodName())
                .calories(food.getCalories())
                .protein(food.getProtein())
                .carbs(food.getCarbs())
                .fat(food.getFat())
                .build();
    }

    private Food mapToEntity(FoodDto foodDto) {
        Food food = new Food();
        food.setFoodName(foodDto.getFoodName());
        food.setCalories(foodDto.getCalories());
        food.setProtein(foodDto.getProtein());
        food.setCarbs(foodDto.getCarbs());
        food.setFat(foodDto.getFat());
        return food;
    }
}