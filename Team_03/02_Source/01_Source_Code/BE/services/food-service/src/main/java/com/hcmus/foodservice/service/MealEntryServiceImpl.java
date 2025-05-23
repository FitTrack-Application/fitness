package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.TotalCaloriesConsumedResponse;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.mapper.FoodEntryMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.MealEntry;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.MealEntryRepository;
import com.hcmus.foodservice.repository.ServingUnitRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MealEntryServiceImpl implements MealEntryService {
    private final MealEntryRepository mealEntryRepository;

    private final FoodRepository foodRepository;

    private final ServingUnitRepository servingUnitRepository;

    private final FoodEntryMapper foodEntryMapper;

    @Override
    @Transactional
    public ApiResponse<Void> deleteMealEntryById(UUID mealEntryId) {
        // Find the meal entry by id
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal entry not found with ID: " + mealEntryId));

        // Delete the meal entry
        mealEntryRepository.delete(mealEntry);

        return ApiResponse.<Void>builder()
                .status(200)
                .generalMessage("Successfully deleted meal entry")
                .build();
    }

    @Override
    public ApiResponse<FoodEntryResponse> updateMealEntryById(UUID mealEntryId, FoodEntryRequest foodEntryRequest) {
        // Check if meal entry exists
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal entry not found with ID: " + mealEntryId ));

        // Check if food exists
        Food food = foodRepository.findById(foodEntryRequest.getFoodId())
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodEntryRequest.getFoodId()));

        // Check if serving unit is valid
        ServingUnit servingUnit = servingUnitRepository.findById(foodEntryRequest.getServingUnitId())
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found with ID: " + foodEntryRequest.getServingUnitId()));

        // Update meal entry
        mealEntry.setFood(food);
        mealEntry.setServingUnit(servingUnit);
        mealEntry.setNumberOfServings(foodEntryRequest.getNumberOfServings());

        mealEntryRepository.save(mealEntry);

        // Convert to Dto
        FoodEntryResponse foodEntryResponse = foodEntryMapper.convertToFoodEntryDto(mealEntry);

        return ApiResponse.<FoodEntryResponse>builder()
                .status(200)
                .generalMessage("Successfully updated meal entry")
                .data(foodEntryResponse)
                .build();
    }

    @Override
    public ApiResponse<TotalCaloriesConsumedResponse> getTotalCaloriesConsumedByUserId(UUID userId) {
        Double totalCaloriesConsumed = mealEntryRepository.getTotalCaloriesConsumedByUserId(userId);
        if (totalCaloriesConsumed == null) {
            totalCaloriesConsumed = 0.0;
        }

        TotalCaloriesConsumedResponse response = TotalCaloriesConsumedResponse.builder()
                .totalCaloriesConsumed(totalCaloriesConsumed)
                .build();

        return ApiResponse.<TotalCaloriesConsumedResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved total calories consumed")
                .data(response)
                .build();
    }
}
