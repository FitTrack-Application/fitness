package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealLogDto;
import com.hcmus.fitservice.dto.response.ApiResponse;
import com.hcmus.fitservice.exception.ResourceAlreadyExistsException;
import com.hcmus.fitservice.exception.ResourceNotFoundException;
import com.hcmus.fitservice.model.Food;
import com.hcmus.fitservice.model.MealEntry;
import com.hcmus.fitservice.model.MealLog;
import com.hcmus.fitservice.model.type.MealType;
import com.hcmus.fitservice.model.type.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.MealEntryRepository;
import com.hcmus.fitservice.repository.MealLogRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MealLogServiceImpl implements MealLogService {
    private final MealLogRepository mealLogRepository;

    private final FoodRepository foodRepository;

    private final MealEntryRepository mealEntryRepository;

    @Override
    public ApiResponse<Void> createMealLog(UUID userId, Date date, String mealType) {
        // Check if meal log is already existed
        MealLog existingMealLog = mealLogRepository.findByUserIdAndDateAndMealType(userId, date, MealType.valueOf(mealType));

        if (existingMealLog != null) {
            throw new ResourceAlreadyExistsException("Meal log already exists at this date and meal");
        }

        // Create new meal log
        MealLog mealLog = new MealLog();
        mealLog.setUserId(userId);
        mealLog.setDate(date);
        mealLog.setMealType(MealType.valueOf(mealType));

        mealLogRepository.save(mealLog);

        // Create response
        ApiResponse<Void> response = ApiResponse.<Void>builder()
                .status(201)
                .generalMessage("Meal log created successfully")
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }

    @Override
    public ApiResponse<MealEntryDto> addMealEntry(UUID mealLogId, UUID foodId, String servingUnit, Double numberOfServings) {
        // Find the meal log by ID
        MealLog mealLog = mealLogRepository.findById(mealLogId)
                .orElseThrow(() -> new ResourceNotFoundException("Meal log not found with ID: " + mealLogId));

        // Find food by ID
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with ID: " + foodId));

        // Create new meal entry
        MealEntry mealEntry = new MealEntry();
        mealEntry.setMealLog(mealLog);
        mealEntry.setFood(food);
        mealEntry.setNumberOfServings(numberOfServings);
        mealEntry.setServingUnit(ServingUnit.valueOf(servingUnit));

        mealEntryRepository.save(mealEntry);

        MealEntryDto mealEntryDto = new MealEntryDto(mealEntry.getMealEntryId(), food.getFoodId(), mealEntry.getServingUnit().name(), mealEntry.getNumberOfServings());

        // Create response
        ApiResponse<MealEntryDto> response = ApiResponse.<MealEntryDto>builder()
                .status(201)
                .generalMessage("Meal entry added successfully")
                .data(mealEntryDto)
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }

    @Override
    @Transactional
    public ApiResponse<List<MealLogDto>> getMealLogsByUserIdAndDate(UUID userId, Date date) {
        // Find the meal log by user ID and date
        List<MealLog> mealLogs = mealLogRepository.findByUserIdAndDate(userId, date);

        if (mealLogs.isEmpty()) {
            throw new ResourceNotFoundException("No meal logs found for user ID: " + userId + " and date: " + date);
        }

        // Convert to Dto
        List<MealLogDto> mealLogDtos = mealLogs.stream().map(
                mealLog -> new MealLogDto(
                        mealLog.getMealLogId(),
                        date,
                        mealLog.getMealType().name(),
                        mealLog.getMealEntries().stream()
                                .map(mealEntry -> new MealEntryDto(
                                        mealEntry.getMealEntryId(),
                                        mealEntry.getFood().getFoodId(),
                                        mealEntry.getServingUnit().name(),
                                        mealEntry.getNumberOfServings()))
                                .collect(Collectors.toList())
                )
        ).collect(Collectors.toList());

        // Create response
        ApiResponse<List<MealLogDto>> response = ApiResponse.<List<MealLogDto>>builder()
                .status(200)
                .generalMessage("Meal logs retrieved successfully")
                .data(mealLogDtos)
                .timestamp(LocalDateTime.now())
                .build();

        return response;
    }
}
