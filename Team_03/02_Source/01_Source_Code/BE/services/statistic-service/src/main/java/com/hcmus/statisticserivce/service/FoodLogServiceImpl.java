package com.hcmus.statisticserivce.service;

import com.hcmus.statisticserivce.model.FoodLog;
import com.hcmus.statisticserivce.dto.FoodLogDto;
import com.hcmus.statisticserivce.exception.ResourceNotFoundException;
import com.hcmus.statisticserivce.repository.FoodLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FoodLogServiceImpl implements FoodLogService {

    private final FoodLogRepository foodLogRepository;

    @Override
    public List<FoodLogDto> getAllFoodLogs() {
        return foodLogRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public FoodLogDto getFoodLogById(UUID id) {
        FoodLog foodLog = foodLogRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FoodLog", "id", id));
        return mapToDto(foodLog);
    }

    @Override
    public List<FoodLogDto> getFoodLogsByUserId(UUID userId) {
        return foodLogRepository.findByUserId(userId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<FoodLogDto> getFoodLogsByUserIdAndDate(UUID userId, LocalDate date) {
        return foodLogRepository.findByUserIdAndDate(userId, date).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<FoodLogDto> getFoodLogsByUserIdAndDateRange(UUID userId, LocalDate startDate, LocalDate endDate) {
        return foodLogRepository.findByUserIdAndDateBetween(userId, startDate, endDate).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public FoodLogDto createFoodLog(FoodLogDto foodLogDto) {
        FoodLog foodLog = mapToEntity(foodLogDto);
        FoodLog savedFoodLog = foodLogRepository.save(foodLog);
        return mapToDto(savedFoodLog);
    }

    @Override
    public FoodLogDto updateFoodLog(UUID id, FoodLogDto foodLogDto) {
        FoodLog foodLog = foodLogRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FoodLog", "id", id));

        foodLog.setUserId(foodLogDto.getUserId());
        foodLog.setFoodId(foodLogDto.getFoodId());
        foodLog.setFoodItem(foodLogDto.getFoodItem());
        foodLog.setCalories(foodLogDto.getCalories());
        foodLog.setProtein(foodLogDto.getProtein());
        foodLog.setCarbs(foodLogDto.getCarbs());
        foodLog.setFat(foodLogDto.getFat());
        foodLog.setQuantity(foodLogDto.getQuantity());
        foodLog.setDate(foodLogDto.getDate());

        FoodLog updatedFoodLog = foodLogRepository.save(foodLog);
        return mapToDto(updatedFoodLog);
    }

    @Override
    public void deleteFoodLog(UUID id) {
        FoodLog foodLog = foodLogRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("FoodLog", "id", id));
        foodLogRepository.delete(foodLog);
    }

    private FoodLogDto mapToDto(FoodLog foodLog) {
        return FoodLogDto.builder()
                .foodLogId(foodLog.getFoodLogId())
                .userId(foodLog.getUserId())
                .foodId(foodLog.getFoodId())
                .foodItem(foodLog.getFoodItem())
                .calories(foodLog.getCalories())
                .protein(foodLog.getProtein())
                .carbs(foodLog.getCarbs())
                .fat(foodLog.getFat())
                .quantity(foodLog.getQuantity())
                .date(foodLog.getDate())
                .build();
    }

    private FoodLog mapToEntity(FoodLogDto foodLogDto) {
        FoodLog foodLog = new FoodLog();
        foodLog.setUserId(foodLogDto.getUserId());
        foodLog.setFoodId(foodLogDto.getFoodId());
        foodLog.setFoodItem(foodLogDto.getFoodItem());
        foodLog.setCalories(foodLogDto.getCalories());
        foodLog.setProtein(foodLogDto.getProtein());
        foodLog.setCarbs(foodLogDto.getCarbs());
        foodLog.setFat(foodLogDto.getFat());
        foodLog.setQuantity(foodLogDto.getQuantity());
        foodLog.setDate(foodLogDto.getDate());
        return foodLog;
    }
}