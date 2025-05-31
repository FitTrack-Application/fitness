package com.hcmus.statisticservice.application.service.impl;

import com.hcmus.statisticservice.application.dto.request.SaveSurveyRequest;
import com.hcmus.statisticservice.application.dto.response.ApiResponse;
import com.hcmus.statisticservice.application.dto.response.CheckSurveyResponse;
import com.hcmus.statisticservice.application.service.*;
import com.hcmus.statisticservice.domain.exception.StatisticException;
import com.hcmus.statisticservice.domain.model.FitProfile;
import com.hcmus.statisticservice.domain.model.NutritionGoal;
import com.hcmus.statisticservice.domain.model.WeightGoal;
import com.hcmus.statisticservice.domain.model.WeightLog;
import com.hcmus.statisticservice.domain.model.type.ActivityLevel;
import com.hcmus.statisticservice.domain.model.type.Gender;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZoneId;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SurveyServiceImpl implements SurveyService {

    final private FitProfileService fitProfileService;
    final private WeightGoalService weightGoalService;
    final private NutritionGoalService nutritionGoalService;
    final private WeightLogService weightLogService;

    @Override
    public ApiResponse<CheckSurveyResponse> getCheckSurveyResponse(UUID userId) {
        CheckSurveyResponse checkResponse = new CheckSurveyResponse(true);
        try {
            fitProfileService.findProfile(userId);
        } catch (RuntimeException e) {
            checkResponse.setHasSurvey(false);
        }
        return ApiResponse.<CheckSurveyResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Check survey successfully!")
                .data(checkResponse)
                .build();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ApiResponse<?> saveSurvey(UUID userId, SaveSurveyRequest saveSurveyRequest) {
        FitProfile profile = FitProfile.builder()
                .name(saveSurveyRequest.getName())
                .age(saveSurveyRequest.getAge())
                .height(saveSurveyRequest.getHeight())
                .gender(Gender.fromString(saveSurveyRequest.getGender()))
                .activityLevel(ActivityLevel.fromString(saveSurveyRequest.getActivityLevel()))
                .imageUrl(saveSurveyRequest.getImageUrl())
                .userId(userId)
                .build();

        WeightGoal weightGoal = WeightGoal.builder()
                .startingWeight(saveSurveyRequest.getWeight())
                .startingDate(saveSurveyRequest.getStartingDate())
                .goalWeight(saveSurveyRequest.getGoalWeight())
                .weeklyGoal(saveSurveyRequest.getWeeklyGoal())
                .userId(userId)
                .build();

        WeightLog weightLog = WeightLog.builder()
                .weight(saveSurveyRequest.getWeight())
                .date(saveSurveyRequest.getStartingDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate())
                .imageUrl(saveSurveyRequest.getImageUrl())
                .userId(userId)
                .build();

        FitProfile savedProfile = fitProfileService.addProfile(userId, profile);
        WeightGoal savedWeightGoal = weightGoalService.addWeightGoal(userId, weightGoal);
        weightLogService.trackWeight(userId, weightLog);
        if (savedProfile == null || savedWeightGoal == null) {
            throw new StatisticException("Failed to save survey!");
        }

        NutritionGoal nutritionGoal = nutritionGoalService.updateNutritionGoal(
                userId,
                savedProfile,
                savedWeightGoal,
                weightLog.getWeight());

        if (nutritionGoal == null) {
            throw new StatisticException("Failed to save nutrition goal!");
        }

        return ApiResponse.builder()
                .status(HttpStatus.CREATED.value())
                .generalMessage("Save survey successfully!")
                .build();
    }
}