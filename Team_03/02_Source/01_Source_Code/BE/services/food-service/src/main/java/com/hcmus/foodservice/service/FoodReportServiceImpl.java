package com.hcmus.foodservice.service;

import com.hcmus.foodservice.dto.response.ApiResponse;
import com.hcmus.foodservice.dto.TopFoodDto;
import com.hcmus.foodservice.dto.response.FoodReportResponse;
import com.hcmus.foodservice.model.Food;

import com.hcmus.foodservice.repository.FoodRepository;
import com.hcmus.foodservice.repository.MealEntryRepository;
import com.hcmus.foodservice.repository.MealLogRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FoodReportServiceImpl implements FoodReportService {

    private final FoodRepository foodRepository;

    private final MealEntryRepository mealEntryRepository;

    private final MealLogRepository mealLogRepository;

    @Override
    public ApiResponse<FoodReportResponse> getFoodReport() {
        Integer totalFoodCount = (int) foodRepository.count();
        Integer totalMealCount = (int) mealLogRepository.count();


        List<UUID> distinctFoodIdsUsed = mealEntryRepository.findDistinctFoodIdsUsed();

        Integer usedCustomFood = 0;
        Integer usedAvailableFood = 0;

        for (UUID foodId : distinctFoodIdsUsed) {
            if (foodRepository.existsByFoodIdAndUserIdIsNotNull(foodId)) {
                usedCustomFood++;
            } else {
                usedAvailableFood++;
            }
        }


        Pageable topFive = PageRequest.of(0, 5);
        List<UUID> topFoodIds = mealEntryRepository.findTopMostUsedFoodIds(topFive);

        List<TopFoodDto> topFoodDtos = new ArrayList<>();

        for (UUID foodId : topFoodIds) {
            Food food = foodRepository.findByFoodId(foodId);
            TopFoodDto topFoodDto = new TopFoodDto();
            topFoodDto.setName(food.getFoodName());
            topFoodDto.setCount(mealEntryRepository.countByFood_FoodId(foodId));
            topFoodDtos.add(topFoodDto);
        }

        FoodReportResponse foodReportResponse = new FoodReportResponse();
        foodReportResponse.setTotalFood(totalFoodCount);
        foodReportResponse.setTotalMeal(totalMealCount);
        foodReportResponse.setUsedCustomFood(usedCustomFood);
        foodReportResponse.setUsedAvailableFood(usedAvailableFood);
        foodReportResponse.setTopFoods(topFoodDtos);


        return ApiResponse.<FoodReportResponse>builder()
                .status(200)
                .generalMessage("Successfully retrieved food report!")
                .data(foodReportResponse)
                .build();
    }

}
