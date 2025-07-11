package com.hcmus.foodservice.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hcmus.foodservice.client.request.CreateFoodEmbeddingRequest;
import com.hcmus.foodservice.client.EmbeddingServiceClient;
import com.hcmus.foodservice.client.OpenFoodFactClient;
import com.hcmus.foodservice.client.request.UpdateFoodEmbeddingRequest;
import com.hcmus.foodservice.dto.FoodDto;
import com.hcmus.foodservice.dto.request.FoodRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodMacrosDetailsResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.exception.ValidationException;
import com.hcmus.foodservice.mapper.FoodMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.ServingUnitRepository;
import com.hcmus.foodservice.util.CustomSecurityContextHolder;
import feign.FeignException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class FoodServiceImpl implements FoodService {

    private final FoodRepository foodRepository;

    private final ServingUnitRepository servingUnitRepository;

    private final FoodMapper foodMapper;

    private final OpenFoodFactClient openFoodFactClient;

    private final EmbeddingServiceClient embeddingServiceClient;

    private final ObjectMapper objectMapper;

    @Override
    public ApiResponse<FoodDto> getFoodById(UUID foodId) {
        FoodDto foodDto = foodRepository.findById(foodId)
                .map(foodMapper::convertToFoodDto)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Return response
        return ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Successfully retrieved food!")
                .data(foodDto)
                .build();
    }

    @Override
    public ApiResponse<FoodMacrosDetailsResponse> getFoodMacrosDetailsById(UUID foodId, UUID servingUnitId, double numberOfServings) {
        // Get food
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));
        // Check if serving unit is valid
        ServingUnit servingUnit = servingUnitRepository.findById(servingUnitId)
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found with ID: " + servingUnitId));

        // Convert to FoodMacrosDetailsResponse
        FoodMacrosDetailsResponse foodMacrosDetailsResponse = foodMapper.converToFoodMacrosDetailsResponse(
                food,
                servingUnit,
                numberOfServings);

        return ApiResponse.<FoodMacrosDetailsResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved food macros details!")
                .data(foodMacrosDetailsResponse)
                .build();
    }


    @Override
    public ApiResponse<List<FoodDto>> getSystemFoods(Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByUserIdIsNull(pageable);
        return buildFoodListResponse(foodPage);
    }


    @Override
    public ApiResponse<List<FoodDto>> searchSystemFoodsByName(String query, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByUserIdIsNullAndFoodNameContainingIgnoreCase(query, pageable);
        return buildFoodListResponse(foodPage);
    }

    // Get my foods
    @Override
    public ApiResponse<List<FoodDto>> getFoodsByUserId(UUID userId, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByUserId(userId, pageable);
        return buildFoodListResponse(foodPage);
    }

    @Override
    public ApiResponse<List<FoodDto>> searchFoodsByUserIdAndName(UUID userId, String query, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByUserIdAndFoodNameContainingIgnoreCase(userId, query, pageable);
        return buildFoodListResponse(foodPage);
    }

    // Helper method to build ApiResponse for food list
    private ApiResponse<List<FoodDto>> buildFoodListResponse(Page<Food> foodPage) {
        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", foodPage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", foodPage.getTotalPages());
        pagination.put("totalItems", foodPage.getTotalElements());
        pagination.put("pageSize", foodPage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        Page<FoodDto> foodPageDto = foodPage.map(foodMapper::convertToFoodDto);

        // Create response
        return ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved foods")
                .data(foodPageDto.getContent())
                .metadata(metadata)
                .build();
    }


    @Override
    public ApiResponse<FoodDto> scanFood(String barcode) {
        JsonNode response = openFoodFactClient.getProductByBarcode(barcode);

        JsonNode product = response.get("product");

        FoodDto foodDto = FoodDto.builder()
                .name(product.get("product_name").asText())
                .imageUrl(product.get("image_url").asText())
                .calories(product.get("nutriments").get("energy-kcal_100g").asInt())
                .protein(product.get("nutriments").get("proteins_100g").asDouble())
                .carbs(product.get("nutriments").get("carbohydrates_100g").asDouble())
                .fat(product.get("nutriments").get("fat_100g").asDouble())
                .build();
        return ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Scan Barcode Successfully!")
                .data(foodDto)
                .build();
    }

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
