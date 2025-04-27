package com.hcmus.statisticservice.service;

import com.hcmus.statisticservice.dto.request.UpdateProfileRequest;
import com.hcmus.statisticservice.dto.response.ApiResponse;
import com.hcmus.statisticservice.dto.response.FitProfileResponse;
import com.hcmus.statisticservice.exception.StatisticException;
import com.hcmus.statisticservice.mapper.FitProfileMapper;
import com.hcmus.statisticservice.model.FitProfile;
import com.hcmus.statisticservice.model.type.ActivityLevel;
import com.hcmus.statisticservice.model.type.Gender;
import com.hcmus.statisticservice.repository.FitProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FitProfileServiceImpl implements FitProfileService {

    final private FitProfileRepository fitProfileRepository;
    final private FitProfileMapper fitProfileMapper;
    final private NutritionGoalService nutritionGoalService;

    @Override
    public FitProfile findProfile(UUID userID) {
        return fitProfileRepository.findByUserId(userID).orElseThrow(
                () -> new StatisticException("Fit profile not found!")
        );
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public FitProfile addProfile(UUID userId, FitProfile addProfile) {
        if (fitProfileRepository.existsByUserId(userId)) {
            throw new StatisticException("Fit profile already exists!");
        }
        FitProfile profile = FitProfile.builder()
                .name(addProfile.getName())
                .age(addProfile.getAge())
                .gender(addProfile.getGender())
                .height(addProfile.getHeight())
                .activityLevel(addProfile.getActivityLevel())
                .imageUrl(addProfile.getImageUrl())
                .userId(userId)
                .build();
        return fitProfileRepository.save(profile);
    }

    @Override
    public FitProfile updateProfile(UUID userId, FitProfile updateProfile) {
        FitProfile profile = findProfile(userId);

        profile.setName(updateProfile.getName() == null ? profile.getName() : updateProfile.getName());
        profile.setAge(updateProfile.getAge() == null ? profile.getAge() : updateProfile.getAge());
        profile.setGender(updateProfile.getGender() == null ? profile.getGender() : updateProfile.getGender());
        profile.setHeight(updateProfile.getHeight() == null ? profile.getHeight() : updateProfile.getHeight());
        profile.setActivityLevel(updateProfile.getActivityLevel() == null ? profile.getActivityLevel() : updateProfile.getActivityLevel());
        profile.setImageUrl(updateProfile.getImageUrl() == null ? profile.getImageUrl() : updateProfile.getImageUrl());

        return fitProfileRepository.save(profile);
    }

    @Override
    public ApiResponse<FitProfileResponse> getFindProfileResponse(UUID userID) {
        FitProfile profile = findProfile(userID);
        FitProfileResponse fitProfileResponse = fitProfileMapper.convertToFitProfileDto(profile);
        return ApiResponse.<FitProfileResponse>builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Get profile successfully!")
                .data(fitProfileResponse)
                .timestamp(LocalDateTime.now())
                .build();
    }

    @Override
    public ApiResponse<?> getUpdateProfileResponse(UUID userId, UpdateProfileRequest updateProfileRequest) {
        FitProfile updateProfile = FitProfile.builder()
                .name(updateProfileRequest.getName())
                .age(updateProfileRequest.getAge())
                .gender(Gender.fromString(updateProfileRequest.getGender()))
                .height(updateProfileRequest.getHeight())
                .activityLevel(ActivityLevel.valueOf(updateProfileRequest.getActivityLevel()))
                .imageUrl(updateProfileRequest.getImageUrl())
                .build();
        FitProfile savedProfile = updateProfile(userId, updateProfile);
        if (savedProfile == null) {
            throw new StatisticException("Failed to update profile!");
        }
        nutritionGoalService.updateNutritionGoal(userId, savedProfile);
        return ApiResponse.builder()
                .status(HttpStatus.OK.value())
                .generalMessage("Update profile successfully for " + updateProfile.getName() + "!")
                .timestamp(LocalDateTime.now())
                .build();
    }
}
