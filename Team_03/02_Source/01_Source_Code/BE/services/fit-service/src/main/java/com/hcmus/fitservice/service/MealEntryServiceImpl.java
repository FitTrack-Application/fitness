package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.response.FoodEntryResponse;
import com.hcmus.fitservice.dto.request.FoodEntryRequest;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.mapper.FoodEntryMapper;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.MealEntry;
import com.hcmus.fitservice.model.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.MealEntryRepository;
import com.hcmus.fitservice.repository.ServingUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MealEntryServiceImpl implements MealEntryService {
    private final MealEntryRepository mealEntryRepository;

    private final FoodRepository foodRepository;

    private final ServingUnitRepository servingUnitRepository;

    private final FoodEntryMapper foodEntryMapper;

    @Override
    public ApiResponse<Void> deleteMealEntry(UUID mealEntryId) {
        // Find the meal entry by id
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal entry not found with ID: " + mealEntryId));

        // Delete the meal entry
        mealEntryRepository.delete(mealEntry);

        return ApiResponse.<Void>builder()
                .status(200)
                .generalMessage("Successfully deleted meal entry")
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<FoodEntryResponse> updateMealEntry(UUID mealEntryId, FoodEntryRequest foodEntryRequest) {
        // Check if meal entry exists
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal entry not found with ID: " + mealEntryId));

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
                .timestamp(LocalDateTime.now())
                .build();
    }
}
