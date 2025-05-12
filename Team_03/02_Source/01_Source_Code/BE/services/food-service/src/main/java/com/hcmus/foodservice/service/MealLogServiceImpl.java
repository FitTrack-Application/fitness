package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.request.FoodEntryRequest;
import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.response.FoodEntryResponse;
import com.hcmus.foodservice.dto.response.MealLogResponse;
import com.hcmus.foodservice.exception.ResourceAlreadyExistsException;
import com.hcmus.foodservice.exception.ResourceNotFoundException;
import com.hcmus.foodservice.mapper.FoodEntryMapper;
import com.hcmus.foodservice.mapper.MealLogMapper;
import com.hcmus.foodservice.model.Food;
import com.hcmus.foodservice.model.MealEntry;
import com.hcmus.foodservice.model.MealLog;
import com.hcmus.foodservice.model.ServingUnit;
import com.hcmus.foodservice.model.type.MealType;
import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.MealEntryRepository;
import com.hcmus.foodservice.repository.MealLogRepository;
import com.hcmus.foodservice.repository.ServingUnitRepository;
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

    @Override
    public ApiResponse<FoodEntryResponse> addMealEntry(UUID mealLogId, FoodEntryRequest foodEntryRequest) {
        // Check if meal log exists
        MealLog mealLog = mealLogRepository.findById(mealLogId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal log not found with ID: " + mealLogId));

        // Check if food exists
        Food food = foodRepository.findById(foodEntryRequest.getFoodId())
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodEntryRequest.getFoodId()));

        // Check if number of servings is valid
        ServingUnit servingUnit = servingUnitRepository.findById(foodEntryRequest.getServingUnitId())
                .orElseThrow(() -> new ResourceNotFoundException("Serving unit not found with ID: " + foodEntryRequest.getServingUnitId()));

        // Create new meal entry
        MealEntry mealEntry = new MealEntry();
        mealEntry.setMealLog(mealLog);
        mealEntry.setFood(food);
        mealEntry.setNumberOfServings(foodEntryRequest.getNumberOfServings());
        mealEntry.setServingUnit(servingUnit);

        MealEntry savedMealEntry = mealEntryRepository.save(mealEntry);

        // Convert to Dto
        FoodEntryResponse foodEntryResponse = foodEntryMapper.convertToFoodEntryDto(savedMealEntry);

        // Return response
        return ApiResponse.<FoodEntryResponse>builder()
                .status(201)
                .generalMessage("Meal entry added successfully")
                .data(foodEntryResponse)
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
