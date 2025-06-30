package com.hcmus.foodservice.event.command;

import com.hcmus.foodservice.model.Food ;
import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.exception.ResourceNotFoundException;

import com.hcmus.foodservice.mapper.FoodMapper;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.event.EventStore;
import com.hcmus.foodservice.event.events.FoodCreatedEvent;
import com.hcmus.foodservice.event.events.FoodDeletedEvent;
import com.hcmus.foodservice.event.events.FoodUpdatedEvent;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.UUID;



@Service
@RequiredArgsConstructor
public class FoodCommandHandler {

    private final FoodRepository foodRepository;
    private final EventStore eventStore;
    private final FoodMapper foodMapper;
    public FoodDto handleCreate(CreateFoodCommand command) {
        Food food = new Food();
        food.setFoodId(UUID.randomUUID());
        food.setFoodName(command.getName());
        food.setCaloriesPer100g(command.getCalories());
        food.setProteinPer100g(command.getProtein());
        food.setCarbsPer100g(command.getCarbs());
        food.setFatPer100g(command.getFat());
        food.setImageUrl(command.getImageUrl());
        food.setUserId(command.getUserId());

        Food savedFood = foodRepository.save(food);

        eventStore.save(savedFood.getFoodId().toString(), new FoodCreatedEvent(
            savedFood.getFoodId(),
            savedFood.getFoodName(),
            savedFood.getCaloriesPer100g(),
            savedFood.getProteinPer100g(),
            savedFood.getCarbsPer100g(),
            savedFood.getFatPer100g(),
            savedFood.getImageUrl(),
            savedFood.getUserId()
        ));

        return foodMapper.convertToFoodDto(savedFood);
    }

    public void handleDelete(DeleteFoodCommand command) {
        Food food = foodRepository.findByFoodIdAndUserId(command.getFoodId(), command.getUserId());
        if (food == null) {
            throw new ResourceNotFoundException("Food not found with ID: " + command.getFoodId());
        }
        foodRepository.delete(food);
        
        eventStore.save(food.getFoodId().toString(), new FoodDeletedEvent(food.getFoodId(), food.getFoodName()));
    }

    public FoodDto handleUpdate(UpdateFoodCommand command) {
        Food food = foodRepository.findByFoodIdAndUserId(command.getFoodId(), command.getUserId());
        if (food == null) {
            throw new ResourceNotFoundException("Food not found with ID: " + command.getFoodId());
        }
        if (command.getName() != null) food.setFoodName(command.getName());
        if (command.getCalories() != null) food.setCaloriesPer100g(command.getCalories());
        if (command.getProtein() != null) food.setProteinPer100g(command.getProtein());
        if (command.getCarbs() != null) food.setCarbsPer100g(command.getCarbs());
        if (command.getFat() != null) food.setFatPer100g(command.getFat());
        if (command.getImageUrl() != null) food.setImageUrl(command.getImageUrl());

        Food updatedFood = foodRepository.save(food);

        eventStore.save(updatedFood.getFoodId().toString(),
            new FoodUpdatedEvent(
                updatedFood.getFoodId(),
                updatedFood.getFoodName(),
                updatedFood.getCaloriesPer100g(),
                updatedFood.getProteinPer100g(),
                updatedFood.getCarbsPer100g(),
                updatedFood.getFatPer100g(),
                updatedFood.getImageUrl()
            )
        );

        return foodMapper.convertToFoodDto(updatedFood);
    }
}

