package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.repository.FoodRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FoodServiceImpl implements FoodService {
    private final FoodRepository foodRepository;

    @Override
    public ApiResponse<FoodDto> getFoodById(UUID foodId) {
        FoodDto foodDto = foodRepository.findById(foodId)
                .map(this::convertToDto)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Create response
        ApiResponse<FoodDto> response = ApiResponse.<FoodDto>builder()
                .status(200)
                .generalMessage("Successfully retrieved food")
                .data(foodDto)
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }


    @Override
    public ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable) {
        Page<Food> foodPage = foodRepository.findAll(pageable);

        // Convert to Dto
        Page<FoodDto> foodPageDto = foodPage.map(this::convertToDto);

        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", foodPage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", foodPage.getTotalPages());
        pagination.put("totalItems", foodPage.getTotalElements());
        pagination.put("pageSize", foodPage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        // Create response
        ApiResponse<List<FoodDto>> response = ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved foods")
                .data(foodPageDto.getContent())
                .metadata(metadata)
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }


    @Override
    public ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByFoodNameContainingIgnoreCase(query, pageable);

        // Convert to Dto
        Page<FoodDto> foodPageDto = foodPage.map(this::convertToDto);

        // Pagination info
        Map<String, Object> pagination = new HashMap<>();
        pagination.put("currentPage", foodPage.getNumber() + 1); // Page number start at 1
        pagination.put("totalPages", foodPage.getTotalPages());
        pagination.put("totalItems", foodPage.getTotalElements());
        pagination.put("pageSize", foodPage.getSize());

        Map<String, Object> metadata = new HashMap<>();
        metadata.put("pagination", pagination);

        // Create response
        ApiResponse<List<FoodDto>> response = ApiResponse.<List<FoodDto>>builder()
                .status(200)
                .generalMessage("Successfully retrieved foods")
                .data(foodPageDto.getContent())
                .metadata(metadata)
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }

    // Convert Food entity to FoodDto
    private FoodDto convertToDto(Food food) {
        return new FoodDto(
                food.getFoodId(),
                food.getFoodName(),
                food.getCaloriesPer100g(),
                food.getProteinPer100g(),
                food.getCarbsPer100g(),
                food.getFatPer100g());
    }
}
