package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.request.UpdateWeightGoalRequest;
import com.hcmus.statisticservice.application.dto.request.WeightLogRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.GetWeightGoalResponse;
import com.hcmus.statisticservice.application.service.FitProfileService;
import com.hcmus.statisticservice.application.service.NutritionGoalService;
import com.hcmus.statisticservice.application.service.WeightGoalService;
import com.hcmus.statisticservice.application.service.WeightLogService;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import com.hcmus.statisticservice.domain.repository.WeightGoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeightGoalServiceImpl implements WeightGoalService {

    private final WeightGoalRepository weightGoalRepository;
    private final WeightLogService weightLogService;
    private final FitProfileService fitProfileService;
    private final NutritionGoalService nutritionGoalService;

    @Override
    public WeightGoal updateWeightGoal(UUID userId, WeightGoal updateWeightGoal) {
        WeightGoal weightGoal = findWeightGoal(userId);

        weightGoal.setStartingWeight(
                updateWeightGoal.getStartingWeight() != null ? updateWeightGoal.getStartingWeight()
                        : weightGoal.getStartingWeight());
        weightGoal.setStartingDate(
                updateWeightGoal.getStartingDate() != null ? updateWeightGoal.getStartingDate()
                        : weightGoal.getStartingDate());
        weightGoal.setWeeklyGoal(updateWeightGoal.getWeeklyGoal() != null ? updateWeightGoal.getWeeklyGoal()
                : weightGoal.getWeeklyGoal());
        weightGoal.setGoalWeight(updateWeightGoal.getGoalWeight() != null ? updateWeightGoal.getGoalWeight()
                : weightGoal.getGoalWeight());

        return weightGoalRepository.save(weightGoal);
    }

    @Override
    public WeightGoal findWeightGoal(UUID userId) {
        return weightGoalRepository.findByUserId(userId)
                .orElseThrow(() -> new StatisticException("Weight goal not found!"));
    }

    @Override
    public WeightGoal addWeightGoal(UUID userId, WeightGoal addWeightGoal) {
        if (weightGoalRepository.existsByUserId(userId)) {
            throw new StatisticException("Weight goal already exists!");
        }
        WeightGoal weightGoal = WeightGoal.builder()
                .goalWeight(addWeightGoal.getGoalWeight())
                .weeklyGoal(addWeightGoal.getWeeklyGoal())
                .startingWeight(addWeightGoal.getStartingWeight())
                .startingDate(addWeightGoal.getStartingDate())
                .userId(userId)
                .build();
        return weightGoalRepository.save(weightGoal);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ApiResponse<?> getUpdateWeightGoalResponse(UUID userId,
                                                      UpdateWeightGoalRequest updateWeightGoalRequest) {
        WeightGoal weightGoal = WeightGoal.builder()
                .goalWeight(updateWeightGoalRequest.getGoalWeight())
                .weeklyGoal(updateWeightGoalRequest.getWeeklyGoal())
                .startingWeight(updateWeightGoalRequest.getStartingWeight())
                .startingDate(updateWeightGoalRequest.getStartingDate())
                .userId(userId)
                .build();
        WeightGoal savedWeightGoal = updateWeightGoal(userId, weightGoal);
        if (savedWeightGoal == null) {
            throw new StatisticException("Failed to update weight goal!");
        }

        FitProfile profile = new FitProfile();
        profile.setActivityLevel(ActivityLevel.fromString(updateWeightGoalRequest.getActivityLevel()));
        fitProfileService.updateProfile(userId, profile);

        weightLogService.trackWeight(userId,
                WeightLogRequest.builder()
                        .updateDate(Date.from(ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"))
                                .toInstant()))
                        .weight(updateWeightGoalRequest.getCurrentWeight())
                        .build());

        nutritionGoalService.updateNutritionGoal(
                userId,
                savedWeightGoal,
                updateWeightGoalRequest.getCurrentWeight(),
                ActivityLevel.fromString(updateWeightGoalRequest.getActivityLevel()));

        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Update weight goal successfully for " + profile.getName() + "!")
                .build();
    }

    @Transactional
    public ApiResponse<GetWeightGoalResponse> getWeightGoal(UUID userId) {
        WeightGoal weightGoal = findWeightGoal(userId);
        Double currentWeight = weightLogService.getCurrentWeight(userId);
        ActivityLevel activityLevel = fitProfileService.findProfile(userId).getActivityLevel();

        GetWeightGoalResponse getWeightGoalResponse = GetWeightGoalResponse.builder()
                .startingDate(weightGoal.getStartingDate())
                .startingWeight(weightGoal.getStartingWeight())
                .currentWeight(currentWeight)
                .goalWeight(weightGoal.getGoalWeight())
                .weeklyGoal(weightGoal.getWeeklyGoal())
                .activityLevel(activityLevel.name())
                .build();

        return ApiResponse.<GetWeightGoalResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Successfully retrieved goal!")
                .data(getWeightGoalResponse)
                .build();
    }
}
