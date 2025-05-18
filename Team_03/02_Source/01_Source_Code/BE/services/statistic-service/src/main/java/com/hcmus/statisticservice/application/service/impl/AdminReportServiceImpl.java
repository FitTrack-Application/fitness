package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.CustomExerciseUsageDto;
import com.hcmus.statisticservice.application.dto.CustomFoodUsageDto;
import com.hcmus.statisticservice.application.dto.NewUsersByWeekDto;
import com.hcmus.statisticservice.application.dto.EarlyChurnByWeekDto;
import com.hcmus.statisticservice.application.dto.request.ExerciseRequest;
import com.hcmus.statisticservice.application.dto.request.FoodRequest;
import com.hcmus.statisticservice.application.dto.response.AdminReportResponse;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.ExerciseReportResponse;
import com.hcmus.statisticservice.application.dto.response.FoodReportResponse;
import com.hcmus.statisticservice.application.service.AdminReportService;
import com.hcmus.statisticservice.domain.repository.FitProfileRepository;
import com.hcmus.statisticservice.domain.repository.LatestLoginRepository;
import com.hcmus.statisticservice.infrastructure.client.ExerciseServiceClient;
import com.hcmus.statisticservice.infrastructure.client.FoodServiceClient;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.time.temporal.WeekFields;

@Service
@RequiredArgsConstructor
public class AdminReportServiceImpl implements AdminReportService {

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
        adminReportResponse.setNewUsersByWeek(getNewUsersByWeek());
        adminReportResponse.setEarlyChurnByWeek(getEarlyChurnByWeek());
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
    
    @Override
    public ApiResponse<?> importFood(List<FoodRequest> foodRequests) {
        for(FoodRequest foodRequest : foodRequests) {
            foodServiceClient.addFood(foodRequest);
        }
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully import foods!")
                .build();
    }

    @Override
    public ApiResponse<?> importExercise(List<ExerciseRequest> exerciseRequests) {
        for(ExerciseRequest exerciseRequest : exerciseRequests) {
            exerciseServiceClient.createExercise(exerciseRequest);
        }
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully import exercises!")
                .build();
    }

    public List<NewUsersByWeekDto> getNewUsersByWeek() {
        List<Object[]> rawStats = fitProfileRepository.countNewUsersByWeek();
        return buildWeekDtoList(rawStats, 12, 0, false);
    }

    public List<EarlyChurnByWeekDto> getEarlyChurnByWeek() {
        List<Object[]> rawStats = fitProfileRepository.countEarlyChurnByWeek();
        return buildWeekDtoList(rawStats, 12, 2, true);
    }

    private <T> List<T> buildWeekDtoList(List<Object[]> rawData, int totalWeeks, int weeksToSkipAtEnd, boolean isChurn) {
        Map<LocalDate, Integer> map = new HashMap<>();
        WeekFields wf = WeekFields.ISO;

        for (Object[] row : rawData) {
            int year = ((Number) row[0]).intValue();
            int week = ((Number) row[1]).intValue();
            int count = ((Number) row[2]).intValue();

            LocalDate startOfWeek = LocalDate.now()
                .withYear(year)
                .with(wf.weekOfWeekBasedYear(), week)
                .with(wf.dayOfWeek(), 1);
            map.put(startOfWeek, count);
        }

        List<T> result = new ArrayList<>();
        LocalDate now = LocalDate.now().with(DayOfWeek.MONDAY);
        LocalDate start = now.minusWeeks(totalWeeks + weeksToSkipAtEnd);

        for (int i = 0; i < totalWeeks; i++) {
            LocalDate weekStart = start.plusWeeks(i);
            Date date = java.sql.Date.valueOf(weekStart);
            int count = map.getOrDefault(weekStart, 0);

            if (isChurn) {
                result.add((T) new EarlyChurnByWeekDto(date, count));
            } else {
                result.add((T) new NewUsersByWeekDto(date, count));
            }
        }
        return result;
    }
}
