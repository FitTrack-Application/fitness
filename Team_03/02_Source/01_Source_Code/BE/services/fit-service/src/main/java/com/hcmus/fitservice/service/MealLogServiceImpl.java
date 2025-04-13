package com.hcmus.fitservice.service;

import com.hcmus.fitservice.dto.MealEntryDto;
import com.hcmus.fitservice.dto.MealLogDto;
import com.hcmus.fitservice.model.*;
import com.hcmus.fitservice.model.type.MealType;
import com.hcmus.fitservice.model.type.ServingUnit;
import com.hcmus.fitservice.repository.FoodRepository;
import com.hcmus.fitservice.repository.MealEntryRepository;
import com.hcmus.fitservice.repository.MealLogRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class MealLogServiceImpl implements MealLogService {
    private final MealLogRepository mealLogRepository;

    private final FoodRepository foodRepository;

    private final MealEntryRepository mealEntryRepository;

    @Autowired
    public MealLogServiceImpl(MealLogRepository mealLogRepository, FoodRepository foodRepository, MealEntryRepository mealEntryRepository) {
        this.mealLogRepository = mealLogRepository;
        this.foodRepository = foodRepository;
        this.mealEntryRepository = mealEntryRepository;
    }

    @Override
    public void createMealLog(UUID userId, Date date, String mealType) {
        // Check if meal log is already existed
        MealLog existingMealLog = mealLogRepository.findByUserIdAndDateAndMealType(userId, date, MealType.valueOf(mealType));

        if (existingMealLog != null) {
            throw new IllegalArgumentException("Meal log already exists");
        }

        // Create new meal log
        MealLog mealLog = new MealLog();
        mealLog.setUserId(userId);
        mealLog.setDate(date);
        mealLog.setMealType(MealType.valueOf(mealType));

        mealLogRepository.save(mealLog);
    }

    @Override
    public MealEntryDto addMealEntry(UUID mealLogId, UUID foodId, String servingUnit, Double numberOfServings) {
        // Find the meal log by ID
        MealLog mealLog = mealLogRepository.findById(mealLogId)
                .orElseThrow(() -> new IllegalArgumentException("Meal log not found with ID: " + mealLogId));

        // Find food by ID
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new IllegalArgumentException("Food not found with ID: " + foodId));

        // Create new meal entry
        MealEntry mealEntry = new MealEntry();
        mealEntry.setMealLog(mealLog);
        mealEntry.setFood(food);
//        mealEntry.setNumberOfServings(numberOfServings);
        mealEntry.setServingUnit(ServingUnit.valueOf(servingUnit));

        mealEntryRepository.save(mealEntry);

        return new MealEntryDto(mealEntry.getMealEntryId(), food.getFoodId(), mealEntry.getServingUnit().name(), mealEntry.getNumberOfServings());
    }

    @Override
    @Transactional
    public List<MealLogDto> getMealLogsByUserIdAndDate(UUID userId, Date date) {
        // Find the meal log by user ID and date
        List<MealLog> mealLogs = mealLogRepository.findByUserIdAndDate(userId, date);

        if (mealLogs.isEmpty()) {
            throw new IllegalArgumentException("No meal logs found for user ID: " + userId + " and date: " + date);
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

        return mealLogDtos;
    }
}
