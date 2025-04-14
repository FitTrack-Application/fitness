package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.MealEntry;
import com.hcmus.fitservice.model.type.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.MealEntryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MealEntryServiceImpl implements MealEntryService {
    private final MealEntryRepository mealEntryRepository;

    private final FoodRepository foodRepository;

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
    public ApiResponse<MealEntryDto> updateMealEntry(UUID mealEntryId, UUID foodId, String servingUnit, Double numberOfServings) {
        // Find the meal entry by ID
        MealEntry mealEntry = mealEntryRepository.findById(mealEntryId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal entry not found with ID: " + mealEntryId));

        // Find food by ID
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Update meal entry
        mealEntry.setFood(food);
        mealEntry.setServingUnit(ServingUnit.valueOf(servingUnit));
        mealEntry.setNumberOfServings(numberOfServings);

        mealEntryRepository.save(mealEntry);

        MealEntryDto mealEntryDto = new MealEntryDto(mealEntryId, foodId, servingUnit, numberOfServings);

        return ApiResponse.<MealEntryDto>builder()
                .status(200)
                .generalMessage("Successfully updated meal entry")
                .data(mealEntryDto)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
