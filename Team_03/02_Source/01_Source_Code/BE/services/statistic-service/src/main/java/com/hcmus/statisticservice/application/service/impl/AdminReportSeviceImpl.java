package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.CustomExerciseUsageDto;
import com.hcmus.statisticservice.application.dto.CustomFoodUsageDto;
import com.hcmus.statisticservice.application.dto.response.AdminReportResponse;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.ExerciseReportResponse;
import com.hcmus.statisticservice.application.dto.response.FoodReportResponse;
import com.hcmus.statisticservice.application.dto.CustomFoodUsageDto;
import com.hcmus.statisticservice.application.dto.CustomExerciseUsageDto;
import com.hcmus.statisticservice.application.service.AdminReportService;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import com.hcmus.statisticservice.domain.repository.LatestLoginRepository;
import com.hcmus.statisticservice.infrastructure.client.ExerciseServiceClient;
import com.hcmus.statisticservice.infrastructure.client.FoodServiceClient;

import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminReportSeviceImpl implements AdminReportService {

    private final FitProfileRepository fitProfileRepository;
    private final LatestLoginRepository latestLoginRepository;
    private final FoodServiceClient foodServiceClient;
    private final ExerciseServiceClient exerciseServiceClient;

    @Override
    public ApiResponse<AdminReportResponse> getAdminReport() {

        ApiResponse<FoodReportResponse> foodReportResponse = foodServiceClient.getFoodReport();

        ApiResponse<ExerciseReportResponse> exerciseReportResponse = exerciseServiceClient.getExerciseReport();

        Integer totalUser = fitProfileRepository.count();

        Integer activeUser = latestLoginRepository.countActiveUser();

        List<CustomFoodUsageDto> customFoodUsage = new ArrayList<>();

        CustomFoodUsageDto usedCustomFood = new CustomFoodUsageDto();
        usedCustomFood.setLabel("Used custom food");
        usedCustomFood.setCount(foodReportResponse.getData().getUsedCustomFood());
        CustomFoodUsageDto usedAvailableFood = new CustomFoodUsageDto();
        usedAvailableFood.setLabel("Used available food");
        usedAvailableFood.setCount(foodReportResponse.getData().getUsedAvailableFood());
        customFoodUsage.add(usedCustomFood);
        customFoodUsage.add(usedAvailableFood);

        List<CustomExerciseUsageDto> customExerciseUsage = new ArrayList<>();

        CustomExerciseUsageDto usedCustomExercise = new CustomExerciseUsageDto();
        usedCustomExercise.setLabel("Used custom exercise");
        usedCustomExercise.setCount(exerciseReportResponse.getData().getUsedCustomExercise());
        CustomExerciseUsageDto usedAvailableExercise = new CustomExerciseUsageDto();
        usedAvailableExercise.setLabel("Used available exercise");
        usedAvailableExercise.setCount(exerciseReportResponse.getData().getUsedAvailableExercise());
        customExerciseUsage.add(usedCustomExercise);
        customExerciseUsage.add(usedAvailableExercise);

        AdminReportResponse adminReportResponse = new AdminReportResponse();
        adminReportResponse.setTotalUsers(totalUser);
        adminReportResponse.setActiveUsers(activeUser);
        adminReportResponse.setTotalMeals(foodReportResponse.getData().getTotalMeal());
        adminReportResponse.setTotalFoods(foodReportResponse.getData().getTotalFood());
        adminReportResponse.setTotalExercises(exerciseReportResponse.getData().getTotalExercise());
        adminReportResponse.setCustomFoodUsage(customFoodUsage);
        adminReportResponse.setCustomExerciseUsage(customExerciseUsage);
        adminReportResponse.setTopFoods(foodReportResponse.getData().getTopFoods());
        adminReportResponse.setTopExercises(exerciseReportResponse.getData().getTopExercises());

        return ApiResponse.<AdminReportResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get admin report successfully!")
                .data(adminReportResponse)
                .build();

    }
    
}
