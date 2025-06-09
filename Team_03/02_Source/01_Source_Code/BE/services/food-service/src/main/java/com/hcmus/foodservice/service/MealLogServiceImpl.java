package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.request.AddRecipeToMealLogRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.MealLogResponse;
import com.hcmus.foodservice.exception.ResourceAlreadyExistsException;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.mapper.FoodEntryMapper;
import com.hcmus.foodservice.mapper.MealLogMapper;
import com.hcmus.foodservice.model.*;
import com.hcmus.foodservice.model.type.MealType;
import com.hcmus.foodservice.repository.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MealLogServiceImpl implements MealLogService {

    private final MealLogRepository mealLogRepository;

    private final FoodRepository foodRepository;

    private final RecipeRepository recipeRepository;

    private final MealEntryRepository mealEntryRepository;

    private final ServingUnitRepository servingUnitRepository;

    private final FoodEntryMapper foodEntryMapper;

    private final MealLogMapper mealLogMapper;

    @Override
    public ApiResponse<?> createDailyMealLogs(UUID userId, Date date) {
        // Check if meal logs is already existed
        List<MealLog> existingMealLogs = mealLogRepository.findByUserIdAndDate(userId, date);

        if (existingMealLogs != null && !existingMealLogs.isEmpty()) {
            throw new ResourceAlreadyExistsException("Daily meal logs already exists at this date");
        }

        // Create new meal logs
        List<MealLog> mealLogs = new ArrayList<>();

        for (MealType mealType : MealType.values()) {
            MealLog mealLog = new MealLog();
            mealLog.setDate(date);
            mealLog.setMealType(mealType);
            mealLog.setUserId(userId);
            mealLog.setMealEntries(new ArrayList<>());

            mealLogs.add(mealLog);
        }

        mealLogRepository.saveAll(mealLogs);

        // Return response
        return ApiResponse.builder()
                .status(201)
                .generalMessage("Meal logs created successfully")
                .build();
    }

    // Create meal entry
    private MealEntry createMealEntry(MealLog mealLog, UUID foodId, UUID servingUnitId, double numberOfServings) {
        // Check if food exists
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Check if number of servings is valid
        ServingUnit servingUnit = servingUnitRepository.findById(servingUnitId)
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found with ID: " + servingUnitId));

        MealEntry mealEntry = new MealEntry();
        mealEntry.setMealLog(mealLog);
        mealEntry.setFood(food);
        mealEntry.setNumberOfServings(numberOfServings);
        mealEntry.setServingUnit(servingUnit);

        return mealEntryRepository.save(mealEntry);
    }

    @Override
    public ApiResponse<FoodEntryResponse> addFoodToMealLog(UUID mealLogId, FoodEntryRequest foodEntryRequest) {
        // Check if meal log exists
        MealLog mealLog = mealLogRepository.findById(mealLogId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal log not found with ID: " + mealLogId));

        MealEntry mealEntry = createMealEntry(
                mealLog,
                foodEntryRequest.getFoodId(),
                foodEntryRequest.getServingUnitId(),
                foodEntryRequest.getNumberOfServings()
        );

        // Convert to Dto
        FoodEntryResponse foodEntryResponse = foodEntryMapper.convertToFoodEntryResponse(mealEntry);

        // Return response
        return ApiResponse.<FoodEntryResponse>builder()
                .status(201)
                .generalMessage("Meal entry added successfully")
                .data(foodEntryResponse)
                .build();
    }

    @Transactional
    @Override
    public ApiResponse<List<FoodEntryResponse>> addRecipeToMealLog(UUID mealLogId, AddRecipeToMealLogRequest addRecipeToMealLogRequest) {
        MealLog mealLog = mealLogRepository.findById(mealLogId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal log not found with ID: " + mealLogId));

        Recipe recipe = recipeRepository.findById(addRecipeToMealLogRequest.getRecipeId())
                .orElseThrow(() -> new ResourceNotFoundException("Recipe not found with ID: " + addRecipeToMealLogRequest.getRecipeId()));

        // Add each food entry of recipe to meal log
        List<MealEntry> mealEntries = new ArrayList<>();
        for (RecipeEntry recipeEntry : recipe.getRecipeEntries()) {
            MealEntry mealEntry = createMealEntry(
                    mealLog,
                    recipeEntry.getFood().getFoodId(),
                    recipeEntry.getServingUnit().getServingUnitId(),
                    recipeEntry.getNumberOfServings() * addRecipeToMealLogRequest.getNumberOfServings()
            );
            mealEntries.add(mealEntry);
        }
        ;
        // Convert to DTO
        List<FoodEntryResponse> foodEntryResponses = mealEntries.stream()
                .map(foodEntryMapper::convertToFoodEntryResponse)
                .toList();

        return ApiResponse.<List<FoodEntryResponse>>builder()
                .status(201)
                .generalMessage("Recipe added to meal log successfully")
                .data(foodEntryResponses)
                .build();

    }

    @Override
    @Transactional
    public ApiResponse<List<MealLogResponse>> getMealLogsByUserIdAndDate(UUID userId, Date date) {
        // Check if meal log exists
        List<MealLog> mealLogs = mealLogRepository.findByUserIdAndDate(userId, date);

        if (mealLogs.isEmpty()) {
            throw new ResourceNotFoundException("No meal logs found for user ID: " + userId + " and date: " + date);
        }

        // Convert to Dto
        List<MealLogResponse> mealLogResponses = mealLogs.stream().map(mealLogMapper::converToMealLogResponse).toList();

        // Return response
        return ApiResponse.<List<MealLogResponse>>builder()
                .status(200)
                .generalMessage("Meal logs retrieved successfully")
                .data(mealLogResponses)
                .build();
    }
}
