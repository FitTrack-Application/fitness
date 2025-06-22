package com.hcmus.foodservice.event.command;

import com.fasterxml.jackson.databind.JsonNode;
import com.hcmus.foodservice.client.request.CreateFoodEmbeddingRequest;
import com.hcmus.foodservice.client.EmbeddingServiceClient;
import com.hcmus.foodservice.client.request.UpdateFoodEmbeddingRequest;
import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.exception.ValidationException;
import com.hcmus.foodservice.mapper.FoodMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import feign.FeignException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;


import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class FoodCommandServiceImpl implements FoodCommandService {

    private final FoodRepository foodRepository;

    private final FoodMapper foodMapper;

    private final EmbeddingServiceClient embeddingServiceClient;


    @Transactional
    @Override
    public ApiResponse<FoodDto> createFood(FoodRequest foodDto, UUID userId) {
        Food food = new Food();

        food.setFoodName(foodDto.getName());
        food.setCaloriesPer100g(foodDto.getCalories());
        food.setProteinPer100g(foodDto.getProtein());
        food.setCarbsPer100g(foodDto.getCarbs());
        food.setFatPer100g(foodDto.getFat());
        food.setImageUrl(foodDto.getImageUrl());
        food.setUserId(userId);

        Food savedFood = foodRepository.save(food);

        if (CustomSecurityContextHolder.hasRole("ADMIN")) {
            try {
                CreateFoodEmbeddingRequest request = new CreateFoodEmbeddingRequest(savedFood.getFoodId().toString(), savedFood.getFoodName());
                JsonNode response = embeddingServiceClient.createFoodEmbedding(request);
                String message = response.get("message").asText();
                log.info("Successfully created food embedding: {}", message);
            } catch (FeignException e) {
                throw new RuntimeException("Failed to create food embedding for ID: " + savedFood.getFoodId(), e);
            } catch (ValidationException e) {
                log.info("Validation error creating food embedding for ID {}: {}", savedFood.getFoodId(), e.getMessage());
                throw new RuntimeException("Validation failed: " + e.getMessage(), e);
            }
        }

        return ApiResponse.<FoodDto>builder()
                .status(200)
                .data(foodMapper.convertToFoodDto(savedFood))
                .generalMessage("Successfully created food!")
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<?> deleteFoodByIdAndUserId(UUID foodId, UUID userId) {
        Food food = foodRepository.findByFoodIdAndUserId(foodId, userId);
        if (food == null) {
            throw new ResourceNotFoundException("Food not found with ID: " + foodId + " for user ID: " + userId);
        }

        foodRepository.delete(food);

        try {
            embeddingServiceClient.deleteFoodEmbedding(foodId.toString());
            log.info("Successfully deleted food embedding for ID: {}", foodId);
        } catch (FeignException e) {
            throw new RuntimeException("Failed to delete food embedding for ID: " + foodId, e);
        } catch (ValidationException e) {
            log.info("Validation error creating food embedding for ID {}: {}", foodId, e.getMessage());
            throw new RuntimeException("Validation failed: " + e.getMessage(), e);
        }

        return ApiResponse.builder()
                .status(200)
                .generalMessage("Successfully deleted food!")
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<FoodDto> updateFoodByIdAndUserId(UUID foodId, FoodRequest foodRequest, UUID userId) {
        Food food = foodRepository.findByFoodIdAndUserId(foodId, userId);
        if (food == null) {
            throw new ResourceNotFoundException("Food not found with ID: " + foodId + " for user ID: " + userId);
        }

        food.setFoodName(foodRequest.getName() == null ? food.getFoodName() : foodRequest.getName());
        food.setCaloriesPer100g(foodRequest.getCalories() == null ? food.getCaloriesPer100g() : foodRequest.getCalories());
        food.setProteinPer100g(foodRequest.getProtein() == null ? food.getProteinPer100g() : foodRequest.getProtein());
        food.setCarbsPer100g(foodRequest.getCarbs() == null ? food.getCarbsPer100g() : foodRequest.getCarbs());
        food.setFatPer100g(foodRequest.getFat() == null ? food.getFatPer100g() : foodRequest.getFat());
        food.setImageUrl(foodRequest.getImageUrl() == null ? food.getImageUrl() : foodRequest.getImageUrl());

        foodRepository.save(food);

        if (userId == null) {
            try {
                UpdateFoodEmbeddingRequest request = new UpdateFoodEmbeddingRequest(food.getFoodName());
                JsonNode response = embeddingServiceClient.updateFoodEmbedding(foodId.toString(), request);
                String message = response.get("message").asText();
                log.info("Successfully updated food embedding: {}", message);
            } catch (FeignException e) {
                throw new RuntimeException("Failed to update food embedding for ID: " + foodId, e);
            } catch (ValidationException e) {
                log.error("Validation error creating food embedding for ID {}: {}", foodId, e.getMessage());
                throw new RuntimeException("Validation failed: " + e.getMessage(), e);
            }
        }

        return ApiResponse.<FoodDto>builder()
                .status(200)
                .data(foodMapper.convertToFoodDto(food))
                .generalMessage("Successfully updated food!")
                .build();
    }
}
