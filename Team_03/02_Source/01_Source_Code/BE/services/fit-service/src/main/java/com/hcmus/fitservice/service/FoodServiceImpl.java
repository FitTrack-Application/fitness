package com.hcmus.fitservice.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.hcmus.fitservice.client.OpenFoodFactClient;
import com.hcmus.fitservice.dto.FoodDto;
import com.hcmus.fitservice.dto.FoodScanDto;
import com.hcmus.fitservice.dto.NutrimentsDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.mapper.FoodMapper;
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

    private final FoodMapper foodMapper;

    private final OpenFoodFactClient openFoodFactClient;

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
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<List<FoodDto>> getAllFoods(Pageable pageable) {
        Page<Food> foodPage = foodRepository.findAll(pageable);
        return buildFoodDtoListResponse(foodPage);
    }


    @Override
    public ApiResponse<List<FoodDto>> searchFoodsByName(String query, Pageable pageable) {
        Page<Food> foodPage = foodRepository.findByFoodNameContainingIgnoreCase(query, pageable);
        return buildFoodDtoListResponse(foodPage);
    }

    // Convert Food entity to FoodDto
    private ApiResponse<List<FoodDto>> buildFoodDtoListResponse(Page<Food> foodPage) {
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
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<FoodScanDto> scanFood(String barcode)
    {
        JsonNode response = openFoodFactClient.getProductByBarcode(barcode);
        
        JsonNode product = response.get("product");

        NutrimentsDto nutrimentsDto = NutrimentsDto.builder()
                .energy_kcal_100g(product.get("nutriments").get("energy-kcal_100g").asDouble())
                .fat_100g(product.get("nutriments").get("fat_100g").asDouble())
                .carbohydrates_100g(product.get("nutriments").get("carbohydrates_100g").asDouble())
                .proteins_100g(product.get("nutriments").get("proteins_100g").asDouble())
                .build();

        FoodScanDto foodScanDto = FoodScanDto.builder()
                .productName(product.get("product_name").asText())
                .image(product.get("image_url").asText())
                .servingSize(product.get("serving_size").asText())
                .nutriments(nutrimentsDto)
                .build();

        return ApiResponse.<FoodScanDto>builder()
                .status(200)
                .generalMessage("Scan Barcode Successfully!")
                .data(foodScanDto)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
